import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/grocery_store.dart';
import '../auth/login_screen.dart';

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
      description: 'A new card was added to your account.',
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
    final parts = _name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  void _changeActivityPage(int page, int totalPages) {
    if (page < 0 || page >= totalPages) {
      return;
    }

    setState(() {
      _currentActivityPage = page;
    });
  }

  Future<void> _showEditProfileSheet() async {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);

    final formKey = GlobalKey<FormState>();

    final updatedProfile = await showModalBottomSheet<_UpdatedProfile>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit profile',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Update your personal account information.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your full name';
                      }

                      if (value.trim().length < 3) {
                        return 'Name is too short';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';

                      if (email.isEmpty) {
                        return 'Enter your email address';
                      }

                      final isValid = RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email);

                      if (!isValid) {
                        return 'Enter a valid email address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your phone number';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
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
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Save changes'),
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

    if (updatedProfile == null || !mounted) {
      return;
    }

    setState(() {
      _name = updatedProfile.name;
      _email = updatedProfile.email;
      _phone = updatedProfile.phone;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
        ),
      );
  }

  Future<void> _confirmLogout(GroceryStore store) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'You will need to sign in again to access your account.',
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
                foregroundColor: Colors.white,
              ),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !mounted) {
      return;
    }

    store.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  void _openSection({
    required String title,
    required IconData icon,
    required String message,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ProfileSectionScreen(
          title: title,
          icon: icon,
          message: message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();

    final totalPages =
    (_activities.length / _activitiesPerPage).ceil();

    final int safeCurrentPage = _currentActivityPage
        .clamp(
      0,
      math.max(0, totalPages - 1),
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

          return ListView(
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

              const SizedBox(height: 26),

              const _SectionTitle(
                title: 'Account',
                subtitle: 'Manage your account information and preferences.',
              ),

              const SizedBox(height: 14),

              _SettingsGroup(
                children: [
                  _ProfileMenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved addresses',
                    subtitle: 'Manage delivery locations',
                    onTap: () {
                      _openSection(
                        title: 'Saved addresses',
                        icon: Icons.location_on_outlined,
                        message:
                        'Your saved delivery addresses will appear here.',
                      );
                    },
                  ),
                  const _SettingsDivider(),
                  _ProfileMenuTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment methods',
                    subtitle: 'Cards and mobile money accounts',
                    onTap: () {
                      _openSection(
                        title: 'Payment methods',
                        icon: Icons.credit_card_outlined,
                        message:
                        'Your saved payment methods will appear here.',
                      );
                    },
                  ),
                  const _SettingsDivider(),
                  _ProfileMenuTile(
                    icon: Icons.favorite_border_rounded,
                    title: 'Favourites',
                    subtitle: 'Products you have saved',
                    onTap: () {
                      _openSection(
                        title: 'Favourites',
                        icon: Icons.favorite_border_rounded,
                        message:
                        'Your favourite products will appear here.',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 26),

              const _SectionTitle(
                title: 'Preferences',
                subtitle: 'Control how the application behaves.',
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
                      _openSection(
                        title: 'Notifications',
                        icon: Icons.notifications_none_rounded,
                        message:
                        'Your notification preferences will appear here.',
                      );
                    },
                  ),
                  const _SettingsDivider(),
                  _ProfileMenuTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacy and security',
                    subtitle: 'Password and account security',
                    onTap: () {
                      _openSection(
                        title: 'Privacy and security',
                        icon: Icons.lock_outline_rounded,
                        message:
                        'Your privacy and security options will appear here.',
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _ActivityHeader(
                startIndex: startIndex + 1,
                endIndex: endIndex,
                totalActivities: _activities.length,
              ),

              const SizedBox(height: 14),

              ...visibleActivities.map(
                    (activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ActivityCard(activity: activity),
                ),
              ),

              if (totalPages > 1) ...[
                const SizedBox(height: 12),
                _PaginationControls(
                  currentPage: safeCurrentPage,
                  totalPages: totalPages,
                  onPageSelected: (page) {
                    _changeActivityPage(page, totalPages);
                  },
                ),
              ],

              const SizedBox(height: 30),

              OutlinedButton.icon(
                onPressed: () {
                  _confirmLogout(store);
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

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
            color: AppColors.darkGreen.withValues(alpha: 0.16),
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
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
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
                    const SizedBox(height: 6),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
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
              icon: const Icon(Icons.edit_outlined, size: 19),
              label: const Text('Edit profile'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(vertical: 13),
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
            fontWeight: FontWeight.w600,
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _MenuIcon(icon: icon),
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
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted,
              ),
            ],
          ),
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
          _MenuIcon(icon: icon),
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$startIndex–$endIndex of $totalActivities',
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
        border: Border.all(color: AppColors.border),
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
    final pages = List.generate(totalPages, (index) => index);

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
            children: pages.map((page) {
              final selected = page == currentPage;

              return Material(
                color: selected
                    ? AppColors.green
                    : AppColors.softGreen,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    onPageSelected(page);
                  },
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
            }).toList(),
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
            : AppColors.border.withValues(alpha: 0.4),
        foregroundColor: enabled
            ? AppColors.darkGreen
            : AppColors.muted.withValues(alpha: 0.5),
      ),
    );
  }
}

class _ProfileSectionScreen extends StatelessWidget {
  const _ProfileSectionScreen({
    required this.title,
    required this.icon,
    required this.message,
  });

  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: const BoxDecoration(
                  color: AppColors.softGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.darkGreen,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ActivityType {
  information,
  success,
  favourite,
  warning,
}

extension on _ActivityType {
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