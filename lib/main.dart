import 'package:flutter/material.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';

void main() => runApp(const GroupBuyApp());

class GroupBuyApp extends StatelessWidget {
  const GroupBuyApp({super.key, this.splash = const Duration(milliseconds: 1800)});

  final Duration splash;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GroupBuy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: AppRoot(splash: splash),
      );
}
