import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/grocery_store.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() =>
      _CheckoutScreenState();
}

class _CheckoutScreenState
    extends State<CheckoutScreen> {
  final PageController _pageController =
  PageController();

  final GlobalKey<FormState> _deliveryFormKey =
  GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController(
    text: 'Abdul Razak Iddriss',
  );

  final TextEditingController _phoneController =
  TextEditingController(
    text: '0240000000',
  );

  final TextEditingController _addressController =
  TextEditingController(
    text: 'Madina, Accra',
  );

  final TextEditingController _landmarkController =
  TextEditingController();

  final TextEditingController _instructionsController =
  TextEditingController();

  int _currentStep = 0;
  bool _isProcessing = false;

  static const List<String> _stepLabels = [
    'Delivery',
    'Payment',
    'Review',
  ];

  static const List<String> _deliveryTimes = [
    'As soon as possible',
    '9:00 AM - 10:00 AM',
    '12:00 PM - 1:00 PM',
    '5:00 PM - 6:00 PM',
  ];

  static const List<_PaymentOption>
  _paymentOptions = [
    _PaymentOption(
      title: 'Mobile Money',
      subtitle: 'MTN, Telecel or AirtelTigo',
      icon: Icons.phone_android_rounded,
    ),
    _PaymentOption(
      title: 'Debit / credit card',
      subtitle: 'Visa or Mastercard',
      icon: Icons.credit_card_rounded,
    ),
    _PaymentOption(
      title: 'Cash on delivery',
      subtitle: 'Pay when your order arrives',
      icon: Icons.payments_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step < 0 ||
        step >= _stepLabels.length) {
      return;
    }

    setState(() {
      _currentStep = step;
    });

    _pageController.animateToPage(
      step,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeInOut,
    );
  }

  void _continueFromDelivery() {
    FocusScope.of(context).unfocus();

    if (!(_deliveryFormKey.currentState
        ?.validate() ??
        false)) {
      return;
    }

    _goToStep(1);
  }

  void _continueFromPayment() {
    final store = context.read<GroceryStore>();

    if (store.selectedPayment.trim().isEmpty) {
      _showMessage(
        'Select a payment method.',
        isError: true,
      );
      return;
    }

    _goToStep(2);
  }

  Future<void> _placeOrder() async {
    final store = context.read<GroceryStore>();

    if (store.isCartEmpty) {
      _showMessage(
        'Your cart is empty.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final double orderTotal = store.total;
    final int itemCount = store.cartCount;
    final String orderNumber =
    _generateOrderNumber();

    await Future<void>.delayed(
      const Duration(milliseconds: 1400),
    );

    if (!mounted) {
      return;
    }

    store.clearCart();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          total: orderTotal,
          itemCount: itemCount,
          orderNumber: orderNumber,
          deliveryTime:
          store.selectedDeliveryTime,
          deliveryAddress:
          _addressController.text.trim(),
          paymentMethod:
          store.selectedPayment,
        ),
      ),
    );
  }

  String _generateOrderNumber() {
    final now = DateTime.now();

    final suffix =
    now.millisecondsSinceEpoch
        .toString()
        .substring(7);

    return 'GA$suffix';
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? AppColors.red
              : AppColors.green,
        ),
      );
  }

  Future<bool> _handleBack() async {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (
          didPop,
          result,
          ) {
        if (!didPop && _currentStep > 0) {
          _goToStep(_currentStep - 1);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: false,
          leading: IconButton(
            onPressed: () async {
              final canPop =
              await _handleBack();

              if (canPop && context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _CheckoutProgress(
                currentStep: _currentStep,
                labels: _stepLabels,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  children: [
                    _DeliveryStep(
                      formKey:
                      _deliveryFormKey,
                      nameController:
                      _nameController,
                      phoneController:
                      _phoneController,
                      addressController:
                      _addressController,
                      landmarkController:
                      _landmarkController,
                      instructionsController:
                      _instructionsController,
                      deliveryTimes:
                      _deliveryTimes,
                      selectedDeliveryTime:
                      store.selectedDeliveryTime,
                      onDeliveryTimeChanged:
                      store.setDeliveryTime,
                      onContinue:
                      _continueFromDelivery,
                    ),
                    _PaymentStep(
                      options:
                      _paymentOptions,
                      selectedPayment:
                      store.selectedPayment,
                      onPaymentChanged:
                      store.setPayment,
                      onBack: () {
                        _goToStep(0);
                      },
                      onContinue:
                      _continueFromPayment,
                    ),
                    _ReviewStep(
                      store: store,
                      name:
                      _nameController.text.trim(),
                      phone:
                      _phoneController.text.trim(),
                      address:
                      _addressController.text.trim(),
                      landmark:
                      _landmarkController.text.trim(),
                      instructions:
                      _instructionsController.text
                          .trim(),
                      isProcessing:
                      _isProcessing,
                      onBack: () {
                        _goToStep(1);
                      },
                      onPlaceOrder:
                      _placeOrder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutProgress extends StatelessWidget {
  const _CheckoutProgress({
    required this.currentStep,
    required this.labels,
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        16,
      ),
      child: Row(
        children: List.generate(
          labels.length,
              (index) {
            final completed =
                index < currentStep;
            final selected =
                index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: completed ||
                              selected
                              ? AppColors.green
                              : AppColors.softGreen,
                          shape: BoxShape.circle,
                        ),
                        alignment:
                        Alignment.center,
                        child: completed
                            ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        )
                            : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors
                                .darkGreen,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: selected
                              ? AppColors.darkGreen
                              : AppColors.muted,
                          fontSize: 11.5,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (index <
                      labels.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin:
                        const EdgeInsets.only(
                          left: 7,
                          right: 7,
                          bottom: 20,
                        ),
                        color: index <
                            currentStep
                            ? AppColors.green
                            : AppColors.border,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DeliveryStep extends StatelessWidget {
  const _DeliveryStep({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.landmarkController,
    required this.instructionsController,
    required this.deliveryTimes,
    required this.selectedDeliveryTime,
    required this.onDeliveryTimeChanged,
    required this.onContinue,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController landmarkController;
  final TextEditingController
  instructionsController;

  final List<String> deliveryTimes;
  final String selectedDeliveryTime;

  final ValueChanged<String>
  onDeliveryTimeChanged;

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        32,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _StepHeading(
              title: 'Delivery details',
              subtitle:
              'Tell us where and when to deliver your groceries.',
            ),
            const SizedBox(height: 22),
            const _FieldLabel(
              label: 'Recipient name',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameController,
              textCapitalization:
              TextCapitalization.words,
              textInputAction:
              TextInputAction.next,
              decoration:
              const InputDecoration(
                hintText:
                'Enter recipient name',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().length < 3) {
                  return 'Enter a valid recipient name';
                }

                return null;
              },
            ),
            const SizedBox(height: 18),
            const _FieldLabel(
              label: 'Phone number',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: phoneController,
              keyboardType:
              TextInputType.phone,
              textInputAction:
              TextInputAction.next,
              decoration:
              const InputDecoration(
                hintText: '024 000 0000',
                prefixIcon: Icon(
                  Icons.phone_outlined,
                ),
              ),
              validator: (value) {
                final digits =
                (value ?? '').replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );

                if (digits.length < 10) {
                  return 'Enter a valid phone number';
                }

                return null;
              },
            ),
            const SizedBox(height: 18),
            const _FieldLabel(
              label: 'Delivery address',
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller:
              addressController,
              textCapitalization:
              TextCapitalization.sentences,
              textInputAction:
              TextInputAction.next,
              maxLines: 2,
              decoration:
              const InputDecoration(
                hintText:
                'House number, street and area',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().length < 5) {
                  return 'Enter a complete delivery address';
                }

                return null;
              },
            ),
            const SizedBox(height: 18),
            const _FieldLabel(
              label: 'Landmark',
              optional: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller:
              landmarkController,
              textCapitalization:
              TextCapitalization.sentences,
              textInputAction:
              TextInputAction.next,
              decoration:
              const InputDecoration(
                hintText:
                'Near a school, shop or junction',
                prefixIcon: Icon(
                  Icons.explore_outlined,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _FieldLabel(
              label: 'Delivery time',
            ),
            const SizedBox(height: 11),
            ...deliveryTimes.map(
                  (time) {
                final selected =
                    time ==
                        selectedDeliveryTime;

                return Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: _SelectionCard(
                    selected: selected,
                    icon: Icons
                        .schedule_outlined,
                    title: time,
                    subtitle: time ==
                        'As soon as possible'
                        ? 'Estimated delivery in 35–50 minutes'
                        : 'Schedule delivery for this time',
                    onTap: () {
                      onDeliveryTimeChanged(
                        time,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const _FieldLabel(
              label: 'Delivery instructions',
              optional: true,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller:
              instructionsController,
              textCapitalization:
              TextCapitalization.sentences,
              maxLines: 3,
              decoration:
              const InputDecoration(
                hintText:
                'Example: Leave the order at the security gate.',
                prefixIcon: Icon(
                  Icons.notes_rounded,
                ),
              ),
            ),
            const SizedBox(height: 26),
            PrimaryButton(
              label: 'Continue to payment',
              icon:
              Icons.arrow_forward_rounded,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  const _PaymentStep({
    required this.options,
    required this.selectedPayment,
    required this.onPaymentChanged,
    required this.onBack,
    required this.onContinue,
  });

  final List<_PaymentOption> options;
  final String selectedPayment;

  final ValueChanged<String>
  onPaymentChanged;

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        32,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const _StepHeading(
            title: 'Payment method',
            subtitle:
            'Choose how you would like to pay for your order.',
          ),
          const SizedBox(height: 22),
          ...options.map(
                (option) {
              final selected =
                  option.title ==
                      selectedPayment;

              return Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 13,
                ),
                child: _SelectionCard(
                  selected: selected,
                  icon: option.icon,
                  title: option.title,
                  subtitle: option.subtitle,
                  onTap: () {
                    onPaymentChanged(
                      option.title,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: AppColors.softGreen
                  .withValues(alpha: 0.55),
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: const Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: AppColors.green,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your payment information is protected and used only to complete this order.',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style:
                  OutlinedButton.styleFrom(
                    foregroundColor:
                    AppColors.darkGreen,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Review order',
                  icon: Icons
                      .arrow_forward_rounded,
                  onPressed: onContinue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.store,
    required this.name,
    required this.phone,
    required this.address,
    required this.landmark,
    required this.instructions,
    required this.isProcessing,
    required this.onBack,
    required this.onPlaceOrder,
  });

  final GroceryStore store;

  final String name;
  final String phone;
  final String address;
  final String landmark;
  final String instructions;

  final bool isProcessing;
  final VoidCallback onBack;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        32,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const _StepHeading(
            title: 'Review your order',
            subtitle:
            'Confirm your items and delivery information before placing the order.',
          ),
          const SizedBox(height: 22),
          _ReviewSection(
            title: 'Order items',
            icon:
            Icons.shopping_bag_outlined,
            child: Column(
              children: store.cartLines.map(
                    (line) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 13,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${line.product.name} × ${line.quantity}',
                            style:
                            const TextStyle(
                              color: AppColors
                                  .darkGreen,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          money(
                            line.product.price *
                                line.quantity,
                          ),
                          style:
                          const TextStyle(
                            color: AppColors
                                .darkGreen,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          const SizedBox(height: 14),
          _ReviewSection(
            title: 'Delivery information',
            icon:
            Icons.location_on_outlined,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _ReviewDetail(
                  label: 'Recipient',
                  value: name,
                ),
                _ReviewDetail(
                  label: 'Phone',
                  value: phone,
                ),
                _ReviewDetail(
                  label: 'Address',
                  value: address,
                ),
                if (landmark.isNotEmpty)
                  _ReviewDetail(
                    label: 'Landmark',
                    value: landmark,
                  ),
                _ReviewDetail(
                  label: 'Delivery',
                  value: store
                      .selectedDeliveryTime,
                ),
                if (instructions.isNotEmpty)
                  _ReviewDetail(
                    label: 'Instructions',
                    value: instructions,
                    removeBottomPadding: true,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _ReviewSection(
            title: 'Payment',
            icon:
            Icons.wallet_outlined,
            child: _ReviewDetail(
              label: 'Method',
              value: store.selectedPayment,
              removeBottomPadding: true,
            ),
          ),
          const SizedBox(height: 14),
          _ReviewSection(
            title: 'Payment summary',
            icon:
            Icons.receipt_long_outlined,
            child: Column(
              children: [
                _ReviewMoneyRow(
                  label: 'Subtotal',
                  value:
                  money(store.subtotal),
                ),
                _ReviewMoneyRow(
                  label: 'Service fee',
                  value:
                  money(store.serviceFee),
                ),
                _ReviewMoneyRow(
                  label: 'Delivery fee',
                  value:
                  money(store.deliveryFee),
                ),
                if (store.discount > 0)
                  _ReviewMoneyRow(
                    label: 'Discount',
                    value:
                    '-${money(store.discount)}',
                    valueColor:
                    AppColors.green,
                  ),
                const Padding(
                  padding:
                  EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Divider(
                    height: 1,
                    color: AppColors.border,
                  ),
                ),
                _ReviewMoneyRow(
                  label: 'Total',
                  value:
                  money(store.total),
                  emphasized: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                  isProcessing
                      ? null
                      : onBack,
                  style:
                  OutlinedButton.styleFrom(
                    foregroundColor:
                    AppColors.darkGreen,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Place order',
                  icon:
                  Icons.check_rounded,
                  isLoading:
                  isProcessing,
                  onPressed:
                  isProcessing
                      ? null
                      : onPlaceOrder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color:
                  AppColors.softGreen,
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                  AppColors.darkGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Text(
                title,
                style: const TextStyle(
                  color:
                  AppColors.darkGreen,
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ReviewDetail extends StatelessWidget {
  const _ReviewDetail({
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
        removeBottomPadding ? 0 : 12,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
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
                fontWeight:
                FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewMoneyRow extends StatelessWidget {
  const _ReviewMoneyRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: emphasized
                  ? AppColors.darkGreen
                  : AppColors.muted,
              fontSize:
              emphasized ? 16 : 13.5,
              fontWeight: emphasized
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ??
                  AppColors.darkGreen,
              fontSize:
              emphasized ? 17 : 13.5,
              fontWeight: emphasized
                  ? FontWeight.w700
                  : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.softGreen
          : Theme.of(context).cardColor,
      borderRadius:
      BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.green
                  : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : AppColors.softGreen,
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                  AppColors.darkGreen,
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
                      style: const TextStyle(
                        color: AppColors
                            .darkGreen,
                        fontSize: 14.5,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color:
                        AppColors.muted,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                selected
                    ? Icons
                    .radio_button_checked_rounded
                    : Icons
                    .radio_button_off_rounded,
                color: selected
                    ? AppColors.green
                    : AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.optional = false,
  });

  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 5),
          const Text(
            '(optional)',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class _PaymentOption {
  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}