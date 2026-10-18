import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';

/// Dark launch screen: three product photos, logo and tagline.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Widget _photo(String asset, double w, double h, {bool border = false}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: border ? Border.all(color: AppColors.ink, width: 4) : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(asset, fit: BoxFit.cover),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.ink,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 290,
                height: 190,
                child: Stack(
                  children: [
                    Positioned(left: 0, top: 30, child: _photo('assets/images/diffuser.jpg', 110, 150)),
                    Positioned(right: 0, top: 30, child: _photo('assets/images/headphones_cream.jpg', 110, 150)),
                    Positioned(
                      left: 80,
                      top: 0,
                      child: _photo('assets/images/headphones_pro.jpg', 130, 180, border: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(22)),
                child: const Icon(Icons.group_outlined, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text('GroupBuy', style: AppText.h1.copyWith(color: Colors.white)),
              const SizedBox(height: 8),
              Text('Team up. Pay less.', style: AppText.body.copyWith(color: const Color(0xFFBFBFC7))),
            ],
          ),
        ),
      );
}
