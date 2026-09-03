import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/providers/order_provider.dart';
import 'package:e_commerce_app/providers/address_provider.dart';

import 'package:e_commerce_app/models/order.dart';
import 'package:e_commerce_app/screens/order_success_screen.dart';

import 'package:e_commerce_app/widgets/address_form.dart';
import 'package:e_commerce_app/widgets/payment_method_selector.dart';

import 'package:e_commerce_app/theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Cash on Delivery';

  void _showPaymentMethods() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: PaymentMethodSelector(
            selectedMethod: _selectedPaymentMethod,
            onChanged: (method) {
              setState(() {
                _selectedPaymentMethod = method;
              });

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showAddressForm() {
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
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                context.read<AddressProvider>().saveAddress(
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
  }

  Future<void> _placeOrder() async {
    final addressProvider = context.read<AddressProvider>();
    final cart = context.read<CartProvider>();

    // Check delivery information.
    if (!addressProvider.hasAddress ||
        addressProvider.name == null ||
        addressProvider.phone == null ||
        addressProvider.postalCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete your delivery information first.',
          ),
        ),
      );

      return;
    }

    // Check cart.
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your cart is empty.',
          ),
        ),
      );

      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    // Check user authentication.
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login before placing an order.',
          ),
        ),
      );

      return;
    }

    final deliveryFee =
        cart.totalAmount >= 100 ? 0.0 : 5.0;

    final grandTotal =
        cart.totalAmount + deliveryFee;

    final order = Order(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      items: cart.items.values.toList(),
      totalAmount: grandTotal,

      // AddressProvider data
      name: addressProvider.name!,
      phone: addressProvider.phone!,
      address: addressProvider.address!,
      city: addressProvider.city!,
      postalCode: addressProvider.postalCode!,

      // Checkout-specific data
      paymentMethod: _selectedPaymentMethod,
      orderDate: DateTime.now(),
    );

    try {
      await FirestoreService.saveOrder(
        order,
        user.uid,
      );

      context.read<OrderProvider>().addOrder(order);

      cart.clearCart();

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OrderSuccessScreen(
            orderId: order.id,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to place order. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addressProvider =
        context.watch<AddressProvider>();

    final deliveryFee =
        cart.totalAmount >= 100 ? 0.0 : 5.0;

    final grandTotal =
        cart.totalAmount + deliveryFee;

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _CheckoutCard(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',

                subtitle:
                    addressProvider.hasAddress
                        ? '${addressProvider.address}, '
                            '${addressProvider.city}'
                        : 'Add your delivery address',

                onTap: _showAddressForm,
              ),

              const SizedBox(height:6),

              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              _CheckoutCard(
                icon: Icons.person_outline_rounded,
                title: 'Customer',
                subtitle:
                    addressProvider.name ??
                        'Add your name',
                onTap: _showAddressForm,
              ),

              const SizedBox(height: 5),

              _CheckoutCard(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                subtitle:
                    addressProvider.phone ??
                        'Add your phone number',
                onTap: _showAddressForm,
              ),

              const SizedBox(height: 6),

              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              _CheckoutCard(
                icon: Icons.credit_card_outlined,
                title: 'Payment Method',
                subtitle:
                    _selectedPaymentMethod,
                onTap: _showPaymentMethods,
              ),

              const SizedBox(height:6),

              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      title: 'Subtotal',
                      amount:
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                    ),

                    const SizedBox(height:6),

                    _SummaryRow(
                      title: 'Delivery',
                      amount: deliveryFee == 0
                          ? 'FREE'
                          : '\$${deliveryFee.toStringAsFixed(2)}',
                    ),

                    const Divider(
                      height: 24,
                    ),

                    _SummaryRow(
                      title: 'Total',
                      amount:
                          '\$${grandTotal.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height:6),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF171717),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CheckoutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.black
                    .withValues(alpha: 0.06),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                    const Color(0xFF171717),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize:
                isTotal ? 18 : 14,
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),

        Text(
          amount,
          style: TextStyle(
            fontSize:
                isTotal ? 19 : 14,
            fontWeight: isTotal
                ? FontWeight.bold
                : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}