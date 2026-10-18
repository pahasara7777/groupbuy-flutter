import 'dart:async';
import 'package:flutter/material.dart';
import '../core/format.dart';

/// Ticking HH:MM:SS text that counts down to [until].
class Countdown extends StatefulWidget {
  const Countdown(this.until, {super.key, this.style, this.prefix = ''});

  final DateTime until;
  final TextStyle? style;
  final String prefix;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = formatRemaining(widget.until.difference(DateTime.now()));
    return Text(left == null ? 'Expired' : '${widget.prefix}$left', style: widget.style);
  }
}
