import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/grocery_store.dart';
import '../auth/login_screen.dart';
import 'favourites_screen.dart';
import 'payment_methods_screen.dart';
import 'privacy_security_screen.dart';
import 'saved_addresses_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const int _activitiesPerPage = 4;

  String _name = 'Abdul Razak Iddriss';
  String _email = 'iddrissarazak@gmail.com';
  String _phone = '+233 24 000 0000';

  int _currentActivityPage = 0;

  final List<_ProfileActivity> _activities = const [
    _ProfileActivity(
      title: 'Order delivered',
      description: 'Order #GA10388 was delivered successfully.',
      date: 'Jul 21, 2026',
      icon: Icons.check_circle_outline_rounded,
      type: _ActivityType.success,
    ),
    _ProfileActivity(
      title: 'Address updated',
      description: 'Your Madina delivery address was updated.',
      date: 'Jul 18, 2026',
      icon: Icons.location_on_outlined,
      type: _ActivityType.information,
    ),
    _ProfileActivity(
      title: 'Payment method added',
      description: 'A new payment method was added to your account.',
      date: 'Jul 16, 2026',
      icon: Icons.credit_card_outlined,
      type: _ActivityType.information,
    ),
    _ProfileActivity(
      title: 'Item added to favourites',
      description: 'Fresh Bananas was added to your favourites.',
      date: 'Jul 14, 2026',
      icon: Icons.favorite_border_rounded,
      type: _ActivityType.favourite,
    ),
    _ProfileActivity(
      title: 'Order delivered',
      description: 'Order #GA10351 was delivered successfully.',
      date: 'Jul 14, 2026',
      icon: Icons.check_circle_outline_rounded,
      type: _ActivityType.success,
    ),
    _ProfileActivity(
      title: 'Password changed',
      description: 'Your account password was changed successfully.',
      date: 'Jul 10, 2026',
      icon: Icons.lock_outline_rounded,
      type: _ActivityType.information,
    ),
    _ProfileActivity(
      title: 'Order cancelled',
      description: 'Order #GA10244 was cancelled.',
      date: 'Jun 28, 2026',
      icon: Icons.cancel_outlined,
      type: _ActivityType.warning,
    ),
    _ProfileActivity(
      title: 'Profile created',
      description: 'Welcome to your grocery shopping account.',
      date: 'Jun 1, 2026',
      icon: Icons.person_outline_rounded,
      type: _ActivityType.information,
    ),
  ];

  String get _initials {
    final nameParts = _name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (nameParts.isEmpty) {
      return 'U';
    }

    if (nameParts.length == 1) {
      return nameParts.first.characters.first.toUpperCase();
    }

    final firstInitial = nameParts.first.characters.first;
    final lastInitial = nameParts.last.characters.first;

    return '$firstInitial$lastInitial'.toUpperCase();
  }

  Future<void> _openScreen(Widget screen) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => screen,
      ),
    );
  }

  void _changeActivityPage({
    required int page,
    required int totalPages,
  }) {
    if (page < 0 || page >= totalPages) {
      return;
    }

    setState(() {
      _currentActivityPage = page;
    });
  }

  Future<void> _showEditProfileSheet() async {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(
      text: _name,
    );

    final emailController = TextEditingController(
      text: _email,
    );

    final phoneController = TextEditingController(
      text: _phone,
    );

    final updatedProfile = await showModalBottomSheet<_UpdatedProfile>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            4,
            22,
            MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit profile',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Update your personal account information.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [
                      AutofillHints.name,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                      ),
                    ),
                    validator: (value) {
                      final name = value?.trim() ?? '';

                      if (name.isEmpty) {
                        return 'Enter your full name';
                      }

                      if (name.length < 3) {
                        return 'Enter a valid full name';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [
                      AutofillHints.email,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';

                      if (email.isEmpty) {
                        return 'Enter your email address';
                      }

                      final isValidEmail = RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email);

                      if (!isValidEmail) {
                        return 'Enter a valid email address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [
                      AutofillHints.telephoneNumber,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                      ),
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        FocusScope.of(sheetContext).unfocus();

                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        Navigator.pop(
                          sheetContext,
                          _UpdatedProfile(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.check_rounded,
                      ),
                      label: const Text(
                        'Save changes',
                      ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    if (!mounted || updatedProfile == null) {
      return;
    }

    setState(() {
      _name = updatedProfile.name;
      _email = updatedProfile.email;
      _phone = updatedProfile.phone;
    });

    _showMessage(
      message: 'Profile updated successfully.',
    );
  }

  Future<void> _confirmLogout(
      GroceryStore store,
      ) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.logout_rounded,
            color: AppColors.red,
          ),
          title: const Text(
            'Log out?',
          ),
          content: const Text(
            'You will need to sign in again to access your account.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(
                Icons.logout_rounded,
                size: 18,
              ),
              label: const Text(
                'Log out',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldLogout != true) {
      return;
    }

    store.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  void _showMessage({
    required String message,
    bool isError = false,
  }) {
    if (!mounted) {
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    final totalPages = math.max(
      1,
      (_activities.length / _activitiesPerPage).ceil(),
    );

    final safeCurrentPage = _currentActivityPage
        .clamp(
      0,
      totalPages - 1,
    )
        .toInt();

    final startIndex = safeCurrentPage * _activitiesPerPage;

    final endIndex = math.min(
      startIndex + _activitiesPerPage,
      _activities.length,
    );

    final visibleActivities = _activities.sublist(
      startIndex,
      endIndex,
    );

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
          constraints.maxWidth >= 700 ? 40.0 : 20.0;

          final maxContentWidth =
          constraints.maxWidth >= 900 ? 820.0 : double.infinity;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: ListView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  34,
                ),
                children: [
                  const _ProfilePageHeader(),
                  const SizedBox(height: 24),

                  _ProfileOverviewCard(
                    initials: _initials,
                    name: _name,
                    email: _email,
                    phone: _phone,
                    onEdit: _showEditProfileSheet,
                  ),

                  const SizedBox(height: 28),

                  const _SectionTitle(
                    title: 'Account',
                    subtitle:
                    'Manage your account information, addresses and payments.',
                  ),

                  const SizedBox(height: 14),

                  _SettingsGroup(
                    children: [
                      _ProfileMenuTile(
                        icon: Icons.location_on_outlined,
                        title: 'Saved addresses',
                        subtitle: 'Manage your delivery locations',
                        onTap: () {
                          _openScreen(
                            const SavedAddressesScreen(),
                          );
                        },
                      ),
                      const _SettingsDivider(),
                      _ProfileMenuTile(
                        icon: Icons.credit_card_outlined,
                        title: 'Payment methods',
                        subtitle: 'Cards and mobile money accounts',
                        onTap: () {
                          _openScreen(
                            const PaymentMethodsScreen(),
                          );
                        },
                      ),
                      const _SettingsDivider(),
                      _ProfileMenuTile(
                        icon: Icons.favorite_border_rounded,
                        title: 'Favourites',
                        subtitle: store.favouriteCount == 1
                            ? '1 saved product'
                            : '${store.favouriteCount} saved products',
                        trailingBadge: store.favouriteCount > 0
                            ? store.favouriteCount.toString()
                            : null,
                        onTap: () {
                          _openScreen(
                            const FavouritesScreen(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const _SectionTitle(
                    title: 'Preferences',
                    subtitle:
                    'Control how the application looks and communicates with you.',
                  ),

                  const SizedBox(height: 14),

                  _SettingsGroup(
                    children: [
                      _ProfileSwitchTile(
                        icon: store.darkMode
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        title: 'Dark mode',
                        subtitle: store.darkMode
                            ? 'Dark appearance is enabled'
                            : 'Light appearance is enabled',
                        value: store.darkMode,
                        onChanged: store.toggleDarkMode,
                      ),
                      const _SettingsDivider(),
                      _ProfileMenuTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: 'Manage alerts and order updates',
                        onTap: () {
                          _openScreen(
                            const _NotificationPreferencesScreen(),
                          );
                        },
                      ),
                      const _SettingsDivider(),
                      _ProfileMenuTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Privacy and security',
                        subtitle: 'Password, login and account security',
                        onTap: () {
                          _openScreen(
                            const PrivacySecurityScreen(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _ActivityHeader(
                    startIndex:
                    _activities.isEmpty ? 0 : startIndex + 1,
                    endIndex: endIndex,
                    totalActivities: _activities.length,
                  ),

                  const SizedBox(height: 14),

                  if (visibleActivities.isEmpty)
                    const _EmptyActivityState()
                  else
                    ...visibleActivities.map(
                          (activity) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: _ActivityCard(
                            activity: activity,
                          ),
                        );
                      },
                    ),

                  if (totalPages > 1) ...[
                    const SizedBox(height: 10),
                    _PaginationControls(
                      currentPage: safeCurrentPage,
                      totalPages: totalPages,
                      onPageSelected: (page) {
                        _changeActivityPage(
                          page: page,
                          totalPages: totalPages,
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 32),

                  OutlinedButton.icon(
                    onPressed: () {
                      _confirmLogout(store);
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                    ),
                    label: const Text(
                      'Log out',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red,
                      side: const BorderSide(
                        color: AppColors.red,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Center(
                    child: Text(
                      'Grocery Shopping Request · Version 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfilePageHeader extends StatelessWidget {
  const _ProfilePageHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 29,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Manage your personal account.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.softGreen,
          child: Icon(
            Icons.person_outline_rounded,
            color: AppColors.darkGreen,
          ),
        ),
      ],
    );
  }
}

class _ProfileOverviewCard extends StatelessWidget {
  const _ProfileOverviewCard({
    required this.initials,
    required this.name,
    required this.email,
    required this.phone,
    required this.onEdit,
  });

  final String initials;
  final String name;
  final String email;
  final String phone;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(
              alpha: 0.16,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.25,
                    ),
                    width: 2,
                  ),
                ),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    _ProfileInformationLine(
                      icon: Icons.email_outlined,
                      value: email,
                    ),
                    const SizedBox(height: 6),
                    _ProfileInformationLine(
                      icon: Icons.phone_outlined,
                      value: phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 19,
              ),
              label: const Text(
                'Edit profile',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInformationLine extends StatelessWidget {
  const _ProfileInformationLine({
    required this.icon,
    required this.value,
  });

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 15,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 68,
      endIndent: 18,
      color: AppColors.border,
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingBadge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailingBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _MenuIcon(
              icon: icon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingBadge != null) ...[
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(
                  minWidth: 26,
                  minHeight: 26,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.softGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trailingBadge!,
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 7),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSwitchTile extends StatelessWidget {
  const _ProfileSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _MenuIcon(
            icon: icon,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.green,
          ),
        ],
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  const _MenuIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.softGreen,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: AppColors.darkGreen,
        size: 21,
      ),
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({
    required this.startIndex,
    required this.endIndex,
    required this.totalActivities,
  });

  final int startIndex;
  final int endIndex;
  final int totalActivities;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Recent activity',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          totalActivities == 0
              ? 'No activity'
              : '$startIndex–$endIndex of $totalActivities',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
  });

  final _ProfileActivity activity;

  @override
  Widget build(BuildContext context) {
    final appearance = activity.type.appearance;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: appearance.backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              activity.icon,
              color: appearance.foregroundColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  activity.date,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivityState extends StatelessWidget {
  const _EmptyActivityState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 34,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.history_rounded,
            color: AppColors.muted,
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'No recent activity',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PaginationArrow(
          icon: Icons.chevron_left_rounded,
          enabled: currentPage > 0,
          onPressed: () {
            onPageSelected(currentPage - 1);
          },
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 7,
            runSpacing: 7,
            children: List.generate(
              totalPages,
                  (page) {
                final selected = page == currentPage;

                return Material(
                  color: selected
                      ? AppColors.green
                      : AppColors.softGreen,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      onPageSelected(page);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Center(
                        child: Text(
                          '${page + 1}',
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        _PaginationArrow(
          icon: Icons.chevron_right_rounded,
          enabled: currentPage < totalPages - 1,
          onPressed: () {
            onPageSelected(currentPage + 1);
          },
        ),
      ],
    );
  }
}

class _PaginationArrow extends StatelessWidget {
  const _PaginationArrow({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: const Size(40, 40),
        backgroundColor: enabled
            ? AppColors.softGreen
            : AppColors.border.withValues(
          alpha: 0.4,
        ),
        foregroundColor: enabled
            ? AppColors.darkGreen
            : AppColors.muted.withValues(
          alpha: 0.5,
        ),
      ),
    );
  }
}

class _NotificationPreferencesScreen extends StatefulWidget {
  const _NotificationPreferencesScreen();

  @override
  State<_NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<_NotificationPreferencesScreen> {
  bool _orderUpdates = true;
  bool _deliveryUpdates = true;
  bool _promotions = false;
  bool _newProducts = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  void _showSavedMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Notification preferences saved.',
          ),
          backgroundColor: AppColors.green,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            32,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.notifications_active_outlined,
                      color: AppColors.green,
                    ),
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      'Choose the updates you want to receive from the grocery application.',
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
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Order notifications',
              subtitle:
              'Updates about purchases and deliveries.',
            ),
            const SizedBox(height: 13),
            _SettingsGroup(
              children: [
                _NotificationSwitchTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Order updates',
                  subtitle:
                  'Order confirmation and preparation updates',
                  value: _orderUpdates,
                  onChanged: (value) {
                    setState(() {
                      _orderUpdates = value;
                    });
                  },
                ),
                const _SettingsDivider(),
                _NotificationSwitchTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Delivery updates',
                  subtitle:
                  'Receive driver and delivery status alerts',
                  value: _deliveryUpdates,
                  onChanged: (value) {
                    setState(() {
                      _deliveryUpdates = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Marketing',
              subtitle:
              'Control promotional and product notifications.',
            ),
            const SizedBox(height: 13),
            _SettingsGroup(
              children: [
                _NotificationSwitchTile(
                  icon: Icons.local_offer_outlined,
                  title: 'Promotions and discounts',
                  subtitle:
                  'Receive deals, offers and promo codes',
                  value: _promotions,
                  onChanged: (value) {
                    setState(() {
                      _promotions = value;
                    });
                  },
                ),
                const _SettingsDivider(),
                _NotificationSwitchTile(
                  icon: Icons.new_releases_outlined,
                  title: 'New products',
                  subtitle:
                  'Be informed when new grocery items arrive',
                  value: _newProducts,
                  onChanged: (value) {
                    setState(() {
                      _newProducts = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(
              title: 'Delivery channels',
              subtitle:
              'Choose how notifications should reach you.',
            ),
            const SizedBox(height: 13),
            _SettingsGroup(
              children: [
                _NotificationSwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Push notifications',
                  subtitle:
                  'Receive alerts directly on this device',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
                const _SettingsDivider(),
                _NotificationSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Email notifications',
                  subtitle:
                  'Receive updates through your email address',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _showSavedMessage,
                icon: const Icon(
                  Icons.check_rounded,
                ),
                label: const Text(
                  'Save preferences',
                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  const _NotificationSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      secondary: _MenuIcon(
        icon: icon,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12.5,
          height: 1.35,
        ),
      ),
      activeTrackColor: AppColors.green,
      value: value,
      onChanged: onChanged,
    );
  }
}

enum _ActivityType {
  information,
  success,
  favourite,
  warning,
}

extension _ActivityTypeAppearanceExtension on _ActivityType {
  _ActivityAppearance get appearance {
    switch (this) {
      case _ActivityType.information:
        return const _ActivityAppearance(
          foregroundColor: AppColors.darkGreen,
          backgroundColor: AppColors.softGreen,
        );

      case _ActivityType.success:
        return const _ActivityAppearance(
          foregroundColor: AppColors.green,
          backgroundColor: AppColors.softGreen,
        );

      case _ActivityType.favourite:
        return const _ActivityAppearance(
          foregroundColor: AppColors.red,
          backgroundColor: Color(0xFFFFE9E7),
        );

      case _ActivityType.warning:
        return const _ActivityAppearance(
          foregroundColor: Color(0xFFB26A00),
          backgroundColor: Color(0xFFFFF1D7),
        );
    }
  }
}

class _ActivityAppearance {
  const _ActivityAppearance({
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final Color foregroundColor;
  final Color backgroundColor;
}

class _ProfileActivity {
  const _ProfileActivity({
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.type,
  });

  final String title;
  final String description;
  final String date;
  final IconData icon;
  final _ActivityType type;
}

class _UpdatedProfile {
  const _UpdatedProfile({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;
}