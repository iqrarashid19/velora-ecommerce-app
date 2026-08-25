import 'package:flutter/material.dart';

class AddToCartButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const AddToCartButton({
    super.key,
    this.onPressed,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void _handlePressed() {
    _controller.forward().then((_) {
      if (mounted) {
        _controller.reverse();
      }
    });

    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        height: 38,
        width: 38,
        child: IconButton(
          onPressed: _handlePressed,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF171717),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(
            Icons.add_shopping_cart_rounded,
            size: 19,
          ),
        ),
      ),
    );
  }
}