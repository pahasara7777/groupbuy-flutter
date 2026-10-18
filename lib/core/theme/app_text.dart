import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Type ramp from the Figma text styles. Font is bundled in assets/fonts.
abstract final class AppText {
  static const _family = 'PlusJakartaSans';

  static TextStyle _s(double size, FontWeight w, double lh, [Color c = AppColors.ink]) =>
      TextStyle(fontFamily: _family, fontSize: size, fontWeight: w, height: lh / size, color: c);

  static final h1 = _s(28, FontWeight.w800, 36);
  static final h2 = _s(20, FontWeight.w700, 28);
  static final h3 = _s(16, FontWeight.w700, 22);
  static final body = _s(14, FontWeight.w400, 20);
  static final bodyStrong = _s(14, FontWeight.w600, 20);
  static final caption = _s(12, FontWeight.w500, 16, AppColors.ink2);
  static final micro = _s(10, FontWeight.w600, 12);
  static final priceL = _s(26, FontWeight.w800, 32, AppColors.accent);
  static final priceM = _s(18, FontWeight.w700, 24, AppColors.accent);
  static final button = _s(15, FontWeight.w600, 20, Colors.white);
}
