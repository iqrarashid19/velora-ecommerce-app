import 'package:e_commerce_app/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice {
    final discount = product.discountPercentage ?? 0;

    final finalPrice =
        product.price * (1 - discount / 100);

    return finalPrice * quantity;
  }
}