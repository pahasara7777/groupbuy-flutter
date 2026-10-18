import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/app_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/splash_screen.dart';
import 'state/store.dart';

/// Picks the screen from store state, so auth needs no screen-to-screen navigation.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key, this.splash = const Duration(milliseconds: 1800)});

  final Duration splash;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late bool _splashing = widget.splash > Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (_splashing) {
      _timer = Timer(widget.splash, () => setState(() => _splashing = false));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_splashing) return const SplashScreen();
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        if (!store.onboarded) return const OnboardingScreen();
        if (!store.signedIn) return const SignInScreen();
        return const AppShell();
      },
    );
  }
}
