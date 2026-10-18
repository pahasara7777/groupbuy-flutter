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
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit([String? email]) {
    if (!store.signIn(email ?? _email.text)) {
      setState(() => _error = 'Enter your email to continue.');
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
              Text('Welcome back', style: AppText.h1),
              const SizedBox(height: 8),
              Text('Sign in to join groups and track your orders.', style: AppText.body.copyWith(color: AppColors.ink2)),
              const SizedBox(height: 24),
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
              AppButton('Sign in', onPressed: _submit),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('or', style: AppText.caption)),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              AppButton('Continue with Google', style: AppButtonStyle.outline, onPressed: () => _submit('demo@groupbuy.app')),
              const SizedBox(height: 12),
              AppButton('Continue with Apple', style: AppButtonStyle.dark, onPressed: () => _submit('demo@groupbuy.app')),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New here? ', style: AppText.body.copyWith(color: AppColors.ink2)),
                  GestureDetector(
                    onTap: () => showMessage(context, 'Demo mode: sign in with any email.'),
                    child: Text('Create account', style: AppText.bodyStrong.copyWith(color: AppColors.accent)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
