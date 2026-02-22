import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:snake_game_classic/app/data/enums/direction.dart';

class DPad extends StatelessWidget {
  final void Function(Direction) onDirection;

  const DPad({super.key, required this.onDirection});

  @override
  Widget build(BuildContext context) {
    final btnSize = 56.r;
    const gap = SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DPadButton(
          icon: Icons.keyboard_arrow_up_rounded,
          size: btnSize,
          onTap: () => onDirection(Direction.up),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DPadButton(
              icon: Icons.keyboard_arrow_left_rounded,
              size: btnSize,
              onTap: () => onDirection(Direction.left),
            ),
            SizedBox(width: btnSize, height: btnSize, child: gap),
            _DPadButton(
              icon: Icons.keyboard_arrow_right_rounded,
              size: btnSize,
              onTap: () => onDirection(Direction.right),
            ),
          ],
        ),
        _DPadButton(
          icon: Icons.keyboard_arrow_down_rounded,
          size: btnSize,
          onTap: () => onDirection(Direction.down),
        ),
      ],
    );
  }
}

class _DPadButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  const _DPadButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: size * 0.6, color: cs.onSurface),
      ),
    );
  }
}
