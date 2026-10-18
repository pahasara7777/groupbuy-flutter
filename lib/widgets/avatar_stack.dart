import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../state/store.dart';

const _palette = [Color(0xFFF4A261), Color(0xFF7C9CF5), Color(0xFF5DBB9A), Color(0xFFC084FC)];

/// Overlapping member avatars, plus dashed empty seats up to [seats].
class AvatarStack extends StatelessWidget {
  const AvatarStack(this.members, {super.key, this.seats, this.size = 36});

  final List<String> members;

  /// Total seats in the group. Seats without a member are drawn empty.
  final int? seats;
  final double size;

  @override
  Widget build(BuildContext context) {
    final empty = math.max(0, (seats ?? members.length) - members.length);
    final count = members.length + empty;
    final step = size * 0.78;
    return SizedBox(
      width: count == 0 ? 0 : size + (count - 1) * step,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < members.length; i++)
            Positioned(left: i * step, child: _Avatar(members[i], i, size)),
          for (var j = 0; j < empty; j++)
            Positioned(left: (members.length + j) * step, child: _EmptySeat(size)),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.name, this.index, this.size);

  final String name;
  final int index;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isMe = name == me;
    final label = isMe ? 'You' : (name.isEmpty ? '?' : name[0].toUpperCase());
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _palette[index % _palette.length],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        label,
        style: AppText.caption.copyWith(
          color: Colors.white,
          fontSize: isMe ? size * 0.28 : size * 0.38,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptySeat extends StatelessWidget {
  const _EmptySeat(this.size);

  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _DashedCircle(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: Text('?', style: AppText.bodyStrong.copyWith(color: AppColors.ink2))),
        ),
      );
}

class _DashedCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ink2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final r = size.width / 2 - 1;
    final c = Offset(size.width / 2, size.height / 2);
    const dashes = 18;
    for (var i = 0; i < dashes; i++) {
      final start = (i / dashes) * 2 * math.pi;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), start, math.pi / dashes, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
