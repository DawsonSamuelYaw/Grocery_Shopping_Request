import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() =>
      _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState
    extends State<PrivacySecurityScreen> {
  bool _biometricsEnabled = true;
  bool _loginAlertsEnabled = true;
  bool _orderPrivacyEnabled = false;

  Future<void> _changePassword() async {
    final formKey = GlobalKey<FormState>();

    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                      const Text(
                        'Change password',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: currentController,
                        obscureText: obscureCurrent,
                        decoration: InputDecoration(
                          labelText: 'Current password',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setSheetState(() {
                                obscureCurrent = !obscureCurrent;
                              });
                            },
                            icon: Icon(
                              obscureCurrent
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Enter your current password';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: newController,
                        obscureText: obscureNew,
                        decoration: InputDecoration(
                          labelText: 'New password',
                          prefixIcon: const Icon(
                            Icons.password_rounded,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setSheetState(() {
                                obscureNew = !obscureNew;
                              });
                            },
                            icon: Icon(
                              obscureNew
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final password = value ?? '';

                          if (password.length < 8) {
                            return 'Use at least 8 characters';
                          }

                          if (!RegExp(r'[A-Z]').hasMatch(password)) {
                            return 'Include an uppercase letter';
                          }

                          if (!RegExp(r'[0-9]').hasMatch(password)) {
                            return 'Include a number';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: confirmController,
                        obscureText: obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm new password',
                          prefixIcon: const Icon(
                            Icons.lock_reset_rounded,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setSheetState(() {
                                obscureConfirm = !obscureConfirm;
                              });
                            },
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value != newController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (!(formKey.currentState?.validate() ??
                                false)) {
                              return;
                            }

                            Navigator.pop(sheetContext, true);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                          child: const Text('Update password'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();

    if (changed == true && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully.'),
          ),
        );
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This action is permanent and cannot be undone.',
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
              child: const Text('Delete account'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account deletion request submitted.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and security'),
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
            const _SecurityOverviewCard(),
            const SizedBox(height: 24),
            const _SectionHeading(
              title: 'Account security',
              subtitle: 'Protect access to your grocery account.',
            ),
            const SizedBox(height: 13),
            _SecurityGroup(
              children: [
                _SecurityMenuTile(
                  icon: Icons.password_rounded,
                  title: 'Change password',
                  subtitle: 'Update your account password',
                  onTap: _changePassword,
                ),
                const Divider(
                  height: 1,
                  indent: 68,
                  color: AppColors.border,
                ),
                _SecuritySwitchTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric login',
                  subtitle: 'Use fingerprint or face recognition',
                  value: _biometricsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricsEnabled = value;
                    });
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 68,
                  color: AppColors.border,
                ),
                _SecuritySwitchTile(
                  icon: Icons.login_rounded,
                  title: 'Login alerts',
                  subtitle: 'Receive alerts for new account logins',
                  value: _loginAlertsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _loginAlertsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _SectionHeading(
              title: 'Privacy',
              subtitle: 'Control how your account information is used.',
            ),
            const SizedBox(height: 13),
            _SecurityGroup(
              children: [
                _SecuritySwitchTile(
                  icon: Icons.visibility_off_outlined,
                  title: 'Hide order history',
                  subtitle: 'Require authentication to view past orders',
                  value: _orderPrivacyEnabled,
                  onChanged: (value) {
                    setState(() {
                      _orderPrivacyEnabled = value;
                    });
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 68,
                  color: AppColors.border,
                ),
                _SecurityMenuTile(
                  icon: Icons.description_outlined,
                  title: 'Privacy policy',
                  subtitle: 'Read how your data is handled',
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName:
                      'Grocery Shopping Request',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: _deleteAccount,
              icon: const Icon(Icons.delete_forever_outlined),
              label: const Text('Delete account'),
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
          ],
        ),
      ),
    );
  }
}

class _SecurityOverviewCard extends StatelessWidget {
  const _SecurityOverviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.verified_user_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your account is protected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Security features are active on this device.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
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

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
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
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _SecurityGroup extends StatelessWidget {
  const _SecurityGroup({
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

class _SecurityMenuTile extends StatelessWidget {
  const _SecurityMenuTile({
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      onTap: onTap,
      leading: _SecurityIcon(icon: icon),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12.5,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
      ),
    );
  }
}

class _SecuritySwitchTile extends StatelessWidget {
  const _SecuritySwitchTile({
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
      secondary: _SecurityIcon(icon: icon),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.darkGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12.5,
        ),
      ),
      activeTrackColor: AppColors.green,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _SecurityIcon extends StatelessWidget {
  const _SecurityIcon({
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