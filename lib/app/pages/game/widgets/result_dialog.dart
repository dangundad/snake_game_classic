import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:snake_game_classic/app/controllers/game_controller.dart';

class GameOverDialog extends GetView<GameController> {
  const GameOverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💀', style: TextStyle(fontSize: 52.sp)),
            SizedBox(height: 8.h),
            Text(
              'game_over'.tr,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: cs.error,
              ),
            ),
            SizedBox(height: 16.h),

            // Score display
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Obx(
                () => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'game_score'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${controller.score.value}',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'game_best'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        Row(
                          children: [
                            if (controller.isNewBest.value) ...[
                              Text(
                                '🏆 ',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                            Text(
                              '${controller.highScore.value}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: controller.isNewBest.value
                                    ? const Color(0xFFFFD600)
                                    : cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('home'.tr),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Get.back();
                      controller.startGame();
                    },
                    child: Text('play_again'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PauseDialog extends GetView<GameController> {
  const PauseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('⏸️', style: TextStyle(fontSize: 48.sp)),
            SizedBox(height: 8.h),
            Text(
              'game_paused'.tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => Text(
                '${'game_score'.tr}: ${controller.score.value}',
                style: TextStyle(fontSize: 14.sp, color: cs.onSurfaceVariant),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Get.back();
                  controller.resumeGame();
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text('game_resume'.tr),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: Text('home'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
