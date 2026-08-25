import 'package:flutter/foundation.dart';
import 'package:e_commerce_app/models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return List.unmodifiable(_orders);
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }
}