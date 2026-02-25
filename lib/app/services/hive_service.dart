// ================================================
// DangunDad Flutter App - hive_service.dart Template
// ================================================
// snake_game_classic 치환 후 사용
// mbti_pro 프로덕션 패턴 기반

// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:snake_game_classic/app/data/models/snake_record.dart';
import 'package:snake_game_classic/hive_registrar.g.dart';


class HiveService extends GetxService {
  static HiveService get to => Get.find();

  // Box 이름 상수
  static const String SETTINGS_BOX = 'settings';
  static const String APP_DATA_BOX = 'app_data';
  static const String SNAKE_RECORDS_BOX = 'snake_records';

  // Box Getters
  Box get settingsBox => Hive.box(SETTINGS_BOX);
  Box get appDataBox => Hive.box(APP_DATA_BOX);
  Box<SnakeRecord> get snakeRecordsBox => Hive.box<SnakeRecord>(SNAKE_RECORDS_BOX);

  /// Hive 초기화 (main.dart에서 await 호출)
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();

    await Future.wait([
      Hive.openBox(SETTINGS_BOX),
      Hive.openBox(APP_DATA_BOX),
      Hive.openBox<SnakeRecord>(SNAKE_RECORDS_BOX),
    ]);

    Get.log('Hive 초기화 완료');
  }

  // ============================================
  // 설정 관리 (generic key-value)
  // ============================================

  T? getSetting<T>(String key, {T? defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> setSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  // ============================================
  // 앱 데이터 관리 (generic key-value)
  // ============================================

  T? getAppData<T>(String key, {T? defaultValue}) {
    return appDataBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> setAppData(String key, dynamic value) async {
    await appDataBox.put(key, value);
  }

  // ============================================
  // SnakeRecord CRUD (최대 10개)
  // ============================================

  static const int _maxRecords = 10;

  List<SnakeRecord> getSnakeRecords() {
    final records = snakeRecordsBox.values.toList();
    records.sort((a, b) => b.score.compareTo(a.score));
    return records;
  }

  Future<void> addSnakeRecord(SnakeRecord record) async {
    await snakeRecordsBox.add(record);
    // 최대 개수 초과 시 가장 낮은 점수 삭제
    if (snakeRecordsBox.length > _maxRecords) {
      final all = snakeRecordsBox.values.toList();
      all.sort((a, b) => a.score.compareTo(b.score));
      await all.first.delete();
    }
  }

  Future<void> clearSnakeRecords() async {
    await snakeRecordsBox.clear();
  }

  // ============================================
  // 데이터 관리
  // ============================================

  Future<void> clearAllData() async {
    await Future.wait([
      settingsBox.clear(),
      appDataBox.clear(),
      snakeRecordsBox.clear(),
    ]);
    Get.log('모든 데이터 삭제 완료');
  }
}
