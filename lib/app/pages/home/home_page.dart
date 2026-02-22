import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:snake_game_classic/app/controllers/game_controller.dart';
import 'package:snake_game_classic/app/data/enums/snake_skin.dart';
import 'package:snake_game_classic/app/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              _AppHeader(),
              SizedBox(height: 32.h),
              _HighScoreCard(controller: controller),
              SizedBox(height: 24.h),
              _PlayButton(controller: controller),
              SizedBox(height: 32.h),
              _SkinSelector(controller: controller),
              SizedBox(height: 24.h),
              _WallModeToggle(controller: controller),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          '🐍',
          style: TextStyle(fontSize: 64.sp),
        ),
        SizedBox(height: 12.h),
        Text(
          'app_name'.tr,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w900,
            color: cs.primary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'home_subtitle'.tr,
          style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HighScoreCard extends StatelessWidget {
  final GameController controller;

  const _HighScoreCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events_rounded, color: const Color(0xFFFFD600), size: 24.r),
              SizedBox(width: 8.w),
              Text(
                'home_best_score'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Text(
              '${controller.highScore.value}',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.w900,
                color: cs.onPrimaryContainer,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final GameController controller;

  const _PlayButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: FilledButton.icon(
        onPressed: () {
          controller.startGame();
          Get.toNamed(Routes.GAME);
        },
        icon: Icon(Icons.play_arrow_rounded, size: 28.r),
        label: Text(
          'home_play'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _SkinSelector extends StatelessWidget {
  final GameController controller;

  const _SkinSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home_skin'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: SnakeSkin.values.map((skin) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: skin == SnakeSkin.values.last ? 0 : 8.w,
                ),
                child: _SkinCard(skin: skin, controller: controller),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SkinCard extends StatelessWidget {
  final SnakeSkin skin;
  final GameController controller;

  const _SkinCard({required this.skin, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final isSelected = controller.skin.value == skin;
      final isUnlocked = controller.isSkinUnlocked(skin);

      return GestureDetector(
        onTap: () {
          if (isUnlocked) {
            controller.selectSkin(skin);
          } else {
            controller.unlockSkin(skin);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected ? cs.primaryContainer : cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? cs.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: skin.bgColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Container(
                    width: 20.r,
                    height: 12.r,
                    decoration: BoxDecoration(
                      color: skin.bodyColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                skin.labelKey.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? cs.primary : cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isUnlocked) ...[
                SizedBox(height: 4.h),
                Icon(
                  Icons.lock_rounded,
                  size: 14.r,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

class _WallModeToggle extends StatelessWidget {
  final GameController controller;

  const _WallModeToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(
        () => Row(
          children: [
            Icon(Icons.crop_rounded, color: cs.primary, size: 22.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'home_wall_mode'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    controller.wallMode.value
                        ? 'home_wall_mode_on'.tr
                        : 'home_wall_mode_off'.tr,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: controller.wallMode.value,
              onChanged: (_) => controller.toggleWallMode(),
            ),
          ],
        ),
      ),
    );
  }
}
