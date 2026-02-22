import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:snake_game_classic/app/controllers/game_controller.dart';
import 'package:snake_game_classic/app/data/enums/direction.dart';
import 'package:snake_game_classic/app/data/enums/game_status.dart';
import 'package:snake_game_classic/app/pages/game/widgets/d_pad.dart';
import 'package:snake_game_classic/app/pages/game/widgets/game_board.dart';
import 'package:snake_game_classic/app/pages/game/widgets/result_dialog.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameController controller;
  Worker? _statusWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GameController>();
    _statusWorker = ever(controller.status, (status) {
      if (status == GameStatus.over) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.isDialogOpen != true) {
            Get.dialog(
              const GameOverDialog(),
              barrierDismissible: false,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _statusWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (controller.status.value == GameStatus.playing) {
          controller.pauseGame();
          Get.dialog(const PauseDialog(), barrierDismissible: false);
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: controller.skin.value.bgColor,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: [
              _ScoreBar(controller: controller),
              Expanded(child: _buildGameArea()),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: controller.skin.value.bgColor,
      foregroundColor: Colors.white,
      title: Obx(
        () => Text(
          'app_name'.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Obx(() {
          final isPlaying = controller.status.value == GameStatus.playing;
          return IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.status.value == GameStatus.playing) {
                controller.pauseGame();
                Get.dialog(const PauseDialog(), barrierDismissible: false);
              } else if (controller.status.value == GameStatus.paused) {
                controller.resumeGame();
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildGameArea() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) < -100) {
          controller.changeDirection(Direction.up);
        } else if ((details.primaryVelocity ?? 0) > 100) {
          controller.changeDirection(Direction.down);
        }
      },
      onHorizontalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) < -100) {
          controller.changeDirection(Direction.left);
        } else if ((details.primaryVelocity ?? 0) > 100) {
          controller.changeDirection(Direction.right);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: AspectRatio(
          aspectRatio: GameController.cols / GameController.rows,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: GameBoard(controller: controller),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
      child: DPad(onDirection: controller.changeDirection),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final GameController controller;

  const _ScoreBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _StatChip(
                label: 'game_score'.tr,
                value: '${controller.score.value}',
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() {
            if (!controller.hasGoldenFood.value) return const SizedBox.shrink();
            return _GoldenFoodTimer(seconds: controller.goldenFoodSecondsLeft.value);
          }),
          SizedBox(width: 8.w),
          Expanded(
            child: Obx(
              () => _StatChip(
                label: 'game_best'.tr,
                value: '${controller.highScore.value}',
                color: const Color(0xFFFFD600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldenFoodTimer extends StatelessWidget {
  final int seconds;

  const _GoldenFoodTimer({required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD600).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFFFD600), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('⭐', style: TextStyle(fontSize: 12.sp)),
          SizedBox(width: 4.w),
          Text(
            '${seconds}s',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFFD600),
            ),
          ),
        ],
      ),
    );
  }
}
