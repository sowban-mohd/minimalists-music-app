import 'package:flutter/material.dart';
import 'package:minimalists_music_app/core/theme/color_palette.dart';

class Tonearm extends CustomPainter {
  double rotationAngle; // in radians
  Tonearm({required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    //Pivot points for rotation (point representing the head of tonearm, acting as the base for rotation)
    final pivotX = size.width * 0.65;
    final pivotY = size.height * 0.10;

    canvas.save(); // Saves current canvas state

    // Moves to pivot point
    canvas.translate(pivotX, pivotY);

    // Applys rotation
    canvas.rotate(-rotationAngle);

    // Moves back after rotating
    canvas.translate(-pivotX, -pivotY);

    //Paint object to paint head and handle of the tonearm
    final headTailPaint = Paint()
      ..color = ColorPalette.tonearmColor
      ..style = PaintingStyle.fill;

    //Paint object to paint the stick part in tonearm
    final stickPaint = Paint()
      ..color = ColorPalette.tonearmColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    //Path object which helps in painting stick
    final Path path = Path();

    // Starting points of the tonearm
    // implying topleft of the head of tonearm, topright to the cd
    final double startX = size.width * 0.65;
    final double startY = size.height * 0.10;

    // Head Sizes
    double headWidth = 24;
    double headHeight = 28;

    // Draw Head (rectangle)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX, startY, headWidth, headHeight),
        Radius.circular(6),
      ),
      headTailPaint,
    );

    //Stick first part starting points
    double stickP1startX = startX + headWidth / 2;
    double stickP1startY = startY + headHeight;

    double stickP1EndY =
        stickP1startY + 40; //Stick first part ending point's y cordinate

    //First bend controllers
    double bend1ControlX = stickP1startX;
    double bend1ControlY = stickP1EndY + 10; // control point slightly below

    //Stick second part ending points
    double bend1EndX = stickP1startX + 20; // move sideways
    double bend1EndY = stickP1EndY + 40;

    //2nd Bend controllers
    double bend2ControlX = bend1EndX;
    double bend2ControlY = bend1EndY + 10;

    double bend2EndY = bend1EndY + 20; //Stick third part ending y cordinate

    //Moving to starting points to draw tonearm
    path.moveTo(stickP1startX, stickP1startY);

    // First straight segment down
    path.lineTo(stickP1startX, stickP1EndY);

    // First bend
    path.quadraticBezierTo(bend1ControlX, bend1ControlY, bend1EndX, bend1EndY);

    // Second bend
    path.quadraticBezierTo(bend2ControlX, bend2ControlY, bend1EndX, bend2EndY);

    //Draws the stick with given path
    canvas.drawPath(path, stickPaint);

    //Handle sizes
    double handleHeadWidth = 15;
    double handleHeadHeight = 27;
    double handleWidth = 22;
    double handleHeight = 8;

    //Handle coordinates
    double handleHeadStartX = bend1EndX - 8;
    double handleHeadStartY = bend2EndY - 10;
    double handleStartX = bend1EndX - 8;
    double handleStartY = bend2EndY + handleHeadHeight - 18;

    //Handle head
    final handleHead = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        handleHeadStartX,
        handleHeadStartY,
        handleHeadWidth,
        handleHeadHeight,
      ),
      Radius.circular(8),
    );

    //Draw Handlehead
    canvas.drawRRect(handleHead, headTailPaint);

    //Handle
    final handle = RRect.fromRectAndRadius(
      Rect.fromLTWH(handleStartX, handleStartY, handleWidth, handleHeight),
      Radius.circular(8),
    );

    //Draw Handle
    canvas.drawRRect(handle, headTailPaint);
    canvas.restore(); // restore the canvas to original state
  }

  @override
  bool shouldRepaint(covariant Tonearm oldDelegate) =>
      oldDelegate.rotationAngle != rotationAngle;
}
