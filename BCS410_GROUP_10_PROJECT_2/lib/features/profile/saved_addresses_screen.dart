import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() =>
      _SavedAddressesScreenState();
}

class _SavedAddressesScreenState
    extends State<SavedAddressesScreen> {
  final List<SavedAddress> _addresses = [
    const SavedAddress(
      id: 'home',
      label: 'Home',
      recipient: 'Abdul Razak Iddriss',
      phone: '+233 24 000 0000',
      address: 'Madina, Accra',
      landmark: 'Near Madina Market',
      isDefault: true,
    ),
    const SavedAddress(
      id: 'work',
      label: 'Work',
      recipient: 'Abdul Razak Iddriss',
      phone: '+233 24 000 0000',
      address: 'FASYL Technology Group, Accra',
      landmark: 'Main office reception',
      isDefault: false,
    ),
  ];

  Future<void> _showAddressForm({
    SavedAddress? address,
  }) async {
    final formKey = GlobalKey<FormState>();

    final labelController = TextEditingController(
      text: address?.label ?? '',
    );

    final recipientController = TextEditingController(
      text: address?.recipient ?? 'Abdul Razak Iddriss',
    );

    final phoneController = TextEditingController(
      text: address?.phone ?? '+233 ',
    );

    final addressController = TextEditingController(
      text: address?.address ?? '',
    );

    final landmarkController = TextEditingController(
      text: address?.landmark ?? '',
    );

    final result = await showModalBottomSheet<SavedAddress>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            8,
            22,
            MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address == null
                        ? 'Add delivery address'
                        : 'Edit delivery address',
                    style: const TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter the address where your groceries should be delivered.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: labelController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Address label',
                      hintText: 'Home, Work or School',
                      prefixIcon: Icon(Icons.label_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter an address label';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: recipientController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Recipient name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return 'Enter the recipient name';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      final digits = (value ?? '').replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      );

                      if (digits.length < 10) {
                        return 'Enter a valid phone number';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: addressController,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Delivery address',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 5) {
                        return 'Enter a complete delivery address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: landmarkController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Landmark',
                      prefixIcon: Icon(Icons.explore_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        Navigator.pop(
                          sheetContext,
                          SavedAddress(
                            id: address?.id ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            label: labelController.text.trim(),
                            recipient: recipientController.text.trim(),
                            phone: phoneController.text.trim(),
                            address: addressController.text.trim(),
                            landmark: landmarkController.text.trim(),
                            isDefault: address?.isDefault ?? false,
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        address == null
                            ? 'Save address'
                            : 'Save changes',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    labelController.dispose();
    recipientController.dispose();
    phoneController.dispose();
    addressController.dispose();
    landmarkController.dispose();

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (address == null) {
        _addresses.add(result);
      } else {
        final index = _addresses.indexWhere(
              (item) => item.id == address.id,
        );

        if (index != -1) {
          _addresses[index] = result;
        }
      }
    });
  }

  void _makeDefault(SavedAddress address) {
    setState(() {
      for (var index = 0; index < _addresses.length; index++) {
        final item = _addresses[index];

        _addresses[index] = item.copyWith(
          isDefault: item.id == address.id,
        );
      }
    });
  }

  Future<void> _deleteAddress(SavedAddress address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete address?'),
          content: Text(
            'Remove ${address.label} from your saved addresses?',
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _addresses.removeWhere(
            (item) => item.id == address.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved addresses'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddressForm,
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add address'),
      ),
      body: SafeArea(
        child: _addresses.isEmpty
            ? const _EmptyAddressState()
            : ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            100,
          ),
          itemCount: _addresses.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 14);
          },
          itemBuilder: (context, index) {
            final address = _addresses[index];

            return _AddressCard(
              address: address,
              onEdit: () {
                _showAddressForm(address: address);
              },
              onDelete: () {
                _deleteAddress(address);
              },
              onMakeDefault: () {
                _makeDefault(address);
              },
            );
          },
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onMakeDefault,
  });

  final SavedAddress address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMakeDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: address.isDefault
              ? AppColors.green
              : AppColors.border,
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  address.label.toLowerCase() == 'work'
                      ? Icons.business_outlined
                      : Icons.home_outlined,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  address.label,
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'default':
                      onMakeDefault();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (_) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit address'),
                    ),
                    if (!address.isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Text('Make default'),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete address'),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            address.recipient,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            address.phone,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            address.address,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          if (address.landmark.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              'Landmark: ${address.landmark}',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyAddressState extends StatelessWidget {
  const _EmptyAddressState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 70,
              color: AppColors.muted,
            ),
            SizedBox(height: 18),
            Text(
              'No saved addresses',
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add an address to make checkout faster.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.label,
    required this.recipient,
    required this.phone,
    required this.address,
    required this.landmark,
    required this.isDefault,
  });

  final String id;
  final String label;
  final String recipient;
  final String phone;
  final String address;
  final String landmark;
  final bool isDefault;

  SavedAddress copyWith({
    bool? isDefault,
  }) {
    return SavedAddress(
      id: id,
      label: label,
      recipient: recipient,
      phone: phone,
      address: address,
      landmark: landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}