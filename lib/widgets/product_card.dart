import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/product.dart';
import 'circle_icon_button.dart';
import 'price_tag.dart';
import 'product_image.dart';

/// Grid card: photo with discount badge and heart, title, group price, group size.
class ProductCard extends StatelessWidget {
  const ProductCard(
    this.product, {
    super.key,
    required this.onTap,
    this.wished = false,
    this.onWish,
  });

  final Product product;
  final VoidCallback onTap;
  final bool wished;
  final VoidCallback? onWish;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: product.title,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ProductImage(product),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: CircleIconButton(
                        wished ? Icons.favorite : Icons.favorite_border,
                        size: 32,
                        iconColor: wished ? AppColors.deal : AppColors.ink,
                        onTap: onWish,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.body),
              const SizedBox(height: 4),
              PriceTag(product),
              const SizedBox(height: 4),
              Text(
                'Group of ${product.groupSize} · ${product.soldLabel} sold',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star, size: 12, color: AppColors.ink),
                  const SizedBox(width: 2),
                  Text(product.rating.toStringAsFixed(1), style: AppText.caption),
                  const SizedBox(width: 8),
                  Text('Free shipping', style: AppText.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      );
}
