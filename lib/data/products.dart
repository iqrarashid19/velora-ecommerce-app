import 'package:e_commerce_app/models/product.dart';

const List<Product> featuredProducts = [
  Product(
    id: '1',
    name: 'Wireless Headphones',
    imageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
    price: 59.99,
    category: 'Electronics',
    description: 'Premium wireless headphones.',
    rating: 4.6,
    discountPercentage: 20,
  ),
  Product(
    id: '2',
    name: 'Smart Watch',
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30',
    price: 89.99,
    category: 'Electronics',
    description: 'Modern smart watch.',
    rating: 4.8,
    discountPercentage: 15,
  ),
  Product(
    id: '3',
    name: 'Running Shoes',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    price: 74.99,
    category: 'Sports',
    description: 'Comfortable running shoes.',
    rating: 4.6,
    discountPercentage: null,
  ),
];
const List<Product> products = [
  ...featuredProducts,
];