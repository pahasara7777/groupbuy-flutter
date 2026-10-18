class ProductCategory {
  const ProductCategory(this.name, this.image);

  final String name, image;
}

const categories = <ProductCategory>[
  ProductCategory('Audio', 'assets/images/headphones_pro.jpg'),
  ProductCategory('Beauty', 'assets/images/serum.jpg'),
  ProductCategory('Home', 'assets/images/diffuser.jpg'),
  ProductCategory('Wearables', 'assets/images/smart_glasses.jpg'),
  ProductCategory('Gaming', 'assets/images/controller.jpg'),
  ProductCategory('Decor', 'assets/images/decanter.jpg'),
  ProductCategory('Fashion', 'assets/images/fashion_maxi.jpg'),
  ProductCategory('Fragrance', 'assets/images/perfume_rose.jpg'),
  ProductCategory('Cameras', 'assets/images/gimbal_pocket.jpg'),
  ProductCategory('Tech', 'assets/images/desk_clock.jpg'),
];
