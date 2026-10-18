import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/product.dart';

/// Bold group price, the struck-through solo price and the percentage saved.
class PriceTag extends StatelessWidget {
  const PriceTag(this.product, {super.key, this.large = false});

  final Product product;
  final bool large;

  @override
  Widget build(BuildContext context) => Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 6,
        children: [
          Text(money(product.groupPrice), style: large ? AppText.priceL : AppText.priceM),
          Text(
            money(product.price),
            style: (large ? AppText.body : AppText.caption).copyWith(decoration: TextDecoration.lineThrough),
          ),
          Text(
            '${product.savingPercent}% off',
            style: (large ? AppText.bodyStrong : AppText.caption).copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
}
