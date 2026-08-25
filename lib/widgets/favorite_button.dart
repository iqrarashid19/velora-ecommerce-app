import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/providers/favorites_provider.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,required this.product
  });
final Product product;
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {


  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void _toggleFavorite() {
  context.read<FavoritesProvider>().toggleFavorite(widget.product);

  _controller.forward(from: 0).then((_) {
    if (mounted) {
      _controller.reverse();
    }
  });
}
    

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final favorites = context.watch<FavoritesProvider>();
final isFavorite = favorites.isFavorite(widget.product.id);
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: IconButton(
        onPressed: _toggleFavorite,
        splashRadius: 22,
        icon: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: isFavorite
                ? const Color(0xFFE63970)
                : Colors.black87,
            size: 21,
          ),
        ),
      ),
    );
  }
}