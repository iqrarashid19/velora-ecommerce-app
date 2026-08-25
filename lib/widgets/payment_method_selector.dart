import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/payment_option.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  static const List<String> paymentMethods = [
    'Cash on Delivery',
    'Credit / Debit Card',
    'Mobile Wallet',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final method in paymentMethods)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PaymentOption(
              title: method,
              icon: _getIcon(method),
              isSelected: selectedMethod == method,
              onTap: () {
                onChanged(method);
              },
            ),
          ),
      ],
    );
  }

  IconData _getIcon(String method) {
    switch (method) {
      case 'Cash on Delivery':
        return Icons.money_outlined;

      case 'Credit / Debit Card':
        return Icons.credit_card_outlined;

      case 'Mobile Wallet':
        return Icons.account_balance_wallet_outlined;

      default:
        return Icons.payment_outlined;
    }
  }
}