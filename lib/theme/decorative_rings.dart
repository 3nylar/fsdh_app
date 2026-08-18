import 'package:flutter/material.dart';

/// The faint concentric-arc "swirl" watermark printed in the corner of the
/// hero section and the wallet/portfolio card. Pure CustomPainter so no
/// image asset is required.
class DecorativeRings extends StatelessWidget {
  const DecorativeRings({
    super.key,
    this.size = 160,
    this.color = Colors.white,
    this.opacity = 0.18,
    this.ringCount = 9,
  });

  final double size;
  final Color color;
  final double opacity;
  final int ringCount;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingsPainter(color: color, ringCount: ringCount),
          ),
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({required this.color, required this.ringCount});

  final Color color;
  final int ringCount;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final center = Offset(size.width * 0.78, size.height * 0.28);
    final maxRadius = size.shortestSide * 0.62;

    for (var i = 0; i < ringCount; i++) {
      final t = i / (ringCount - 1);
      final radius = maxRadius * (0.25 + 0.75 * t);
      // Each ring is an arc rather than a full circle so the pattern
      // reads as a loose spiral instead of a bullseye.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -0.9 + t * 0.6,
        4.9,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) => false;
}
