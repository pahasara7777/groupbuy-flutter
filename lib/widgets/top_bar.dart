import 'package:flutter/material.dart';
import '../core/theme/app_text.dart';
import 'circle_icon_button.dart';

/// Back button, centred title and an optional trailing button.
class TopBar extends StatelessWidget {
  const TopBar(this.title, {super.key, this.trailing, this.onBack});

  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            Icons.chevron_left,
            border: true,
            tooltip: 'Back',
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          Text(title, style: AppText.h3),
          trailing ?? const SizedBox(width: 40, height: 40),
        ],
      );
}
