import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:snake_game_classic/app/controllers/game_controller.dart';
import 'package:snake_game_classic/app/data/enums/snake_skin.dart';

class GameBoard extends StatefulWidget {
  final GameController controller;

  const GameBoard({super.key, required this.controller});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = widget.controller.tick.value;
      final skin = widget.controller.skin.value;

      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, _) {
          return CustomPaint(
            painter: _SnakePainter(
              controller: widget.controller,
              skin: skin,
              pulseValue: _pulseAnimation.value,
            ),
          );
        },
      );
    });
  }
}

class _SnakePainter extends CustomPainter {
  final GameController controller;
  final SnakeSkin skin;
  final double pulseValue;

  _SnakePainter({
    required this.controller,
    required this.skin,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / GameController.cols;
    final cellH = size.height / GameController.rows;
    final cellSize = min(cellW, cellH);

    _drawBackground(canvas, size);
    _drawGrid(canvas, size, cellSize);
    _drawFood(canvas, cellSize);
    _drawGoldenFood(canvas, cellSize);
    _drawSnake(canvas, cellSize);
  }

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = skin.bgColor,
    );
  }

  void _drawGrid(Canvas canvas, Size size, double cellSize) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    for (int r = 0; r <= GameController.rows; r++) {
      canvas.drawLine(
        Offset(0, r * cellSize),
        Offset(size.width, r * cellSize),
        paint,
      );
    }
    for (int c = 0; c <= GameController.cols; c++) {
      canvas.drawLine(
        Offset(c * cellSize, 0),
        Offset(c * cellSize, size.height),
        paint,
      );
    }
  }

  void _drawFood(Canvas canvas, double cellSize) {
    final food = controller.food;
    final cx = food.col * cellSize + cellSize / 2;
    final cy = food.row * cellSize + cellSize / 2;
    final r = cellSize * 0.38;

    // Glow
    canvas.drawCircle(
      Offset(cx, cy),
      r * 1.4,
      Paint()
        ..color = skin.foodColor.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // Body
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = skin.foodColor);
    // Shine
    canvas.drawCircle(
      Offset(cx - r * 0.3, cy - r * 0.3),
      r * 0.25,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
  }

  void _drawGoldenFood(Canvas canvas, double cellSize) {
    if (!controller.hasGoldenFood.value) return;
    final golden = controller.goldenFood;
    if (golden == null) return;

    final cx = golden.col * cellSize + cellSize / 2;
    final cy = golden.row * cellSize + cellSize / 2;
    final r = cellSize * 0.42 * pulseValue;
    const goldColor = Color(0xFFFFD600);

    // Glow
    canvas.drawCircle(
      Offset(cx, cy),
      r * 1.6,
      Paint()
        ..color = goldColor.withValues(alpha: 0.3 * pulseValue)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Star shape
    _drawStar(canvas, Offset(cx, cy), r, 5, goldColor);

    // Shine
    canvas.drawCircle(
      Offset(cx - r * 0.2, cy - r * 0.3),
      r * 0.2,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    double outerRadius,
    int points,
    Color color,
  ) {
    final innerRadius = outerRadius * 0.45;
    final path = Path();
    final angleStep = pi / points;

    for (int i = 0; i < points * 2; i++) {
      final angle = -pi / 2 + i * angleStep;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawSnake(Canvas canvas, double cellSize) {
    final snake = controller.snake;
    if (snake.isEmpty) return;

    final bodyPaint = Paint()..color = skin.bodyColor;
    final headPaint = Paint()..color = skin.headColor;

    final radius = Radius.circular(cellSize * 0.3);
    final padding = cellSize * 0.08;

    // Draw body segments (tail to head, so head is drawn last on top)
    for (int i = snake.length - 1; i >= 1; i--) {
      final pt = snake[i];
      final rect = Rect.fromLTWH(
        pt.col * cellSize + padding,
        pt.row * cellSize + padding,
        cellSize - padding * 2,
        cellSize - padding * 2,
      );

      // Slightly lighter for first body segment
      if (i == 1) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, radius),
          Paint()
            ..color = Color.lerp(skin.bodyColor, skin.headColor, 0.4)!,
        );
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), bodyPaint);
      }
    }

    // Draw head
    final head = snake.first;
    final headRect = Rect.fromLTWH(
      head.col * cellSize + padding * 0.5,
      head.row * cellSize + padding * 0.5,
      cellSize - padding,
      cellSize - padding,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(headRect, Radius.circular(cellSize * 0.35)),
      headPaint,
    );

    // Draw eyes on head
    _drawEyes(canvas, head, cellSize);
  }

  void _drawEyes(Canvas canvas, SnakePoint head, double cellSize) {
    final eyeRadius = cellSize * 0.1;
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;

    // Eye positions depend on direction
    final cx = head.col * cellSize + cellSize / 2;
    final cy = head.row * cellSize + cellSize / 2;

    final List<Offset> eyeOffsets = _getEyeOffsets(cellSize);

    for (final offset in eyeOffsets) {
      final eyePos = Offset(cx + offset.dx, cy + offset.dy);
      canvas.drawCircle(eyePos, eyeRadius, eyePaint);
      canvas.drawCircle(eyePos, eyeRadius * 0.55, pupilPaint);
    }
  }

  List<Offset> _getEyeOffsets(double cellSize) {
    const e = 0.22;
    const f = 0.18;
    // Return two eye positions relative to cell center
    return [
      Offset(-cellSize * e, -cellSize * f),
      Offset(cellSize * e, -cellSize * f),
    ];
  }

  @override
  bool shouldRepaint(_SnakePainter oldDelegate) =>
      oldDelegate.pulseValue != pulseValue ||
      oldDelegate.skin != skin;
}
