import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:snake_game_classic/app/admob/ads_interstitial.dart';
import 'package:snake_game_classic/app/admob/ads_rewarded.dart';
import 'package:snake_game_classic/app/data/enums/direction.dart';
import 'package:snake_game_classic/app/data/enums/game_status.dart';
import 'package:snake_game_classic/app/data/enums/snake_skin.dart';
import 'package:snake_game_classic/app/services/hive_service.dart';

class SnakePoint {
  final int row;
  final int col;

  const SnakePoint(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      other is SnakePoint && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);
}

class GameController extends GetxController {
  static GameController get to => Get.find();

  static const int rows = 20;
  static const int cols = 20;
  static const int _baseIntervalMs = 200;
  static const int _minIntervalMs = 80;
  static const int _speedStepMs = 15;
  static const int _foodsPerSpeedup = 5;
  static const int _goldenFoodScore = 20;
  static const int _normalFoodScore = 10;
  static const int _goldenFoodDuration = 5;

  // Hive keys
  static const _highScoreKey = 'snake_high_score';
  static const _unlockedSkinsKey = 'snake_unlocked_skins';
  static const _wallModeKey = 'snake_wall_mode';
  static const _skinKey = 'snake_selected_skin';

  // Observable state
  final RxInt tick = 0.obs;
  final status = GameStatus.idle.obs;
  final score = 0.obs;
  final highScore = 0.obs;
  final skin = SnakeSkin.classic.obs;
  final wallMode = false.obs;
  final unlockedSkins = <SnakeSkin>{SnakeSkin.classic}.obs;
  final hasGoldenFood = false.obs;
  final goldenFoodSecondsLeft = 0.obs;
  final isNewBest = false.obs;

  // Internal game state
  final List<SnakePoint> snake = [];
  late SnakePoint _food;
  SnakePoint? _goldenFood;
  Direction _direction = Direction.right;
  Direction? _pendingDirection;
  Timer? _gameTimer;
  Timer? _goldenFoodCountdown;
  int _foodsEaten = 0;
  int _intervalMs = _baseIntervalMs;
  int _goldenFoodTimer = 0;

  // Getters for painter
  SnakePoint get food => _food;
  SnakePoint? get goldenFood => _goldenFood;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
    _initSnake();
    _spawnFood();
  }

  @override
  void onClose() {
    _gameTimer?.cancel();
    _goldenFoodCountdown?.cancel();
    super.onClose();
  }

  void _loadPreferences() {
    highScore.value = HiveService.to.getAppData<int>(_highScoreKey) ?? 0;
    wallMode.value = HiveService.to.getAppData<bool>(_wallModeKey) ?? false;

    final savedSkinIndex = HiveService.to.getAppData<int>(_skinKey) ?? 0;
    if (savedSkinIndex < SnakeSkin.values.length) {
      skin.value = SnakeSkin.values[savedSkinIndex];
    }

    final savedUnlocked =
        HiveService.to.getAppData<List<dynamic>>(_unlockedSkinsKey);
    if (savedUnlocked != null) {
      unlockedSkins
        ..clear()
        ..addAll(savedUnlocked.map((e) => SnakeSkin.values[e as int]));
    }
  }

  void _savePreferences() {
    HiveService.to.setAppData(_highScoreKey, highScore.value);
    HiveService.to.setAppData(_wallModeKey, wallMode.value);
    HiveService.to.setAppData(_skinKey, skin.value.index);
    HiveService.to.setAppData(
      _unlockedSkinsKey,
      unlockedSkins.map((s) => s.index).toList(),
    );
  }

  void startGame() {
    _gameTimer?.cancel();
    _goldenFoodCountdown?.cancel();
    _initSnake();
    _spawnFood();
    _goldenFood = null;
    hasGoldenFood.value = false;
    score.value = 0;
    _foodsEaten = 0;
    _intervalMs = _baseIntervalMs;
    _direction = Direction.right;
    _pendingDirection = null;
    isNewBest.value = false;
    status.value = GameStatus.playing;
    _startTimer();
  }

  void pauseGame() {
    if (status.value != GameStatus.playing) return;
    _gameTimer?.cancel();
    _goldenFoodCountdown?.cancel();
    status.value = GameStatus.paused;
  }

  void resumeGame() {
    if (status.value != GameStatus.paused) return;
    status.value = GameStatus.playing;
    _startTimer();
  }

  void changeDirection(Direction dir) {
    if (status.value != GameStatus.playing) return;
    if (!_direction.isOpposite(dir)) {
      _pendingDirection = dir;
    }
  }

  void toggleWallMode() {
    wallMode.value = !wallMode.value;
    HiveService.to.setAppData(_wallModeKey, wallMode.value);
  }

  void selectSkin(SnakeSkin s) {
    if (!unlockedSkins.contains(s)) return;
    skin.value = s;
    HiveService.to.setAppData(_skinKey, s.index);
  }

  void unlockSkin(SnakeSkin s) {
    RewardedAdManager.to.showAdIfAvailable(
      onUserEarnedReward: (RewardItem _) {
        unlockedSkins.add(s);
        skin.value = s;
        _savePreferences();
        Get.snackbar('', 's_unlocked'.trParams({'skin': s.labelKey.tr}));
      },
    );
  }

  bool isSkinUnlocked(SnakeSkin s) => unlockedSkins.contains(s);

  void _initSnake() {
    snake.clear();
    snake.add(SnakePoint(rows ~/ 2, cols ~/ 2));
    snake.add(SnakePoint(rows ~/ 2, cols ~/ 2 - 1));
    snake.add(SnakePoint(rows ~/ 2, cols ~/ 2 - 2));
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(
      Duration(milliseconds: _intervalMs),
      (_) => _tick(),
    );
    if (hasGoldenFood.value) {
      _startGoldenFoodCountdown();
    }
  }

  void _tick() {
    if (status.value != GameStatus.playing) return;

    if (_pendingDirection != null) {
      if (!_direction.isOpposite(_pendingDirection!)) {
        _direction = _pendingDirection!;
      }
      _pendingDirection = null;
    }

    final head = snake.first;
    int newRow = head.row + _direction.dRow;
    int newCol = head.col + _direction.dCol;

    if (wallMode.value) {
      if (newRow < 0 || newRow >= rows || newCol < 0 || newCol >= cols) {
        _gameOver();
        return;
      }
    } else {
      newRow = (newRow + rows) % rows;
      newCol = (newCol + cols) % cols;
    }

    final newHead = SnakePoint(newRow, newCol);

    if (snake.sublist(0, snake.length - 1).contains(newHead)) {
      _gameOver();
      return;
    }

    bool ate = false;
    if (newHead == _food) {
      ate = true;
      _foodsEaten++;
      score.value += _normalFoodScore;
      _spawnFood();
      _maybeSpawnGoldenFood();
      _adjustSpeed();
    } else if (_goldenFood != null && newHead == _goldenFood) {
      ate = true;
      score.value += _goldenFoodScore;
      _goldenFood = null;
      hasGoldenFood.value = false;
      _goldenFoodCountdown?.cancel();
    }

    snake.insert(0, newHead);
    if (!ate) snake.removeLast();

    if (score.value > highScore.value) {
      highScore.value = score.value;
      isNewBest.value = true;
    }

    tick.value++;
  }

  void _spawnFood() {
    final random = Random();
    SnakePoint candidate;
    do {
      candidate = SnakePoint(random.nextInt(rows), random.nextInt(cols));
    } while (
      snake.contains(candidate) ||
      (_goldenFood != null && candidate == _goldenFood)
    );
    _food = candidate;
  }

  void _maybeSpawnGoldenFood() {
    if (hasGoldenFood.value || _foodsEaten < 3) return;
    if (Random().nextDouble() < 0.5) _spawnGoldenFood();
  }

  void _spawnGoldenFood() {
    final random = Random();
    SnakePoint candidate;
    do {
      candidate = SnakePoint(random.nextInt(rows), random.nextInt(cols));
    } while (snake.contains(candidate) || candidate == _food);
    _goldenFood = candidate;
    hasGoldenFood.value = true;
    _goldenFoodTimer = _goldenFoodDuration;
    goldenFoodSecondsLeft.value = _goldenFoodDuration;
    _startGoldenFoodCountdown();
  }

  void _startGoldenFoodCountdown() {
    _goldenFoodCountdown?.cancel();
    _goldenFoodCountdown = Timer.periodic(const Duration(seconds: 1), (_) {
      _goldenFoodTimer--;
      goldenFoodSecondsLeft.value = _goldenFoodTimer;
      if (_goldenFoodTimer <= 0) {
        _goldenFood = null;
        hasGoldenFood.value = false;
        _goldenFoodCountdown?.cancel();
        tick.value++;
      }
    });
  }

  void _adjustSpeed() {
    if (_foodsEaten % _foodsPerSpeedup == 0) {
      _intervalMs =
          (_intervalMs - _speedStepMs).clamp(_minIntervalMs, _baseIntervalMs);
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(
        Duration(milliseconds: _intervalMs),
        (_) => _tick(),
      );
    }
  }

  void _gameOver() {
    _gameTimer?.cancel();
    _goldenFoodCountdown?.cancel();
    status.value = GameStatus.over;
    _savePreferences();
    InterstitialAdManager.to.showAdIfAvailable();
  }
}
