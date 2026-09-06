import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/data/products.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/models/order.dart' as app_order;
import 'package:e_commerce_app/models/cart_item.dart';

class FirestoreService {
  static Future<void> uploadProducts() async {
    final firestore = FirebaseFirestore.instance;

    for (final product in products) {
      await firestore
          .collection('products')
          .doc(product.id)
          .set({
        'id': product.id,
        'name': product.name,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'category': product.category,
        'description': product.description,
        'rating': product.rating,
        'discountPercentage': product.discountPercentage,
      });
    }
  }

  static Future<List<Product>> fetchProducts() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Product(
        id: data['id'] ?? doc.id,
        name: data['name'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        price: (data['price'] as num).toDouble(),
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        rating: (data['rating'] as num).toDouble(),
        discountPercentage:
            data['discountPercentage'] != null
                ? (data['discountPercentage'] as num).toDouble()
                : null,
      );
    }).toList();
  }

  static Future<void> saveOrder(
      app_order.Order order, String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(order.id)
        .set({
      'id': order.id,
      'userId': userId,
      'totalAmount': order.totalAmount,
      'name': order.name,
      'phone': order.phone,
      'address': order.address,
      'city': order.city,
      'postalCode': order.postalCode,
      'paymentMethod': order.paymentMethod,
      'orderDate': Timestamp.fromDate(order.orderDate),
      'status': order.status,
      'items': order.items.map((item) {
        final product = item.product;

        return {
          'productId': product.id,
          'name': product.name,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'discountPercentage': product.discountPercentage,
          'quantity': item.quantity,
          'totalPrice': item.totalPrice,
        };
      }).toList(),
    });
  }

  static Future<List<app_order.Order>> fetchOrders(
      String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      final items = (data['items'] as List<dynamic>? ?? []).map((item) {
        final product = Product(
          id: item['productId'] ?? '',
          name: item['name'] ?? '',
          imageUrl: item['imageUrl'] ?? '',
          price: (item['price'] as num).toDouble(),
          category: '',
          description: '',
          rating: 0,
          discountPercentage:
              item['discountPercentage'] != null
                  ? (item['discountPercentage'] as num).toDouble()
                  : null,
        );

        return CartItem(
          product: product,
          quantity: item['quantity'] ?? 1,
        );
      }).toList();

      return app_order.Order(
        id: data['id'] ?? doc.id,
        userId: data['userId'] ?? userId,
        items: items,
        totalAmount: (data['totalAmount'] as num).toDouble(),
        name: data['name'] ?? '',
        phone: data['phone'] ?? '',
        address: data['address'] ?? '',
        city: data['city'] ?? '',
        postalCode: data['postalCode'] ?? '',
        paymentMethod: data['paymentMethod'] ?? '',
        orderDate: (data['orderDate'] as Timestamp).toDate(),
        status: data['status'] ?? 'Pending',
      );
    }).toList();
  }

  static Future<List<app_order.Order>> fetchAllOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('orders')
        .get();

    final orders = snapshot.docs.map((doc) {
      final data = doc.data();

      final items = (data['items'] as List<dynamic>? ?? []).map((item) {
        final product = Product(
          id: item['productId'] ?? '',
          name: item['name'] ?? '',
          imageUrl: item['imageUrl'] ?? '',
          price: (item['price'] as num).toDouble(),
          category: '',
          description: '',
          rating: 0,
          discountPercentage:
              item['discountPercentage'] != null
                  ? (item['discountPercentage'] as num).toDouble()
                  : null,
        );

        return CartItem(
          product: product,
          quantity: item['quantity'] ?? 1,
        );
      }).toList();

      return app_order.Order(
        id: data['id'] ?? doc.id,
        userId: data['userId'] ??
            doc.reference.parent.parent?.id,
        items: items,
        totalAmount: (data['totalAmount'] as num).toDouble(),
        name: data['name'] ?? '',
        phone: data['phone'] ?? '',
        address: data['address'] ?? '',
        city: data['city'] ?? '',
        postalCode: data['postalCode'] ?? '',
        paymentMethod: data['paymentMethod'] ?? '',
        orderDate: (data['orderDate'] as Timestamp).toDate(),
        status: data['status'] ?? 'Pending',
      );
    }).toList();

    orders.sort(
      (a, b) => b.orderDate.compareTo(a.orderDate),
    );

    return orders;
  }

  static Future<void> updateOrderStatus(
      String userId,
      String orderId,
      String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .update({
      'status': status,
    });
  }
  static Future<void> addProduct(Product product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .set({
      'id': product.id,
      'name': product.name,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'category': product.category,
      'description': product.description,
      'rating': product.rating,
      'discountPercentage': product.discountPercentage,
    });
  }

  static Future<void> updateProduct(Product product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .update({
      'name': product.name,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'category': product.category,
      'description': product.description,
      'rating': product.rating,
      'discountPercentage': product.discountPercentage,
    });
  }

  static Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
  }

  static Future<Product?> fetchProductById(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;

    return Product(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num).toDouble(),
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      rating: (data['rating'] as num).toDouble(),
      discountPercentage:
          data['discountPercentage'] != null
              ? (data['discountPercentage'] as num).toDouble()
              : null,
    );
  }
  static Future<bool> isAdmin(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    return doc.data()?['isAdmin'] == true;
  }
  // =========================
  // FAVORITES
  // =========================

  static Future<void> saveFavorite(
    String userId,
    Product product,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id)
        .set({
      'id': product.id,
      'name': product.name,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'category': product.category,
      'description': product.description,
      'rating': product.rating,
      'discountPercentage': product.discountPercentage,
    });
  }

  static Future<void> removeFavorite(
    String userId,
    String productId,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .delete();
  }

  static Future<List<Product>> fetchFavorites(
    String userId,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Product(
        id: data['id'] ?? doc.id,
        name: data['name'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        price: (data['price'] as num).toDouble(),
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        rating: (data['rating'] as num).toDouble(),
        discountPercentage:
            data['discountPercentage'] != null
                ? (data['discountPercentage'] as num).toDouble()
                : null,
      );
    }).toList();
  }
}