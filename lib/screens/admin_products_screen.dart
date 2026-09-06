import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:e_commerce_app/screens/admin_product_form_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = FirestoreService.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _loadProducts();
    });

    await _productsFuture;
  }

  Future<void> _deleteProduct(Product product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Product',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await FirestoreService.deleteProduct(product.id);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );

      setState(() {
        _loadProducts();
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete product: $e',
          ),
        ),
      );
    }
  }

  Future<void> _openAddProduct() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AdminProductFormScreen(),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _loadProducts();
      });
    }
  }

  Future<void> _openEditProduct(Product product) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AdminProductFormScreen(
          product: product,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _loadProducts();
      });
    }
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
          'Manage Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        onPressed: _openAddProduct,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Product',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: FutureBuilder<List<Product>>(
        future: _productsFuture,

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 50,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Failed to load products.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loadProducts();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height *
                            0.35,
                  ),
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'No products found.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Add your first product.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshProducts,

            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),

              itemCount: products.length,

              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },

              itemBuilder: (context, index) {
                final product = products[index];

                final discountedPrice =
                    product.price *
                        (1 -
                            (product.discountPercentage ??
                                    0) /
                                100);

                return Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.04,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(14),
                        child: Image.network(
                          product.imageUrl,
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {
                            return Container(
                              width: 85,
                              height: 85,
                              color: Colors.grey.shade100,
                              child: const Icon(
                                Icons
                                    .image_not_supported_outlined,
                                color: Colors.grey,
                              ),
                            );
                          },

                          loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                          ) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Container(
                              width: 85,
                              height: 85,
                              color: Colors.grey.shade100,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              product.category,
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  product.rating
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                Text(
                                  '\$${discountedPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                if (product
                                        .discountPercentage !=
                                    null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors
                                          .grey
                                          .shade500,
                                      decoration:
                                          TextDecoration
                                              .lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          IconButton(
                            tooltip: 'Edit Product',
                            onPressed: () {
                              _openEditProduct(product);
                            },
                            icon: Icon(
                              Icons.edit_outlined,
                              color: AppTheme.primary,
                            ),
                          ),

                          IconButton(
                            tooltip: 'Delete Product',
                            onPressed: () {
                              _deleteProduct(product);
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}