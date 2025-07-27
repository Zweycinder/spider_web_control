import 'dart:math';
import 'package:flutter/material.dart';
import 'spider_web_config.dart';
import 'spider_web_painter.dart';

/// Callback function type for direction changes
typedef DirectionCallback = void Function(String direction);

/// A customizable spider web control widget that detects touch directions
class SpiderWebControl extends StatefulWidget {
  const SpiderWebControl({
    super.key,
    this.onDirectionChanged,
    this.config = const SpiderWebConfig(),
    this.onTouchStart,
    this.onTouchEnd,
    this.enableDirections = true,
  });

  /// Callback when direction changes (returns direction string like 'R', 'L', 'F', etc.)
  final DirectionCallback? onDirectionChanged;

  /// Configuration for appearance and behavior
  final SpiderWebConfig config;

  /// Callback when touch starts
  final VoidCallback? onTouchStart;

  /// Callback when touch ends
  final VoidCallback? onTouchEnd;

  /// Whether to enable direction detection
  final bool enableDirections;

  @override
  State<SpiderWebControl> createState() => _SpiderWebControlState();
}

class _SpiderWebControlState extends State<SpiderWebControl> {
  Offset _touchPosition = const Offset(-1, -1);
  DateTime _lastSentTime = DateTime.now().subtract(const Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.config.size,
        width: widget.config.size,
        child: GestureDetector(
          onPanStart: (_) {
            widget.onTouchStart?.call();
          },
          onPanUpdate: (details) {
            setState(() {
              if (_isTouchInsideContainer(details.localPosition)) {
                _touchPosition = details.localPosition;
                if (widget.enableDirections) {
                  _maybeSendTouchDirection(details.localPosition);
                }
              }
            });
          },
          onPanEnd: (_) {
            setState(() {
              _touchPosition = const Offset(-1, -1);
            });
            widget.onTouchEnd?.call();
          },
          child: CustomPaint(
            painter: SpiderWebPainter(_touchPosition, config: widget.config),
          ),
        ),
      ),
    );
  }

  bool _isTouchInsideContainer(Offset position) {
    final center = Offset(widget.config.size / 2, widget.config.size / 2);
    final radius = widget.config.size / 2;
    double distance = (position - center).distance;
    return distance <= radius;
  }

  void _maybeSendTouchDirection(Offset position) {
    if (DateTime.now().difference(_lastSentTime) >=
        widget.config.sendInterval) {
      _lastSentTime = DateTime.now();
      final center = Offset(widget.config.size / 2, widget.config.size / 2);
      final angle = atan2(position.dy - center.dy, position.dx - center.dx);
      final direction = _getDirectionFromAngle(angle);
      if (direction != 'Disabled Zone') {
        widget.onDirectionChanged?.call(direction);
      }
    }
  }

  String _getDirectionFromAngle(double angle) {
    double centerDistance =
        (_touchPosition -
                Offset(widget.config.size / 2, widget.config.size / 2))
            .distance;

    if (centerDistance < widget.config.centerThreshold) {
      return 'Disabled Zone';
    }

    if (angle >= -pi / 8 && angle < pi / 8) {
      return 'R';
    } else if (angle >= pi / 8 && angle < 3 * pi / 8) {
      return 'BR';
    } else if (angle >= 3 * pi / 8 && angle < 5 * pi / 8) {
      return 'B';
    } else if (angle >= 5 * pi / 8 && angle < 7 * pi / 8) {
      return 'BL';
    } else if (angle >= 7 * pi / 8 || angle < -7 * pi / 8) {
      return 'L';
    } else if (angle >= -7 * pi / 8 && angle < -5 * pi / 8) {
      return 'FL';
    } else if (angle >= -5 * pi / 8 && angle < -3 * pi / 8) {
      return 'F';
    } else {
      return 'FR';
    }
  }
}
