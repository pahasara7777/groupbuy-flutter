import 'package:flutter/material.dart';
import 'package:groupbuy/core/theme/app_theme.dart';

/// Wraps [child] in a themed MaterialApp so widgets can be pumped in isolation.
Widget host(Widget child) => MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    );
