import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/product.dart';
import 'badges.dart';
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
  Widget build(BuildContext context) => GestureDetector(
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
                  Positioned(left: 10, top: 10, child: DiscountBadge(product.savingPercent)),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: CircleIconButton(
                      wished ? Icons.favorite : Icons.favorite_border,
                      size: 32,
                      iconColor: wished ? AppColors.accent : AppColors.ink,
                      onTap: onWish,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.bodyStrong),
            const SizedBox(height: 4),
            PriceTag(product),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 14, color: AppColors.ink2),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${product.groupSize} to unlock · ${product.soldLabel} sold',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
