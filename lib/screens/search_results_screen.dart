import 'package:flutter/material.dart';

import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/screens/product_details_screen.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:e_commerce_app/widgets/product_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Product> _products = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await FirestoreService.fetchProducts();

    if (!mounted) {
      return;
    }

    setState(() {
      _products = products;
      _isLoadingProducts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = widget.query.trim().toLowerCase();

    final results = _products.where((product) {
      return product.name.toLowerCase().contains(searchQuery) ||
          product.category.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Search: ${widget.query}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _isLoadingProducts
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : results.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 60,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 16),

                      Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        'Try searching for another product.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                      child: Text(
                        '${results.length} product${results.length == 1 ? '' : 's'} found',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.53,
                        ),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final product = results[index];

                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}