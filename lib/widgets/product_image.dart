import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/product.dart';

/// Rounded product photo. Falls back to a grey block if the asset is missing.
class ProductImage extends StatelessWidget {
  const ProductImage(this.product, {super.key, this.radius = 16, this.fit = BoxFit.cover});

  final Product product;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          product.image,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.line),
        ),
      );
}
