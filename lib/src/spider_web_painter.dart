import 'dart:math';
import 'package:flutter/material.dart';
import 'spider_web_config.dart';

class SpiderWebPainter extends CustomPainter {
  final Offset touchPosition;
  final SpiderWebConfig config;
  final List<Offset> webPoints = [];
  final Random random;

  SpiderWebPainter(this.touchPosition, {required this.config})
    : random = Random(config.randomSeed);

  @override
  void paint(Canvas canvas, Size size) {
    if (webPoints.isEmpty) {
      _initializeWeb(size);
    }

    List<Offset> warpedPoints = [];

    for (var point in webPoints) {
      double distance = (point - touchPosition).distance;

      if (distance < config.maxDistance) {
        warpedPoints.add(_warpPosition(point, touchPosition, distance));
      } else {
        warpedPoints.add(point);
      }
    }

    _drawWeb(canvas, size, warpedPoints);
  }

  void _initializeWeb(Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double maxRadius = size.shortestSide / 2;

    for (int r = 1; r <= config.circleDivisions; r++) {
      double radius = maxRadius * (r / config.circleDivisions);
      for (int i = 0; i < config.radialDivisions; i++) {
        double angle = (2 * pi / config.radialDivisions) * i;
        double randomOffset = (random.nextDouble() - 0.5) * radius * 0.05;
        Offset point = Offset(
          centerX + (radius + randomOffset) * cos(angle),
          centerY + (radius + randomOffset) * sin(angle),
        );
        webPoints.add(point);
      }
    }
  }

  void _drawWeb(Canvas canvas, Size size, List<Offset> warpedPoints) {
    Paint mainThreadPaint = Paint()
      ..color = config.threadColor
      ..strokeWidth = 1.5
      ..isAntiAlias = true;

    Paint radialThreadPaint = Paint()
      ..color = config.threadColor
      ..strokeWidth = 1.5
      ..isAntiAlias = true;

    Paint minorThreadPaint = Paint()
      ..color = config.minorThreadColor
      ..strokeWidth = 0.5
      ..isAntiAlias = true;

    for (int r = 0; r < config.circleDivisions; r++) {
      for (int i = 0; i < config.radialDivisions; i++) {
        int currentIndex = r * config.radialDivisions + i;
        int nextIndex = currentIndex + 1 < (r + 1) * config.radialDivisions
            ? currentIndex + 1
            : r * config.radialDivisions;
        int radialIndex =
            currentIndex + config.radialDivisions < warpedPoints.length
            ? currentIndex + config.radialDivisions
            : -1;

        if (nextIndex >= 0 && nextIndex < warpedPoints.length) {
          canvas.drawLine(
            warpedPoints[currentIndex],
            warpedPoints[nextIndex],
            mainThreadPaint,
          );
        }

        if (radialIndex >= 0) {
          canvas.drawLine(
            warpedPoints[currentIndex],
            warpedPoints[radialIndex],
            radialThreadPaint,
          );
        }

        if (nextIndex >= 0 &&
            nextIndex < warpedPoints.length &&
            radialIndex >= 0) {
          Offset midPoint =
              (warpedPoints[currentIndex] + warpedPoints[nextIndex]) / 2;
          canvas.drawLine(
            midPoint,
            warpedPoints[radialIndex],
            minorThreadPaint,
          );
        }
      }
    }

    Paint dewDropPaint = Paint()..color = config.dewDropColor;

    for (var point in warpedPoints) {
      if (random.nextDouble() < 0.05) {
        canvas.drawCircle(point, 2.0, dewDropPaint);
      }
    }
  }

  Offset _warpPosition(Offset original, Offset center, double distance) {
    double displacement =
        config.dentDepth * exp(-pow(distance / config.maxDistance, 2));
    Offset direction = (center - original).normalize();
    return original + direction * displacement;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension on Offset {
  Offset normalize() {
    double length = distance;
    return length > 0 ? this / length : Offset.zero;
  }
}
