import 'dart:async';

import 'package:flutter/material.dart';
import 'package:e_commerce_app/theme/app_theme.dart';

class PromoBanner {
  final String label;
  final String title;
  final String subtitle;
  final String imageUrl;

  const PromoBanner({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class AnimatedPromoBanner extends StatefulWidget {
  const AnimatedPromoBanner({
    super.key,
  });

  @override
  State<AnimatedPromoBanner> createState() =>
      _AnimatedPromoBannerState();
}

class _AnimatedPromoBannerState
    extends State<AnimatedPromoBanner> {
  final PageController _pageController =
      PageController();

  Timer? _timer;

  int _currentPage = 0;

  final List<PromoBanner> _banners = const [
  PromoBanner(
    label: 'NEW SEASON',
    title: 'Find Your Sound',
    subtitle: 'Discover the latest audio collection.',
    imageUrl: 'assets/images/banners/headphones.png',
  ),

  PromoBanner(
    label: 'NEW ARRIVALS',
    title: 'Step Up Your Style',
    subtitle: 'Explore the latest footwear collection.',
    imageUrl: 'assets/images/banners/shoes.png',
  ),

  PromoBanner(
    label: 'SMART STYLE',
    title: 'Stay Connected',
    subtitle: 'Discover smart essentials for everyday life.',
    imageUrl: 'assets/images/banners/smartwatch.png',
  ),
];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!_pageController.hasClients) {
          return;
        }

        final nextPage =
            (_currentPage + 1) % _banners.length;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(
            milliseconds: 600,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return PromoBannerCard(
                banner: _banners[index],
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) {
              final isActive =
                  index == _currentPage;

              return AnimatedContainer(
                duration: const Duration(
                  milliseconds: 250,
                ),
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                width: isActive ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primary
                      : Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PromoBannerCard extends StatelessWidget {
  final PromoBanner banner;

  const PromoBannerCard({
    super.key,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFEBDDF7),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background decorative circle
          Positioned(
            right: -45,
            top: -55,
            bottom: -55,
            child: Container(
              width: 235,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDCC3EF),
              ),
            ),
          ),

          // Product / lifestyle image
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 185,
              child: ClipPath(
                clipper: _BannerImageClipper(),
                child: Image.asset(
                  banner.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      color:
                          const Color(0xFFDCC3EF),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 35,
                        color: Colors.black26,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Soft image fade
          Positioned(
            right: 115,
            top: 0,
            bottom: 0,
            width: 70,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFFEBDDF7),
                      const Color(0xFFEBDDF7)
                          .withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Decorative dots
          Positioned(
            right: 14,
            top: 13,
            child: Column(
              children: List.generate(
                4,
                (row) => Row(
                  children: List.generate(
                    4,
                    (column) => Container(
                      width: 4,
                      height: 4,
                      margin:
                          const EdgeInsets.all(3),
                      decoration:
                          const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF9A62CF),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Main text content
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            right: 140,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  banner.label,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  banner.title,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF171717),
                    fontSize: 22,
                    height: 1.05,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  banner.subtitle,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 10.5,
                    height: 1.25,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius:
                        BorderRadius.circular(9),
                  ),
                  child: const Text(
                    'Shop Now  →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom decorative waves
          Positioned(
            left: 190,
            bottom: 14,
            child: Row(
              children: List.generate(
                3,
                (index) => Container(
                  width: 20,
                  height: 4,
                  margin:
                      const EdgeInsets.only(
                    right: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10),
                    color: const Color(0xFFB88BDD),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerImageClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(45, 0);

    path.quadraticBezierTo(
      5,
      size.height * 0.25,
      25,
      size.height * 0.50,
    );

    path.quadraticBezierTo(
      5,
      size.height * 0.75,
      45,
      size.height,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      size.width,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    covariant CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}