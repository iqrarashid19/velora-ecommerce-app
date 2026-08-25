class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final String description;
  final double rating;
  final double? discountPercentage;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
    this.discountPercentage,
  });
}