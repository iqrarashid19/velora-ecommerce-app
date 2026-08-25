import 'package:flutter/material.dart';

import 'package:e_commerce_app/data/products.dart';
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

  @override
  Widget build(BuildContext context) {
    // Filter products according to selected category.
    final filteredProducts = widget.category == null
        ? List.of(products)
        : products
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
        child: filteredProducts.isEmpty
            ? const Center(
                child: Text(
                  'No products found.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
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