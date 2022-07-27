import 'dart:math';

import 'package:flutter/material.dart';

class OvalPainter extends CustomPainter {
  final double percent;
  final Color color;
  OvalPainter({
    required this.percent,
    this.color = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var radius = min(size.width, size.height);
    var strokeWidth = radius * 0.5;
    var width = radius * percent;
    var path = Path();
    path.addOval(Rect.fromCenter(
        center: Offset(radius / 2, radius / 2), width: width, height: radius));
    drawShadow(canvas, path, strokeWidth);
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);
  }

  drawShadow(Canvas canvas, Path path, double strokeWidth) {
    canvas.drawPath(
        path,
        Paint()
          ..color = color.withAlpha(200)
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..maskFilter =
              MaskFilter.blur(BlurStyle.outer, convertRadiusToSigma(3)));
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(OvalPainter oldDelegate) =>
      percent != oldDelegate.percent ||
      color != oldDelegate.color;
}
