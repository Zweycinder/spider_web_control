import 'package:flutter/material.dart';

/// Configuration class for customizing the spider web appearance and behavior
class SpiderWebConfig {
  /// Web thread colors and appearance
  final Color webColor;
  final Color threadColor;
  final Color minorThreadColor;
  final Color dewDropColor;

  /// Web structure parameters
  final int radialDivisions;
  final int circleDivisions;
  final double maxDistance;
  final double dentDepth;
  final int randomSeed;

  /// Touch and size configuration
  final double centerThreshold;
  final Duration sendInterval;
  final double size;

  const SpiderWebConfig({
    this.webColor = Colors.grey,
    this.threadColor = Colors.blue,
    this.minorThreadColor = Colors.blueGrey,
    this.dewDropColor = Colors.lightBlue,
    this.radialDivisions = 36,
    this.circleDivisions = 25,
    this.maxDistance = 400,
    this.dentDepth = 10.0,
    this.randomSeed = 0,
    this.centerThreshold = 80.0,
    this.sendInterval = const Duration(seconds: 1),
    this.size = 300.0,
  });

  /// Create a copy with modified parameters
  SpiderWebConfig copyWith({
    Color? webColor,
    Color? threadColor,
    Color? minorThreadColor,
    Color? dewDropColor,
    int? radialDivisions,
    int? circleDivisions,
    double? maxDistance,
    double? dentDepth,
    int? randomSeed,
    double? centerThreshold,
    Duration? sendInterval,
    double? size,
  }) {
    return SpiderWebConfig(
      webColor: webColor ?? this.webColor,
      threadColor: threadColor ?? this.threadColor,
      minorThreadColor: minorThreadColor ?? this.minorThreadColor,
      dewDropColor: dewDropColor ?? this.dewDropColor,
      radialDivisions: radialDivisions ?? this.radialDivisions,
      circleDivisions: circleDivisions ?? this.circleDivisions,
      maxDistance: maxDistance ?? this.maxDistance,
      dentDepth: dentDepth ?? this.dentDepth,
      randomSeed: randomSeed ?? this.randomSeed,
      centerThreshold: centerThreshold ?? this.centerThreshold,
      sendInterval: sendInterval ?? this.sendInterval,
      size: size ?? this.size,
    );
  }

  /// Default dark theme configuration
  static SpiderWebConfig darkTheme({double size = 300.0}) {
    return SpiderWebConfig(
      webColor: Colors.grey[800]!,
      threadColor: Colors.cyan,
      minorThreadColor: Colors.grey[600]!,
      dewDropColor: Colors.cyanAccent,
      size: size,
    );
  }

  /// Default light theme configuration
  static SpiderWebConfig lightTheme({double size = 300.0}) {
    return SpiderWebConfig(
      webColor: Colors.grey[300]!,
      threadColor: Colors.blue,
      minorThreadColor: Colors.grey[400]!,
      dewDropColor: Colors.lightBlue,
      size: size,
    );
  }
}
