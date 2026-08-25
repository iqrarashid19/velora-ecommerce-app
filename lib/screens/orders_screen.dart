import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/providers/order_provider.dart';
import 'package:e_commerce_app/widgets/order_card.dart';
import 'package:e_commerce_app/screens/order_details_screen.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppTheme.background,

      appBar: AppBar(
        backgroundColor:AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = orderProvider.orders;

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'No orders yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                      builder: (context) => OrderDetailsScreen(order: order),
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
