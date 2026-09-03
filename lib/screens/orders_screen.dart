import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/order_card.dart';
import 'package:e_commerce_app/screens/order_details_screen.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    print('CURRENT USER UID: ${user?.uid}');

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: user == null
          ? const Center(
              child: Text(
                'Please login to view your orders',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : FutureBuilder<List<Order>>(
              future: FirestoreService.fetchOrders(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  print('ORDERS ERROR: ${snapshot.error}');

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                final orders = snapshot.data ?? [];

                print('ORDERS FOUND: ${orders.length}');

                if (orders.isEmpty) {
                  return const Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: orders.length,

                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return OrderCard(
                      order: order,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsScreen(order: order),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}