import 'package:flutter/material.dart';

import '../../domain/game/game_rules.dart';

class HangmanFigure extends StatelessWidget {
  const HangmanFigure({super.key, required this.mistakes});

  final int mistakes;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: CustomPaint(
        painter: _HangmanPainter(
          mistakes: mistakes.clamp(0, kMaxMistakes),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _HangmanPainter extends CustomPainter {
  const _HangmanPainter({required this.mistakes, required this.color});

  final int mistakes;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.02;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final baseY = h * 0.95;

    canvas.drawLine(Offset(w * 0.10, baseY), Offset(w * 0.60, baseY), paint);
    canvas.drawLine(Offset(w * 0.20, baseY), Offset(w * 0.20, h * 0.05), paint);
    canvas.drawLine(
      Offset(w * 0.20, h * 0.05),
      Offset(w * 0.60, h * 0.05),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.60, h * 0.05),
      Offset(w * 0.60, h * 0.18),
      paint,
    );

    if (mistakes >= 1) {
      canvas.drawCircle(Offset(w * 0.60, h * 0.26), h * 0.08, paint);
    }
    if (mistakes >= 2) {
      canvas.drawLine(
        Offset(w * 0.60, h * 0.34),
        Offset(w * 0.60, h * 0.60),
        paint,
      );
    }
    if (mistakes >= 3) {
      canvas.drawLine(
        Offset(w * 0.60, h * 0.40),
        Offset(w * 0.45, h * 0.50),
        paint,
      );
    }
    if (mistakes >= 4) {
      canvas.drawLine(
        Offset(w * 0.60, h * 0.40),
        Offset(w * 0.75, h * 0.50),
        paint,
      );
    }
    if (mistakes >= 5) {
      canvas.drawLine(
        Offset(w * 0.60, h * 0.60),
        Offset(w * 0.48, h * 0.80),
        paint,
      );
    }
    if (mistakes >= 6) {
      canvas.drawLine(
        Offset(w * 0.60, h * 0.60),
        Offset(w * 0.72, h * 0.80),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_HangmanPainter old) =>
      old.mistakes != mistakes || old.color != color;
}
