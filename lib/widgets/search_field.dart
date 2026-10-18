import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';

/// White search bar. With [readOnly] it is a tap target that opens the Search screen.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.readOnly = false,
    this.autofocus = false,
    this.active = false,
    this.hint = 'Search headphones, serum, gadgets',
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap, onClear;
  final bool readOnly, autofocus, active;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final showClear = onClear != null && (controller?.text.isNotEmpty ?? false);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: active ? AppColors.ink : AppColors.line),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: active ? AppColors.ink : AppColors.ink2),
            const SizedBox(width: 10),
            Expanded(
              child: readOnly
                  ? Text(hint, style: AppText.body.copyWith(color: AppColors.ink2), maxLines: 1)
                  : TextField(
                      controller: controller,
                      autofocus: autofocus,
                      onChanged: onChanged,
                      style: AppText.body,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: hint,
                        hintStyle: AppText.body.copyWith(color: AppColors.ink2),
                      ),
                    ),
            ),
            if (showClear)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 18, color: AppColors.ink2),
              ),
          ],
        ),
      ),
    );
  }
}
