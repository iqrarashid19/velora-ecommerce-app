import 'package:e_commerce_app/models/cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String paymentMethod;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.paymentMethod,
    required this.orderDate,
  });
}