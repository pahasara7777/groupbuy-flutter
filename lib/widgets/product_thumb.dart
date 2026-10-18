import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_image.dart';

/// Small square product photo for list rows (cart, orders, checkout).
class ProductThumb extends StatelessWidget {
  const ProductThumb(this.product, {super.key, this.size = 64, this.radius = 12});

  final Product product;
  final double size, radius;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: ProductImage(product, radius: radius));
}
