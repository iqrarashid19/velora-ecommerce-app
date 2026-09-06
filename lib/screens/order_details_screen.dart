import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/order.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:e_commerce_app/services/firestore_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order order;
  final bool isAdmin;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    this.isAdmin = false,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String _currentStatus;
  bool _isUpdating = false;

  final List<String> _statuses = [
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
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
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${widget.order.id}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Order Date: ${widget.order.orderDate.day}/${widget.order.orderDate.month}/${widget.order.orderDate.year}',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // CURRENT STATUS
            // --------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: _statusColor(_currentStatus)
                    .withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 19,
                    color: _statusColor(_currentStatus),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    'Status: $_currentStatus',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(_currentStatus),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // ORDER TRACKING
            // --------------------------------------------------
            const Text(
              'Order Tracking',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildTrackingCard(),

            // --------------------------------------------------
            // ADMIN STATUS UPDATE
            // --------------------------------------------------
            if (widget.isAdmin) ...[
              const SizedBox(height: 24),

              const Text(
                'Change Status',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentStatus,
                    isExpanded: true,

                    items: _statuses.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: _isUpdating
                        ? null
                        : (value) async {
                            if (value == null ||
                                value == _currentStatus) {
                              return;
                            }

                            if (widget.order.userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'User ID not found for this order',
                                  ),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              _isUpdating = true;
                            });

                            try {
                              await FirestoreService.updateOrderStatus(
                                widget.order.userId!,
                                widget.order.id,
                                value,
                              );

                              if (!mounted) return;

                              setState(() {
                                _currentStatus = value;
                                _isUpdating = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Order status updated to $value',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;

                              setState(() {
                                _isUpdating = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to update status: $e',
                                  ),
                                ),
                              );
                            }
                          },

                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                ),
              ),

              if (_isUpdating) ...[
                const SizedBox(height: 12),

                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],

            const SizedBox(height: 24),

            // --------------------------------------------------
            // ITEMS
            // --------------------------------------------------
            const Text(
              'Items',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...widget.order.items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      'x${item.quantity}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // DELIVERY ADDRESS
            // --------------------------------------------------
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                '${widget.order.name}\n'
                '${widget.order.phone}\n'
                '${widget.order.address}\n'
                '${widget.order.city} - ${widget.order.postalCode}',

                style: const TextStyle(
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // PAYMENT METHOD
            // --------------------------------------------------
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                widget.order.paymentMethod,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // TOTAL
            // --------------------------------------------------
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Order Total',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text(
                    '\$${widget.order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ORDER TRACKING CARD
  // ==========================================================

  Widget _buildTrackingCard() {
    // Cancelled order gets a separate tracking state.
    if (_currentStatus.toLowerCase() == 'cancelled') {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Order Cancelled',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'This order has been cancelled.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    final trackingStatuses = [
      'Pending',
      'Confirmed',
      'Shipped',
      'Delivered',
    ];

    int currentIndex = trackingStatuses.indexWhere(
      (status) =>
          status.toLowerCase() ==
          _currentStatus.toLowerCase(),
    );

    // If an unknown status is found, keep Pending active.
    if (currentIndex == -1) {
      currentIndex = 0;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: List.generate(
          trackingStatuses.length,
          (index) {
            final status = trackingStatuses[index];

            final bool isCompleted = index <= currentIndex;
            final bool isCurrent = index == currentIndex;
            final bool isLast =
                index == trackingStatuses.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),

                      width: isCurrent ? 42 : 34,
                      height: isCurrent ? 42 : 34,

                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.primary
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,

                        border: isCurrent
                            ? Border.all(
                                color: AppTheme.primary
                                    .withValues(alpha: 0.20),
                                width: 5,
                              )
                            : null,
                      ),

                      child: Icon(
                        _trackingIcon(status),
                        size: isCurrent ? 21 : 18,
                        color: isCompleted
                            ? Colors.white
                            : Colors.grey.shade500,
                      ),
                    ),

                    if (!isLast)
                      Container(
                        width: 2,
                        height: 38,
                        color: index < currentIndex
                            ? AppTheme.primary
                            : Colors.grey.shade200,
                      ),
                  ],
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 25,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isCompleted
                                ? Colors.black87
                                : Colors.grey.shade500,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          _trackingDescription(status),
                          style: TextStyle(
                            fontSize: 12,
                            color: isCompleted
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  IconData _trackingIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule_rounded;

      case 'confirmed':
        return Icons.check_circle_outline_rounded;

      case 'shipped':
        return Icons.local_shipping_outlined;

      case 'delivered':
        return Icons.home_rounded;

      default:
        return Icons.circle_outlined;
    }
  }

  String _trackingDescription(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Your order has been placed and is awaiting confirmation.';

      case 'confirmed':
        return 'Your order has been confirmed and is being prepared.';

      case 'shipped':
        return 'Your order is on its way to you.';

      case 'delivered':
        return 'Your order has been successfully delivered.';

      default:
        return '';
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue;

      case 'shipped':
        return Colors.orange;

      case 'delivered':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}