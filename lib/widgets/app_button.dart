import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';

enum AppButtonStyle { primary, dark, soft, outline }

/// Full-width 52px button used for every main action. Styles match the Figma components.
class AppButton extends StatelessWidget {
  const AppButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;

  Color get _bg => switch (style) {
        AppButtonStyle.primary => AppColors.accent,
        AppButtonStyle.dark => AppColors.ink,
        AppButtonStyle.soft => AppColors.accentSoft,
        AppButtonStyle.outline => AppColors.surface,
      };

  Color get _fg => switch (style) {
        AppButtonStyle.primary || AppButtonStyle.dark => Colors.white,
        AppButtonStyle.soft || AppButtonStyle.outline => AppColors.accent,
      };

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: onPressed == null ? 0.4 : 1,
        child: Material(
          color: _bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: onPressed,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: style == AppButtonStyle.outline
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.accent, width: 1.5),
                    )
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[Icon(icon, size: 20, color: _fg), const SizedBox(width: 8)],
                  Text(label, style: AppText.button.copyWith(color: _fg)),
                ],
              ),
            ),
          ),
        ),
      );
}
