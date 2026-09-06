import 'package:flutter/material.dart';
import 'package:e_commerce_app/data/categories.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:e_commerce_app/theme/app_theme.dart';

class AdminProductFormScreen extends StatefulWidget {
  final Product? product;

  const AdminProductFormScreen({
    super.key,
    this.product,
  });

  bool get isEditing => product != null;

  @override
  State<AdminProductFormScreen> createState() =>
      _AdminProductFormScreenState();
}

class _AdminProductFormScreenState
    extends State<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ratingController;
  late final TextEditingController _discountController;

  String? _selectedCategory;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    _nameController = TextEditingController(
      text: product?.name ?? '',
    );

    _imageUrlController = TextEditingController(
      text: product?.imageUrl ?? '',
    );

    _priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );

    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );

    _ratingController = TextEditingController(
      text: product?.rating.toString() ?? '',
    );

    _discountController = TextEditingController(
      text: product?.discountPercentage?.toString() ?? '',
    );

    _selectedCategory = product?.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _discountController.dispose();

    super.dispose();
  }

  String _generateProductId() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .toString();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final price =
          double.parse(_priceController.text.trim());

      final rating =
          double.parse(_ratingController.text.trim());

      final discountText =
          _discountController.text.trim();

      final discount = discountText.isEmpty
          ? null
          : double.parse(discountText);

      final product = Product(
        id: widget.product?.id ?? _generateProductId(),
        name: _nameController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        price: price,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        rating: rating,
        discountPercentage: discount,
      );

      if (widget.isEditing) {
        await FirestoreService.updateProduct(product);
      } else {
        await FirestoreService.addProduct(product);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Product updated successfully'
                : 'Product added successfully',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save product: $e',
          ),
        ),
      );
    }
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value.trim());

    if (price == null) {
      return 'Enter a valid price';
    }

    if (price <= 0) {
      return 'Price must be greater than 0';
    }

    return null;
  }

  String? _validateRating(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Rating is required';
    }

    final rating = double.tryParse(value.trim());

    if (rating == null) {
      return 'Enter a valid rating';
    }

    if (rating < 0 || rating > 5) {
      return 'Rating must be between 0 and 5';
    }

    return null;
  }

  String? _validateDiscount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final discount = double.tryParse(value.trim());

    if (discount == null) {
      return 'Enter a valid discount';
    }

    if (discount < 0 || discount > 100) {
      return 'Discount must be between 0 and 100';
    }

    return null;
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppTheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing
        ? 'Edit Product'
        : 'Add Product';

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Product Information',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.isEditing
                      ? 'Update the product details below.'
                      : 'Add a new product to your store.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height:10),

                TextFormField(
                  controller: _nameController,
                  textInputAction:
                      TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Product Name',
                    icon: Icons.inventory_2_outlined,
                    hint: 'e.g. Wireless Headphones',
                  ),
                  validator: _validateRequired,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _imageUrlController,
                  keyboardType: TextInputType.url,
                  textInputAction:
                      TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Image URL',
                    icon: Icons.image_outlined,
                    hint: 'https://...',
                  ),
                  validator: _validateRequired,
                ),

                const SizedBox(height: 7),

                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: _inputDecoration(
                    label: 'Category',
                    icon: Icons.category_outlined,
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Row(
                        children: [
                          Icon(
                            category.icon,
                            size: 20,
                            color: category.color,
                          ),
                          const SizedBox(width: 10),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please select a category';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 7),

                TextFormField(
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction:
                      TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Price',
                    icon: Icons.attach_money_rounded,
                    hint: 'e.g. 59.99',
                  ),
                  validator: _validatePrice,
                ),

                const SizedBox(height:7),

                TextFormField(
                  controller: _ratingController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction:
                      TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Rating',
                    icon: Icons.star_outline_rounded,
                    hint: '0 - 5',
                  ),
                  validator: _validateRating,
                ),

                const SizedBox(height:7),

                TextFormField(
                  controller: _discountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction:
                      TextInputAction.next,
                  decoration: _inputDecoration(
                    label: 'Discount %',
                    icon: Icons.local_offer_outlined,
                    hint: 'Optional, e.g. 20',
                  ),
                  validator: _validateDiscount,
                ),

                const SizedBox(height: 7),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  textInputAction:
                      TextInputAction.newline,
                  decoration: _inputDecoration(
                    label: 'Description',
                    icon: Icons.description_outlined,
                    hint:
                        'Enter product description...',
                  ),
                  validator: _validateRequired,
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),

                    onPressed:
                        _isSaving ? null : _saveProduct,

                    child: _isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.isEditing
                                ? 'Update Product'
                                : 'Add Product',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}