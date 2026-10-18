import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'state/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    store.auth = FirebaseAuthService();
    store.restoreSession();
  } catch (e) {
    // Not configured yet (or offline): keep the demo sign-in so the app still runs.
    debugPrint('Firebase unavailable, running in demo mode: $e');
  }
  runApp(const GroupBuyApp());
}

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
