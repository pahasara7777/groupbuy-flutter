import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _slides = [
    (
      'assets/images/headphones_lavender.jpg',
      'Better prices, together',
      'Invite friends to join your order. The more people in the group, the less everyone pays.',
    ),
    (
      'assets/images/controller.jpg',
      'Start or join a group',
      'Pick a product, join an open group or start your own. Every group lasts 24 hours.',
    ),
    (
      'assets/images/serum.jpg',
      'Not full? Full refund',
      'If a group does not fill in time, your money goes straight back to you.',
    ),
  ];

  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  bool get _last => _page == _slides.length - 1;

  void _next() {
    if (_last) {
      store.finishOnboarding();
    } else {
      _pages.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: store.finishOnboarding,
                    child: Text('Skip', style: AppText.bodyStrong.copyWith(color: AppColors.ink2)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pages,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.asset(_slides[i].$1, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(_slides[i].$2, style: AppText.h1, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text(
                          _slides[i].$3,
                          style: AppText.body.copyWith(color: AppColors.ink2),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _slides.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _page ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page ? AppColors.accent : AppColors.line,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              BottomActionBar(children: [AppButton(_last ? 'Get started' : 'Next', onPressed: _next)]),
            ],
          ),
        ),
      );
}
