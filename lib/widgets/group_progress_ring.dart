import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Circular progress toward a full group, with [child] centred inside.
class GroupProgressRing extends StatelessWidget {
  const GroupProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 200,
    this.stroke = 14,
  });

  final double progress;
  final Widget child;
  final double size, stroke;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(progress.clamp(0.0, 1.0), stroke),
          child: Center(child: child),
        ),
      );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.stroke);

  final double progress, stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final track = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final bar = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);
    if (progress > 0) canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, bar);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress || old.stroke != stroke;
}
