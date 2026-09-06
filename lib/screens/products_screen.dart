import 'package:flutter/material.dart';

import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/widgets/product_card.dart';
import 'package:e_commerce_app/screens/product_details_screen.dart';
import 'package:e_commerce_app/theme/app_theme.dart';

class ProductsScreen extends StatefulWidget {
  final String? category;

  const ProductsScreen({
    super.key,
    this.category,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _sortOption = 'Default';

  List<Product> _products = [];
  bool _isLoadingProducts = true;
  String? _productsError;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (mounted) {
      setState(() {
        _isLoadingProducts = true;
        _productsError = null;
      });
    }

    try {
      final products = await FirestoreService.fetchProducts();

      if (!mounted) {
        return;
      }

      setState(() {
        _products = products;
        _isLoadingProducts = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingProducts = false;
        _productsError = 'Unable to load products right now.';
      });
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 58,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            const Text(
              'Couldn’t load products',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final bool isCategorySelected = widget.category != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCategorySelected
                  ? Icons.inventory_2_outlined
                  : Icons.shopping_bag_outlined,
              size: 58,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            Text(
              isCategorySelected
                  ? 'No products in this category'
                  : 'No products available',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isCategorySelected
                  ? 'Try another category to explore more products.'
                  : 'Products will appear here once they are added.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter products according to selected category.
    final filteredProducts = widget.category == null
        ? List.of(_products)
        : _products
            .where(
              (product) => product.category == widget.category,
            )
            .toList();

    // Apply selected sorting.
    if (_sortOption == 'Price: Low to High') {
      filteredProducts.sort(
        (a, b) => a.price.compareTo(b.price),
      );
    } else if (_sortOption == 'Price: High to Low') {
      filteredProducts.sort(
        (a, b) => b.price.compareTo(a.price),
      );
    } else if (_sortOption == 'Rating: Highest') {
      filteredProducts.sort(
        (a, b) => b.rating.compareTo(a.rating),
      );
    } else if (_sortOption == 'Name: A to Z') {
      filteredProducts.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        title: Text(
          widget.category ?? 'All Products',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.sort_rounded,
            ),
            tooltip: 'Sort Products',

            onSelected: (value) {
              setState(() {
                _sortOption = value;
              });
            },

            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'Default',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.restart_alt_rounded,
                        size: 20,
                        color: Color(0xFF171717),
                      ),
                      const SizedBox(width: 10),
                      const Text('Default'),
                      if (_sortOption == 'Default') ...[
                        const Spacer(),
                        Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: AppTheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'Price: Low to High',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        size: 20,
                        color: Color(0xFF171717),
                      ),
                      const SizedBox(width: 10),
                      const Text('Price: Low to High'),
                      if (_sortOption == 'Price: Low to High') ...[
                        const Spacer(),
                        Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: AppTheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'Price: High to Low',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward_rounded,
                        size: 20,
                        color: Color(0xFF171717),
                      ),
                      const SizedBox(width: 10),
                      const Text('Price: High to Low'),
                      if (_sortOption == 'Price: High to Low') ...[
                        const Spacer(),
                        Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: AppTheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'Rating: Highest',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: Color(0xFF171717),
                      ),
                      const SizedBox(width: 10),
                      const Text('Rating: Highest'),
                      if (_sortOption == 'Rating: Highest') ...[
                        const Spacer(),
                        Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: AppTheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'Name: A to Z',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sort_by_alpha_rounded,
                        size: 20,
                        color: Color(0xFF171717),
                      ),
                      const SizedBox(width: 10),
                      const Text('Name: A to Z'),
                      if (_sortOption == 'Name: A to Z') ...[
                        const Spacer(),
                        Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: AppTheme.primary,
                        ),
                      ],
                    ],
                  ),
                ),
              ];
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: _isLoadingProducts
            ? _buildLoadingState()
            : _productsError != null
                ? _buildErrorState()
                : filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.53,
                        ),

                        itemCount: filteredProducts.length,

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
      ),
    );
  }
}