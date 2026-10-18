import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_screen.dart';
import '../state/store.dart';
import 'product_card.dart';

/// Two-column grid of [ProductCard]s. Sits inside a scroll view (does not scroll itself).
class ProductGrid extends StatelessWidget {
  const ProductGrid(this.products, {super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) => LayoutBuilder(
          builder: (context, c) {
            final cardWidth = (c.maxWidth - 8) / 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 16,
                mainAxisExtent: cardWidth + 132, // photo (square) + title, price and meta rows
              ),
              itemBuilder: (context, i) {
                final p = products[i];
                return ProductCard(
                  p,
                  wished: store.isWished(p),
                  onWish: () => store.toggleWish(p),
                  onTap: () => ProductScreen.open(context, p),
                );
              },
            );
          },
        ),
      );
}
