import 'package:flutter/material.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';

/// Demo sign-in. Any non-empty email works until Firebase Auth is connected.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _creating = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  /// One-tap demo sign-in, only offered while Firebase is not connected.
  void _demo() => store.signIn('demo@groupbuy.app');

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty || (_creating && _name.text.trim().isEmpty)) {
      setState(() => _error = _creating ? 'Fill in your name, email and password.' : 'Enter your email and password.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = _creating
        ? await store.register(_name.text, email, password)
        : await store.signInWithEmail(email, password);
    // On success AppRoot swaps this screen out, so only touch state if we are still here.
    if (mounted) {
      setState(() {
        _busy = false;
        _error = error;
      });
    }
  }

  Widget _field(TextEditingController c, String hint, IconData icon, {bool secret = false}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.ink2),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: c,
                obscureText: secret,
                keyboardType: secret ? TextInputType.visiblePassword : TextInputType.emailAddress,
                style: AppText.body,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: AppText.body.copyWith(color: AppColors.ink2),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 48),
              Text(_creating ? 'Create account' : 'Welcome back', style: AppText.h1),
              const SizedBox(height: 8),
              Text(
                _creating ? 'Join groups and save on every order.' : 'Sign in to join groups and track your orders.',
                style: AppText.body.copyWith(color: AppColors.ink2),
              ),
              const SizedBox(height: 24),
              if (_creating) ...[
                _field(_name, 'Full name', Icons.person_outline),
                const SizedBox(height: 12),
              ],
              _field(_email, 'Email address', Icons.mail_outline),
              const SizedBox(height: 12),
              _field(_password, 'Password', Icons.lock_outline, secret: true),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: AppText.caption.copyWith(color: AppColors.accent)),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => showMessage(context, 'Password reset is coming soon.'),
                  child: Text('Forgot password?', style: AppText.caption.copyWith(color: AppColors.accent)),
                ),
              ),
              const SizedBox(height: 12),
              AppButton(_busy ? 'Please wait…' : (_creating ? 'Create account' : 'Sign in'), onPressed: _busy ? null : _submit),
              if (store.auth.isDemo) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('or', style: AppText.caption)),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton('Continue with Google', style: AppButtonStyle.outline, onPressed: _demo),
                const SizedBox(height: 12),
                AppButton('Continue with Apple', style: AppButtonStyle.dark, onPressed: _demo),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_creating ? 'Have an account? ' : 'New here? ', style: AppText.body.copyWith(color: AppColors.ink2)),
                  GestureDetector(
                    onTap: () => setState(() {
                      _creating = !_creating;
                      _error = null;
                    }),
                    child: Text(_creating ? 'Sign in' : 'Create account', style: AppText.bodyStrong.copyWith(color: AppColors.accent)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
