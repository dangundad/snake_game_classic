import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:snake_game_classic/app/admob/ads_banner.dart';
import 'package:snake_game_classic/app/admob/ads_helper.dart';
import 'package:snake_game_classic/app/controllers/game_controller.dart';
import 'package:snake_game_classic/app/data/enums/snake_skin.dart';
import 'package:snake_game_classic/app/routes/app_pages.dart';

class HomePage extends GetView<GameController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primary.withValues(alpha: 0.16),
              cs.surface,
              cs.secondaryContainer.withValues(alpha: 0.22),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 18.h),
                      const _DecorLayer(),
                      SizedBox(height: 16.h),
                      const _AppHeader(),
                      SizedBox(height: 18.h),
                      _HighScoreCard(controller: controller),
                      SizedBox(height: 18.h),
                      _PlayButton(controller: controller),
                      SizedBox(height: 16.h),
                      _WallModeToggle(controller: controller),
                      SizedBox(height: 18.h),
                      _SkinSelector(controller: controller),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              Container(
                color: cs.surface.withValues(alpha: 0.92),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                      top: 8.h,
                      bottom: 10.h,
                    ),
                    child: BannerAdWidget(
                      adUnitId: AdHelper.bannerAdUnitId,
                      type: AdHelper.banner,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorLayer extends StatelessWidget {
  const _DecorLayer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.22),
            cs.tertiary.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10.h,
            right: 16.w,
            child: Icon(
              Icons.auto_graph_rounded,
              size: 40.r,
              color: cs.primary.withValues(alpha: 0.16),
            ),
          ),
          Positioned(
            bottom: 12.h,
            left: 14.w,
            child: Icon(
              Icons.bolt_rounded,
              size: 34.r,
              color: cs.secondary.withValues(alpha: 0.16),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.96, end: 1.0),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutBack,
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: child,
                ),
                child: Text(
                  '🐍',
                  style: TextStyle(fontSize: 44.sp, color: cs.onSurface.withValues(alpha: 0.7)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 680),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 12),
              child: child,
            ),
          ),
          child: Text(
            'app_name'.tr,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
              letterSpacing: 0.6,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.88, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: const Interval(0.35, 1, curve: Curves.easeOut),
          builder: (ctx, value, child) => Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 8),
              child: child,
            ),
          ),
          child: Text(
            'home_subtitle'.tr,
            style: TextStyle(
              fontSize: 13.sp,
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
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

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (ctx, value, child) => Transform.scale(
        scale: 0.8 + (0.2 * value),
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 22.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primary,
              cs.tertiary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.38),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Obx(() {
          final score = controller.highScore.value;
          final hasScore = score > 0;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_rounded,
                    color: const Color(0xFFFFD600),
                    size: 26.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'home_best_score'.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimary.withValues(alpha: 0.9),
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              if (hasScore) ...[
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 54.sp,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: cs.onPrimary,
                    shadows: const [
                      Shadow(color: Color(0x40000000), blurRadius: 12),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'home_pts'.tr,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onPrimary.withValues(alpha: 0.85),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(height: 4.h),
                Icon(
                  Icons.sports_esports_rounded,
                  size: 36.r,
                  color: cs.onPrimary.withValues(alpha: 0.45),
                ),
                SizedBox(height: 6.h),
                Text(
                  'home_no_score'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: cs.onPrimary.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  final GameController controller;

  const _PlayButton({required this.controller});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnim.value,
        child: child,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.tertiary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              widget.controller.startGame();
              Get.toNamed(Routes.GAME);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rocket_launch_rounded, size: 28.r, color: cs.onPrimary),
                  SizedBox(width: 10.w),
                  Text(
                    'home_play'.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        SizedBox(height: 10.h),
        Row(
          children: SnakeSkin.values.map((skin) {
            final isLast = skin == SnakeSkin.values.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 8.w),
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
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected ? cs.primaryContainer : cs.surfaceContainerHigh.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? cs.primary : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.22),
                      blurRadius: 12,
                      spreadRadius: 0.3,
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: skin.bgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Container(
                    width: 22.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      color: skin.bodyColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_rounded, size: 12.r, color: cs.onSurfaceVariant),
                      SizedBox(width: 3.w),
                      Text(
                        'skin_locked'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 8.sp, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
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
    return Obx(
      () {
        final enabled = controller.wallMode.value;

        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: enabled ? cs.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: enabled,
            onChanged: (_) => controller.toggleWallMode(),
            title: Row(
              children: [
                Icon(Icons.crop_free_rounded, color: cs.primary, size: 22.r),
                SizedBox(width: 10.w),
                Text(
                  'home_wall_mode'.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 2.h, right: 4.w),
              child: Text(
                enabled ? 'home_wall_mode_on'.tr : 'home_wall_mode_off'.tr,
                style: TextStyle(fontSize: 11.sp, color: cs.onSurfaceVariant),
              ),
            ),
            activeThumbColor: cs.primary,
          ),
        );
      },
    );
  }
}
