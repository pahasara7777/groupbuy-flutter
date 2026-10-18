import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Type ramp from the Figma text styles. Font is bundled in assets/fonts.
abstract final class AppText {
  static const _family = 'PlusJakartaSans';

  static TextStyle _s(double size, FontWeight w, double lh, [Color c = AppColors.ink]) =>
      TextStyle(fontFamily: _family, fontSize: size, fontWeight: w, height: lh / size, color: c);

  static final h1 = _s(24, FontWeight.w800, 30);
  static final h2 = _s(20, FontWeight.w700, 28);
  static final h3 = _s(16, FontWeight.w700, 22);
  static final body = _s(14, FontWeight.w400, 20);
  static final bodyStrong = _s(14, FontWeight.w600, 20);
  static final caption = _s(12, FontWeight.w500, 16, AppColors.ink2);
  static final micro = _s(10, FontWeight.w600, 12);
  static final priceL = _s(24, FontWeight.w800, 30);
  static final priceM = _s(16, FontWeight.w800, 22);
  static final button = _s(15, FontWeight.w600, 20, Colors.white);
}
