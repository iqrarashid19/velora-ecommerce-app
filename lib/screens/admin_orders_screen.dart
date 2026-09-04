import 'package:flutter/material.dart';
import 'package:e_commerce_app/theme/app_theme.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Admin Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: const Center(
        child: Text(
          'Admin Order Management',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}