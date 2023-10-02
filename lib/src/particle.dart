import 'package:flutter/material.dart';

class Particle {
  final UniqueKey id = UniqueKey();
  final Color color;
  Offset position;
  final double size;
  double opacity;
  double scale;
  Offset targetPosition;
  double targetScale;

  Particle({
    required this.color,
    required this.position,
    required this.size,
    required this.opacity,
    required this.scale,
    required this.targetPosition,
    required this.targetScale,
  });
}
