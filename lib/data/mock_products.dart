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
  Product(
    id: 'p2',
    title: 'Smart Glasses',
    category: 'Wearables',
    image: 'assets/images/smart_glasses.jpg',
    price: 199,
    groupPrice: 149,
    groupSize: 5,
    sold: 860,
    rating: 4.6,
    description: 'Lightweight smart glasses with a heads-up display and dual cameras.',
  ),
];
