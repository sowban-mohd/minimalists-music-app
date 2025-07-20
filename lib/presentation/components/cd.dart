import 'package:flutter/material.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';

class CD extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Center point for all three circles
    final center = Offset(size.width / 2, size.height / 2);

    // Outer white disc
    final discPaint = Paint()
      ..color = ColorPalette.mainCircleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.4, discPaint);

    // Light blue inner circle
    final innerPaint = Paint()
      ..color = ColorPalette.lightBlueCircleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.15, innerPaint);

    // Small dark dot in center
    final dotPaint = Paint()
      ..color = ColorPalette.darkBlueInnerCircleColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.025, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
