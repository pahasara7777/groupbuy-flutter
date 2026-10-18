import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static ThemeData light() => ThemeData(
        useMaterial3: true,
        fontFamily: 'PlusJakartaSans',
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          primary: AppColors.accent,
          surface: AppColors.surface,
        ),
        textTheme: TextTheme(
          headlineLarge: AppText.h1,
          titleLarge: AppText.h2,
          titleMedium: AppText.h3,
          bodyMedium: AppText.body,
          bodySmall: AppText.caption,
        ),
        splashFactory: NoSplash.splashFactory,
        dividerColor: AppColors.line,
      );
}
