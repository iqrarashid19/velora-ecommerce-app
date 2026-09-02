import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/data/products.dart';
import 'package:e_commerce_app/models/product.dart';
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
}