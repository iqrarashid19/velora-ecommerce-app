import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_commerce_app/screens/profile_screen.dart';
import 'package:e_commerce_app/data/categories.dart';
import 'package:e_commerce_app/screens/favorites_screen.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/providers/favorites_provider.dart';
import 'package:e_commerce_app/screens/search_results_screen.dart';
import 'package:e_commerce_app/screens/cart_screen.dart';
import 'package:e_commerce_app/screens/orders_screen.dart';
import 'package:e_commerce_app/screens/product_details_screen.dart';
import 'package:e_commerce_app/screens/products_screen.dart';
import 'package:e_commerce_app/screens/admin_dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/widgets/category_item.dart';
import 'package:e_commerce_app/widgets/greeting_header.dart';
import 'package:e_commerce_app/widgets/product_card.dart';
import 'package:e_commerce_app/widgets/promo_banner.dart';
import 'package:e_commerce_app/widgets/search_bar.dart';
import 'package:e_commerce_app/widgets/section_title.dart';
import 'package:e_commerce_app/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  List<Product> _products = [];
  bool _isLoadingProducts = true;
  bool _isAdmin = false;

  String? _productsError;

  @override
  void initState() {
    super.initState();

    _loadProducts();
    _checkAdmin();

    // Load user's Firebase favorites after HomeScreen is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  // --------------------------------------------------
  // LOAD PRODUCTS
  // --------------------------------------------------
  Future<void> _loadProducts() async {
    if (mounted) {
      setState(() {
        _isLoadingProducts = true;
        _productsError = null;
      });
    }

    try {
      final products = await FirestoreService.fetchProducts();

      if (!mounted) return;

      setState(() {
        _products = products;
        _isLoadingProducts = false;
        _productsError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingProducts = false;
        _productsError =
            'Unable to load products right now. Please try again.';
      });
    }
  }

  // --------------------------------------------------
  // CHECK ADMIN
  // --------------------------------------------------
  Future<void> _checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    try {
      final isAdmin = await FirestoreService.isAdmin(user.uid);

      if (!mounted) return;

      setState(() {
        _isAdmin = isAdmin;
      });
    } catch (_) {
      // If admin check fails, simply keep admin access disabled.
      if (!mounted) return;

      setState(() {
        _isAdmin = false;
      });
    }
  }

  // --------------------------------------------------
  // EMPTY / ERROR STATE
  // --------------------------------------------------
  Widget _buildProductsState() {
    // ERROR STATE
    if (_productsError != null) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_off_rounded,
                    size: 42,
                    color: AppTheme.primary,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Couldn’t load products',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _productsError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 14),

                OutlinedButton.icon(
                  onPressed: _loadProducts,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: BorderSide(
                      color: AppTheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // EMPTY DATABASE STATE
    if (_products.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 42,
                    color: AppTheme.primary,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'No products available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Products will appear here once they are added.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 14),

                OutlinedButton.icon(
                  onPressed: _loadProducts,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: BorderSide(
                      color: AppTheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // SEARCH RESULT EMPTY STATE
    final filteredProducts = _products.where((product) {
      final query = _searchQuery.trim().toLowerCase();

      if (query.isEmpty) {
        return true;
      }

      return product.name.toLowerCase().contains(query);
    }).toList();

    if (filteredProducts.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 50,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 12),

                const Text(
                  'No products found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Try searching with a different product name.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // PRODUCTS
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProducts.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 16);
        },
        itemBuilder: (context, index) {
          final product = filteredProducts[index];

          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsScreen(
                    product: product,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        title: const Text(
          'Velora',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),

        actions: [
          if (_isAdmin)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AdminDashboardScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.dashboard_outlined,
                color: Colors.white,
              ),
              tooltip: 'Admin Dashboard',
            ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
            ),
            tooltip: 'My Profile',
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: Colors.white,
            ),
            tooltip: 'Favorites',
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const OrdersScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.receipt_long_outlined,
              color: Colors.white,
            ),
            tooltip: 'My Orders',
          ),

          const SizedBox(width: 4),

          // ------------------------------------------------
          // CART BUTTON + BADGE
          // ------------------------------------------------
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CartScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    tooltip: 'Cart',
                  ),

                  if (cart.itemCount > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63970),
                          borderRadius:
                              BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------
                // GREETING
                // ------------------------------------------------
                GreetingHeader(
                  userName:
                      FirebaseAuth.instance.currentUser
                              ?.displayName ??
                          'User',
                ),

                const SizedBox(height: 16),

                // ------------------------------------------------
                // SEARCH BAR
                // ------------------------------------------------
                SearchBarWidget(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchResultsScreen(
                          query: value.trim(),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ------------------------------------------------
                // PROMO BANNER
                // ------------------------------------------------
                const AnimatedPromoBanner(),

                const SizedBox(height: 16),

                // ------------------------------------------------
                // CATEGORIES TITLE
                // ------------------------------------------------
                const SectionTitle(
                  title: 'Categories',
                ),

                const SizedBox(height: 16),

                // ------------------------------------------------
                // CATEGORIES LIST
                // ------------------------------------------------
                SizedBox(
                  height: 105,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 18);
                    },
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return CategoryItem(
                        name: category.name,
                        icon: category.icon,
                        color: category.color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductsScreen(
                                category: category.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 2),

                // ------------------------------------------------
                // FEATURED PRODUCTS TITLE
                // ------------------------------------------------
                SectionTitle(
                  title: 'Featured Products',
                  onSeeAll: () {},
                ),

                const SizedBox(height: 2),

                // ------------------------------------------------
                // FEATURED PRODUCTS
                // ------------------------------------------------
                if (_isLoadingProducts)
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Loading products...',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (!_isLoadingProducts)
                  _buildProductsState(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}