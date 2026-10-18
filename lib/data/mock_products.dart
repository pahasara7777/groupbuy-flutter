import '../models/product.dart';

/// Demo catalogue. Photos live in assets/images.
const mockProducts = <Product>[
  Product(
    id: 'p1',
    title: 'Aroma Diffuser',
    category: 'Home',
    image: 'assets/images/diffuser.jpg',
    price: 49,
    groupPrice: 34,
    groupSize: 3,
    sold: 2100,
    description: 'Ceramic ultrasonic diffuser with a warm wood cap and soft mist.',
  ),
];
