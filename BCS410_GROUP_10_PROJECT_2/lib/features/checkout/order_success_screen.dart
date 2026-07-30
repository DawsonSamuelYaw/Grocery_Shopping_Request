import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/primary_button.dart';
import '../../navigation/main_shell.dart';
import '../../providers/grocery_store.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    super.key,
    required this.total,
    required this.itemCount,
    required this.orderNumber,
    required this.deliveryTime,
    required this.deliveryAddress,
    required this.paymentMethod,
  });

  final double total;
  final int itemCount;
  final String orderNumber;
  final String deliveryTime;
  final String deliveryAddress;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                24,
                30,
                24,
                30,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                  constraints.maxHeight - 60,
                ),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        color:
                        AppColors.softGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green
                                .withValues(
                              alpha: 0.14,
                            ),
                            blurRadius: 30,
                            offset:
                            const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons
                            .check_circle_rounded,
                        size: 70,
                        color: AppColors.green,
                      ),
                    ),

                    const SizedBox(height: 26),

                    const Text(
                      'Order confirmed!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                        AppColors.darkGreen,
                        fontSize: 29,
                        height: 1.2,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'Thank you for shopping with us. Your grocery request has been received.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .cardColor,
                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          _SuccessDetailRow(
                            label:
                            'Order number',
                            value:
                            '#$orderNumber',
                          ),
                          _SuccessDetailRow(
                            label: 'Items',
                            value:
                            '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                          ),
                          _SuccessDetailRow(
                            label: 'Total paid',
                            value: money(total),
                          ),
                          _SuccessDetailRow(
                            label:
                            'Delivery time',
                            value:
                            deliveryTime,
                          ),
                          _SuccessDetailRow(
                            label: 'Address',
                            value:
                            deliveryAddress,
                          ),
                          _SuccessDetailRow(
                            label:
                            'Payment method',
                            value:
                            paymentMethod,
                            removeBottomPadding:
                            true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen
                            .withValues(alpha: 0.55),
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons
                                .local_shipping_outlined,
                            color:
                            AppColors.green,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You will receive updates as your order is prepared and delivered.',
                              style: TextStyle(
                                color: AppColors
                                    .darkGreen,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    PrimaryButton(
                      label: 'View my orders',
                      icon: Icons
                          .receipt_long_outlined,
                      onPressed: () {
                        final store =
                        context.read<
                            GroceryStore>();

                        store.setTab(3);

                        Navigator
                            .pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const MainShell(),
                          ),
                              (route) => false,
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final store =
                          context.read<
                              GroceryStore>();

                          store.setTab(0);

                          Navigator
                              .pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const MainShell(),
                            ),
                                (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons
                              .storefront_outlined,
                        ),
                        label: const Text(
                          'Continue shopping',
                        ),
                        style:
                        OutlinedButton.styleFrom(
                          foregroundColor:
                          AppColors.darkGreen,
                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          side: const BorderSide(
                            color:
                            AppColors.green,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SuccessDetailRow
    extends StatelessWidget {
  const _SuccessDetailRow({
    required this.label,
    required this.value,
    this.removeBottomPadding = false,
  });

  final String label;
  final String value;
  final bool removeBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
        removeBottomPadding ? 0 : 16,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color:
                AppColors.darkGreen,
                fontSize: 13,
                height: 1.4,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}