import 'package:flutter/material.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/models/order.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/widgets/order_card.dart';
import 'package:e_commerce_app/screens/order_details_screen.dart';
import 'package:e_commerce_app/screens/admin_orders_screen.dart';
import 'package:e_commerce_app/screens/admin_products_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<Order>> _loadOrders() async {
    return await FirestoreService.fetchAllOrders();
  }

  Future<List<Product>> _loadProducts() async {
    return await FirestoreService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: _loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
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

          final totalOrders = orders.length;

          final pendingOrders = orders.where(
            (order) =>
                order.status.toLowerCase() == 'pending',
          ).length;

          final shippedOrders = orders.where(
            (order) =>
                order.status.toLowerCase() == 'shipped',
          ).length;

          final deliveredOrders = orders.where(
            (order) =>
                order.status.toLowerCase() == 'delivered',
          ).length;

          final totalSales = orders.fold<double>(
            0,
            (sum, order) => sum + order.totalAmount,
          );

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // =========================
                    // HEADER
                    // =========================

                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Manage your store at a glance',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // ORDER STATS
                    // =========================

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      children: [
                        _buildStatCard(
                          title: 'Total Orders',
                          value: totalOrders,
                          icon:
                              Icons.shopping_bag_outlined,
                          iconColor: Colors.blue,
                        ),
                        _buildStatCard(
                          title: 'Pending',
                          value: pendingOrders,
                          icon:
                              Icons.pending_actions_outlined,
                          iconColor: Colors.orange,
                        ),
                        _buildStatCard(
                          title: 'Shipped',
                          value: shippedOrders,
                          icon:
                              Icons.local_shipping_outlined,
                          iconColor: Colors.deepPurple,
                        ),
                        _buildStatCard(
                          title: 'Delivered',
                          value: deliveredOrders,
                          icon:
                              Icons.check_circle_outline,
                          iconColor: Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // =========================
                    // SALES
                    // =========================

                    _buildSalesCard(totalSales),

                    const SizedBox(height: 20),

                    // =========================
                    // PRODUCT OVERVIEW
                    // =========================

                    const Text(
                      'Product Overview',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    FutureBuilder<List<Product>>(
                      future: _loadProducts(),
                      builder: (
                        context,
                        productSnapshot,
                      ) {
                        if (productSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildProductOverviewLoading();
                        }

                        if (productSnapshot.hasError) {
                          return _buildProductOverviewError();
                        }

                        final products =
                            productSnapshot.data ?? [];

                        final totalProducts =
                            products.length;

                        final totalCategories = products
                            .map(
                              (product) =>
                                  product.category.trim(),
                            )
                            .where(
                              (category) =>
                                  category.isNotEmpty,
                            )
                            .toSet()
                            .length;

                        return Row(
                          children: [
                            Expanded(
                              child: _buildProductStatCard(
                                title: 'Products',
                                value: totalProducts,
                                icon:
                                    Icons.inventory_2_outlined,
                                iconColor:
                                    AppTheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildProductStatCard(
                                title: 'Categories',
                                value: totalCategories,
                                icon:
                                    Icons.category_outlined,
                                iconColor: Colors.orange,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // STORE MANAGEMENT
                    // =========================

                    const Text(
                      'Store Management',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildManageProductsCard(context),

                    const SizedBox(height: 20),

                    // =========================
                    // RECENT ORDERS
                    // =========================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Orders',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminOrdersScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    if (orders.isEmpty)
                      _buildEmptyOrders()
                    else
                      ...orders.take(2).map((order) {
                        return OrderCard(
                          order: order,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsScreen(
                                  order: order,
                                  isAdmin: true,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // ORDER STAT CARD
  // =========================

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(
                    begin: 0,
                    end: value,
                  ),
                  duration:
                      const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (
                    context,
                    animatedValue,
                    child,
                  ) {
                    return Text(
                      '$animatedValue',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SALES CARD
  // =========================

  Widget _buildSalesCard(double totalSales) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.primary.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color:
                  Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.attach_money_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Sales',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 3),

                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: totalSales,
                  ),
                  duration:
                      const Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  builder: (
                    context,
                    animatedValue,
                    child,
                  ) {
                    return Text(
                      '\$${animatedValue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // PRODUCT STAT CARD
  // =========================

  Widget _buildProductStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // MANAGE PRODUCTS
  // =========================

  Widget _buildManageProductsCard(
      BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const AdminProductsScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color:
                    AppTheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: AppTheme.primary,
                size: 25,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage Products',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Add, edit or remove products',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // PRODUCT LOADING
  // =========================

  Widget _buildProductOverviewLoading() {
    return Row(
      children: [
        Expanded(
          child: _buildProductLoadingCard(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildProductLoadingCard(),
        ),
      ],
    );
  }

  Widget _buildProductLoadingCard() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  // =========================
  // PRODUCT ERROR
  // =========================

  Widget _buildProductOverviewError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade400,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Unable to load product overview.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // EMPTY ORDERS
  // =========================

  Widget _buildEmptyOrders() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'No orders found',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}