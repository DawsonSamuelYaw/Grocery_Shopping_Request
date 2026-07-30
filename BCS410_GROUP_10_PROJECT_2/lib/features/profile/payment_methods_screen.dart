import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState
    extends State<PaymentMethodsScreen> {
  final List<SavedPaymentMethod> _methods = [
    const SavedPaymentMethod(
      id: 'momo-1',
      title: 'MTN Mobile Money',
      subtitle: '024 *** 0000',
      type: PaymentMethodType.mobileMoney,
      isDefault: true,
    ),
    const SavedPaymentMethod(
      id: 'card-1',
      title: 'Visa card',
      subtitle: '•••• •••• •••• 3245',
      type: PaymentMethodType.card,
      isDefault: false,
    ),
  ];

  Future<void> _addPaymentMethod() async {
    final result = await showModalBottomSheet<SavedPaymentMethod>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return const _AddPaymentMethodSheet();
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _methods.add(result);
    });
  }

  void _makeDefault(SavedPaymentMethod method) {
    setState(() {
      for (var index = 0; index < _methods.length; index++) {
        final item = _methods[index];

        _methods[index] = item.copyWith(
          isDefault: item.id == method.id,
        );
      }
    });
  }

  Future<void> _removeMethod(
      SavedPaymentMethod method,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove payment method?'),
          content: Text(
            'Remove ${method.title} from your account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.red,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _methods.removeWhere(
            (item) => item.id == method.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment methods'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPaymentMethod,
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_card_outlined),
        label: const Text('Add payment'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            100,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.security_rounded,
                    color: AppColors.green,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your payment details are stored securely for faster checkout.',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_methods.isEmpty)
              const _EmptyPaymentState()
            else
              ..._methods.map(
                    (method) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _PaymentMethodCard(
                    method: method,
                    onMakeDefault: () {
                      _makeDefault(method);
                    },
                    onRemove: () {
                      _removeMethod(method);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.onMakeDefault,
    required this.onRemove,
  });

  final SavedPaymentMethod method;
  final VoidCallback onMakeDefault;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: method.isDefault
              ? AppColors.green
              : AppColors.border,
          width: method.isDefault ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.softGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              method.type == PaymentMethodType.card
                  ? Icons.credit_card_rounded
                  : Icons.phone_android_rounded,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.title,
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  method.subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                  ),
                ),
                if (method.isDefault) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Default payment method',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'default') {
                onMakeDefault();
              } else if (value == 'remove') {
                onRemove();
              }
            },
            itemBuilder: (_) {
              return [
                if (!method.isDefault)
                  const PopupMenuItem(
                    value: 'default',
                    child: Text('Make default'),
                  ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _AddPaymentMethodSheet extends StatefulWidget {
  const _AddPaymentMethodSheet();

  @override
  State<_AddPaymentMethodSheet> createState() =>
      _AddPaymentMethodSheetState();
}

class _AddPaymentMethodSheetState
    extends State<_AddPaymentMethodSheet> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();

  PaymentMethodType _type =
      PaymentMethodType.mobileMoney;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCard = _type == PaymentMethodType.card;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        8,
        22,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add payment method',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              SegmentedButton<PaymentMethodType>(
                segments: const [
                  ButtonSegment(
                    value: PaymentMethodType.mobileMoney,
                    icon: Icon(Icons.phone_android_rounded),
                    label: Text('Mobile Money'),
                  ),
                  ButtonSegment(
                    value: PaymentMethodType.card,
                    icon: Icon(Icons.credit_card_rounded),
                    label: Text('Card'),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (selection) {
                  setState(() {
                    _type = selection.first;
                    _numberController.clear();
                  });
                },
              ),
              const SizedBox(height: 22),
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isCard
                      ? 'Card number'
                      : 'Mobile Money number',
                  hintText: isCard
                      ? '1234 5678 9012 3456'
                      : '024 000 0000',
                  prefixIcon: Icon(
                    isCard
                        ? Icons.credit_card_outlined
                        : Icons.phone_outlined,
                  ),
                ),
                validator: (value) {
                  final digits = (value ?? '').replaceAll(
                    RegExp(r'[^0-9]'),
                    '',
                  );

                  if (isCard && digits.length < 16) {
                    return 'Enter a valid card number';
                  }

                  if (!isCard && digits.length < 10) {
                    return 'Enter a valid phone number';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ??
                        false)) {
                      return;
                    }

                    final digits = _numberController.text
                        .replaceAll(RegExp(r'[^0-9]'), '');

                    final ending = digits.substring(
                      digits.length - 4,
                    );

                    Navigator.pop(
                      context,
                      SavedPaymentMethod(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        title: isCard
                            ? 'Payment card'
                            : 'Mobile Money',
                        subtitle: isCard
                            ? '•••• •••• •••• $ending'
                            : '*** *** $ending',
                        type: _type,
                        isDefault: false,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Save payment method'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPaymentState extends StatelessWidget {
  const _EmptyPaymentState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.credit_card_off_outlined,
            size: 70,
            color: AppColors.muted,
          ),
          SizedBox(height: 18),
          Text(
            'No payment methods',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum PaymentMethodType {
  mobileMoney,
  card,
}

class SavedPaymentMethod {
  const SavedPaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.isDefault,
  });

  final String id;
  final String title;
  final String subtitle;
  final PaymentMethodType type;
  final bool isDefault;

  SavedPaymentMethod copyWith({
    bool? isDefault,
  }) {
    return SavedPaymentMethod(
      id: id,
      title: title,
      subtitle: subtitle,
      type: type,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}