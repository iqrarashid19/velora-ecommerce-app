import 'dart:async';
import 'package:e_commerce_app/screens/home.dart';
import 'package:e_commerce_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        _checkUser();
      },
    );
  }

  void _checkUser() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Top decorative circle
            Positioned(
              top: -90,
              right: -70,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(
                    alpha: 0.08,
                  ),
                ),
              ),
            ),

            // Bottom decorative circle
            Positioned(
              bottom: -110,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(
                    alpha: 0.07,
                  ),
                ),
              ),
            ),

            // Small decorative dots
            Positioned(
              top: 80,
              right: 30,
              child: _buildDots(),
            ),

            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius:
                              BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary
                                  .withValues(alpha: 0.22),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.white,
                          size: 43,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // App name
                      Text(
                        'VELORA',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'SHOP MORE, LIVE BETTER',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom loading indicator
            Positioned(
              left: 0,
              right: 0,
              bottom: 35,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 45,
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        borderRadius:
                            BorderRadius.circular(10),
                        backgroundColor:
                            AppTheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                          AppTheme.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Welcome to Velora',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Column(
      children: List.generate(
        4,
        (row) => Row(
          children: List.generate(
            4,
            (column) => Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(
                  alpha: 0.18,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}