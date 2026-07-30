import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/summary_row.dart';
import '../../providers/grocery_store.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();
    const methods = [
      'Debit / credit card',
      'Cash on delivery',
      'Mobile money wallet',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Delivery address\n12 Cantonments Road, Accra',
              style: TextStyle(height: 1.5),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Delivery time'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              'As soon as possible',
              'Schedule',
            ].map((value) {
              return ChoiceChip(
                label: Text(value),
                selected: store.selectedDeliveryTime == value,
                onSelected: (_) => store.setDeliveryTime(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Text('Payment method'),
          const SizedBox(height: 10),
          ...methods.map(
            (value) => RadioListTile<String>(
              value: value,
              groupValue: store.selectedPayment,
              onChanged: (newValue) {
                if (newValue != null) store.setPayment(newValue);
              },
              title: Text(value),
            ),
          ),
          const SizedBox(height: 20),
          SummaryRow(label: 'Items', value: store.subtotal),
          SummaryRow(
            label: 'Fees and delivery',
            value: store.serviceFee + store.deliveryFee,
          ),
          const Divider(),
          SummaryRow(label: 'Total', value: store.total, emphasized: true),
          const SizedBox(height: 40),
          PrimaryButton(
            label: 'Place order',
            onPressed: () {
              final total = store.total;
              store.clearCart();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderSuccessScreen(total: total),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
