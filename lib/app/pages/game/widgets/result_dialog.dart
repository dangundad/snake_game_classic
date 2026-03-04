import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:snake_game_classic/app/controllers/game_controller.dart';

class GameOverDialog extends GetView<GameController> {
  const GameOverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.errorContainer, cs.error.withValues(alpha: 0.3)],
              ),
            ),
            child: Center(
              child: Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.error.withValues(alpha: 0.15),
                ),
                child: Icon(LucideIcons.skull, size: 26.r, color: cs.error),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
            child: Column(
              children: [
                Text(
                  'game_over'.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.error,
                  ),
                ),
                SizedBox(height: 16.h),
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
                                  Icon(
                                    LucideIcons.trophy,
                                    size: 14.r,
                                    color: const Color(0xFFFFD600),
                                  ),
                                  SizedBox(width: 4.w),
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text('home'.tr),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          Get.back();
                          controller.startGame();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Center(
                            child: Text(
                              'play_again'.tr,
                              style: TextStyle(
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PauseDialog extends GetView<GameController> {
  const PauseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primaryContainer, cs.primary.withValues(alpha: 0.3)],
              ),
            ),
            child: Center(
              child: Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.primary.withValues(alpha: 0.15),
                ),
                child: Icon(LucideIcons.pause, size: 26.r, color: cs.primary),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
            child: Column(
              children: [
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.tertiary],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        Get.back();
                        controller.resumeGame();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.play, size: 18.r, color: cs.onPrimary),
                            SizedBox(width: 8.w),
                            Text(
                              'game_resume'.tr,
                              style: TextStyle(
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('home'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
