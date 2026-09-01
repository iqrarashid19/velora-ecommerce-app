import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:e_commerce_app/screens/orders_screen.dart';
import 'package:e_commerce_app/screens/favorites_screen.dart';
import 'package:e_commerce_app/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/providers/address_provider.dart';
import 'package:e_commerce_app/widgets/address_form.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final userName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : 'Velora User';

    final userEmail = user?.email ?? '';

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // --------------------------------------------------
            // PROFILE HEADER
            // --------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor:
                        AppTheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_rounded,
                      size: 45,
                      color: AppTheme.primary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Welcome to your account',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // MY ORDERS
            // --------------------------------------------------
            _ProfileOption(
              icon: Icons.receipt_long_outlined,
              title: 'My Orders',
              subtitle: 'View your previous orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersScreen(),
                  ),
                );
              },
            ),

            // --------------------------------------------------
            // FAVORITES
            // --------------------------------------------------
            _ProfileOption(
              icon: Icons.favorite_border_rounded,
              title: 'Favorites',
              subtitle: 'View your favorite products',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),

            // --------------------------------------------------
            // DELIVERY ADDRESS
            // --------------------------------------------------
            _ProfileOption(
              icon: Icons.location_on_outlined,
              title: 'Delivery Address',
              subtitle: context.watch<AddressProvider>().hasAddress
                  ? '${context.watch<AddressProvider>().address}, '
                      '${context.watch<AddressProvider>().city}'
                  : 'Add your delivery address',
              onTap: () {
                final addressProvider =
                    context.read<AddressProvider>();

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom +
                                20,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: AddressForm(
                          onSaved: (
                            name,
                            phone,
                            address,
                            city,
                            postalCode,
                          ) {
                            addressProvider.saveAddress(
                              name: name,
                              phone: phone,
                              address: address,
                              city: city,
                              postalCode: postalCode,
                            );

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // --------------------------------------------------
            // SETTINGS
            // --------------------------------------------------
            _ProfileOption(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Manage app preferences',
              onTap: () {},
            ),

            const SizedBox(height: 8),

            // --------------------------------------------------
            // LOGOUT
            // --------------------------------------------------
            _ProfileOption(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Sign out from your Velora account',
              onTap: () {
                _logout(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor:
              AppTheme.primary.withValues(alpha: 0.1),
          child: Icon(
            icon,
            color: AppTheme.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
        ),
      ),
    );
  }
}