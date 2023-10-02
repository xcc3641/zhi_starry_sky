import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zhi_starry_sky/src/particle.dart';

class StarrySkyPainter extends CustomPainter {
  final List<Particle> particles;
  final List<Particle> bigParticles;

  StarrySkyPainter({required this.particles, required this.bigParticles});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw each particle
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size * particle.scale, paint);
    }

    // Draw each big particle with a blur effect
    for (var particle in bigParticles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

      canvas.drawCircle(particle.position, particle.size * particle.scale, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class StarrySkyView extends StatefulWidget {
  const StarrySkyView({super.key});

  @override
  State<StarrySkyView> createState() => _StarrySkyViewState();
}

class _StarrySkyViewState extends State<StarrySkyView> with SingleTickerProviderStateMixin {
  late List<Particle> particles;
  late List<Particle> bigParticles;
  final int particleCount = 88;
  final int bigParticleCount = 12;
  final List<Color> colors = [
    Colors.yellow,
    Colors.blue,
    Colors.pink,
    Colors.brown,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.cyan,
    Colors.teal,
    Colors.indigo
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _animationController.addListener(() {
      _animateParticles(particles);
      _animateParticles(bigParticles);
      setState(() {}); // Trigger a rebuild to repaint the particles
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    particles = _generateParticles(particleCount);
    bigParticles = _generateParticles(bigParticleCount, isBig: true);
  }

  void _animateParticles(List<Particle> particlesList) {
    const maxDistance = 60.0; // Maximum distance a particle can move from its initial position
    const double lerpFactor = 0.01;

    for (var particle in particlesList) {
      // Move particle towards target position
      double dx = (particle.targetPosition.dx - particle.position.dx) * lerpFactor;
      double dy = (particle.targetPosition.dy - particle.position.dy) * lerpFactor;
      particle.position = particle.position.translate(dx, dy);

      // Adjust scale towards target scale
      particle.scale += (particle.targetScale - particle.scale) * lerpFactor;

      // If particle is close to target, set a new target within the maxDistance
      if ((particle.position.dx - particle.targetPosition.dx).abs() < 1 &&
          (particle.position.dy - particle.targetPosition.dy).abs() < 1) {
        particle.targetPosition = Offset(
          particle.position.dx + (Random().nextDouble() * 2 - 1) * maxDistance,
          particle.position.dy + (Random().nextDouble() * 2 - 1) * maxDistance,
        );
        particle.targetScale = Random().nextDouble() * 1.5 + 0.5;
      }
    }
  }

  List<Particle> _generateParticles(int count, {bool isBig = false}) {
    List<Particle> generatedParticles = [];
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    for (var i = 0; i < count; i++) {
      final color = isBig ? colors[Random().nextInt(colors.length)] : (isDarkMode ? Colors.white : Colors.black);
      final position = Offset(
        Random().nextDouble() * MediaQuery.of(context).size.width,
        Random().nextDouble() * MediaQuery.of(context).size.height,
      );
      final size = isBig ? Random().nextDouble() * 40 + 20 : Random().nextDouble() * 2;
      final opacity = Random().nextDouble();
      final scale = Random().nextDouble() * 1.5 + 0.5;

      final targetPosition = Offset(
        Random().nextDouble() * MediaQuery.of(context).size.width,
        Random().nextDouble() * MediaQuery.of(context).size.height,
      );
      final targetScale = Random().nextDouble() * 1.5 + 0.5;

      generatedParticles.add(Particle(
          color: color,
          position: position,
          size: size,
          opacity: opacity,
          scale: scale,
          targetPosition: targetPosition,
          targetScale: targetScale));
    }
    return generatedParticles;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: CustomPaint(
        painter: StarrySkyPainter(particles: particles, bigParticles: bigParticles),
        child: Container(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
