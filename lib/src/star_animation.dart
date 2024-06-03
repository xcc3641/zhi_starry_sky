import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StarAnimation extends StatefulWidget {
  @override
  _StarAnimationState createState() => _StarAnimationState();
}

class _StarAnimationState extends State<StarAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> stars = [];
  double t = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      setState(() {
        t += 0.05;
      });
    })..repeat();
    _generateStars();
  }

  void _generateStars() {
    const layerCount = 13;
    const starsPerLayer = 30;
    final random = math.Random();

    for (int l = 1; l <= layerCount; l++) {
      for (int i = 1; i <= starsPerLayer; i++) {
        stars.add(Star(
          layer: l,
          index: i,
          initialScale: ((i * l / layerCount) + 0.4) % 1,
          progressMultiplier: l / layerCount,
          isCircle: random.nextBool(),
        ));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: StarPainter(stars, t),
        size: Size.infinite,
      ),
    );
  }
}

class Star {
  final int layer;
  final int index;
  final double initialScale;
  final double progressMultiplier;
  final bool isCircle;

  double x = 0;
  double y = 0;
  double size = 0;
  double alpha = 0;
  double angle = 0;
  double cornerRadius = 0;

  Star({
    required this.layer,
    required this.index,
    required this.initialScale,
    required this.progressMultiplier,
    required this.isCircle,
  });

  void update(double t, Size size) {
    double scale = ((t / 16) + progressMultiplier) % 1;
    alpha = 1 - (math.cos(scale * 2 * math.pi) + 1) / 2;
    scale += 0.4;

    x = size.width * ((math.sin(index * layer * 6.05932) * scale) + 1) / 2;
    y = size.height * ((math.sin(index * layer * 4.321) * scale) + 1) / 2;
    this.size = math.cos(index * 49.2) * 9.0 * scale;
    angle = math.sin(index * layer) * t * 2;
    cornerRadius = math.sin(index * layer) > 0 ? this.size / 2 : 0;
  }
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double t;

  StarPainter(this.stars, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var star in stars) {
      star.update(t, size);

      paint.color = Colors.white.withOpacity(star.alpha);
      if (star.isCircle) {
        canvas.drawCircle(
          Offset(star.x, star.y),
          star.size / 2,
          paint..style = PaintingStyle.fill,
        );
      } else {
        canvas.drawRect(
          Rect.fromLTWH(star.x - star.size / 2, star.y - star.size / 2, star.size, star.size),
          paint..style = PaintingStyle.fill,
        );
        canvas.translate(star.x, star.y);
        canvas.rotate(star.angle);
        canvas.drawRect(
          Rect.fromLTWH(-star.size / 2, -star.size / 2, star.size, star.size),
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..maskFilter = MaskFilter.blur(BlurStyle.solid, star.cornerRadius),
        );
        canvas.rotate(-star.angle);
        canvas.translate(-star.x, -star.y);
      }
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => true;
}
