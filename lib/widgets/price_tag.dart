import 'package:flutter/material.dart';
import '../core/format.dart';
import '../core/theme/app_text.dart';
import '../models/product.dart';

/// Group price in red with the struck-through solo price beside it.
class PriceTag extends StatelessWidget {
  const PriceTag(this.product, {super.key, this.large = false});

  final Product product;
  final bool large;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(money(product.groupPrice), style: large ? AppText.priceL : AppText.priceM),
          const SizedBox(width: 6),
          Text(
            money(product.price),
            style: (large ? AppText.body : AppText.caption).copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppText.caption.color,
            ),
          ),
        ],
      );
}
