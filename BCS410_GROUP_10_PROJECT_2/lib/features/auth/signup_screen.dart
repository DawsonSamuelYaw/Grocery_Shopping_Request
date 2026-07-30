import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../navigation/main_shell.dart';
import '../../providers/grocery_store.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _fullNameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _phoneController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Please accept the Terms and Privacy Policy.',
            ),
          ),
        );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) {
      return;
    }

    context.read<GroceryStore>().login();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainShell(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(
                22,
                18,
                22,
                30,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: AppColors.softGreen,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder:
                          const CircleBorder(),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Icon(
                              Icons
                                  .arrow_back_ios_new_rounded,
                              color: AppColors.darkGreen,
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      const _SignUpHeader(),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                          BorderRadius.circular(26),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.04,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const _FieldLabel(
                              label: 'Full name',
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller:
                              _fullNameController,
                              textCapitalization:
                              TextCapitalization.words,
                              textInputAction:
                              TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.name,
                              ],
                              validator: (value) {
                                final name =
                                    value?.trim() ?? '';

                                if (name.isEmpty) {
                                  return 'Enter your full name';
                                }

                                if (name.length < 3) {
                                  return 'Name is too short';
                                }

                                return null;
                              },
                              decoration:
                              const InputDecoration(
                                hintText:
                                'Enter your full name',
                                prefixIcon: Icon(
                                  Icons.person_outline_rounded,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            const _FieldLabel(
                              label: 'Email address',
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller:
                              _emailController,
                              keyboardType:
                              TextInputType.emailAddress,
                              textInputAction:
                              TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.email,
                              ],
                              validator: (value) {
                                final email =
                                    value?.trim() ?? '';

                                if (email.isEmpty) {
                                  return 'Enter your email address';
                                }

                                final validEmail = RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(email);

                                if (!validEmail) {
                                  return 'Enter a valid email address';
                                }

                                return null;
                              },
                              decoration:
                              const InputDecoration(
                                hintText: 'name@email.com',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            const _FieldLabel(
                              label: 'Phone number',
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller:
                              _phoneController,
                              keyboardType:
                              TextInputType.phone,
                              textInputAction:
                              TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.telephoneNumber,
                              ],
                              validator: (value) {
                                final phone =
                                    value?.trim() ?? '';

                                if (phone.isEmpty) {
                                  return 'Enter your phone number';
                                }

                                final digits = phone
                                    .replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                );

                                if (digits.length < 10) {
                                  return 'Enter a valid phone number';
                                }

                                return null;
                              },
                              decoration:
                              const InputDecoration(
                                hintText:
                                '024 000 0000',
                                prefixIcon: Icon(
                                  Icons.phone_outlined,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            const _FieldLabel(
                              label: 'Password',
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller:
                              _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction:
                              TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.newPassword,
                              ],
                              validator: (value) {
                                final password =
                                    value ?? '';

                                if (password.isEmpty) {
                                  return 'Create a password';
                                }

                                if (password.length < 8) {
                                  return 'Password must contain at least 8 characters';
                                }

                                if (!RegExp(r'[A-Z]')
                                    .hasMatch(password)) {
                                  return 'Include at least one uppercase letter';
                                }

                                if (!RegExp(r'[0-9]')
                                    .hasMatch(password)) {
                                  return 'Include at least one number';
                                }

                                return null;
                              },
                              decoration:
                              InputDecoration(
                                hintText:
                                'Create a strong password',
                                prefixIcon: const Icon(
                                  Icons
                                      .lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                      !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons
                                        .visibility_outlined
                                        : Icons
                                        .visibility_off_outlined,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            const _FieldLabel(
                              label: 'Confirm password',
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller:
                              _confirmPasswordController,
                              obscureText:
                              _obscureConfirmPassword,
                              textInputAction:
                              TextInputAction.done,
                              onFieldSubmitted: (_) {
                                _createAccount();
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Confirm your password';
                                }

                                if (value !=
                                    _passwordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                              decoration:
                              InputDecoration(
                                hintText:
                                'Repeat your password',
                                prefixIcon: const Icon(
                                  Icons
                                      .lock_reset_outlined,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons
                                        .visibility_outlined
                                        : Icons
                                        .visibility_off_outlined,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  activeColor:
                                  AppColors.green,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms =
                                          value ?? false;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(top: 11),
                                    child: Text(
                                      'I agree to the Terms of Service and Privacy Policy.',
                                      style: TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            PrimaryButton(
                              label: _isLoading
                                  ? 'Creating account...'
                                  : 'Create account',
                              onPressed: _isLoading
                                  ? null
                                  : _createAccount,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignUpHeader extends StatelessWidget {
  const _SignUpHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: AppColors.softGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_add_alt_1_outlined,
            color: AppColors.darkGreen,
            size: 28,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Create your account',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: 32,
            height: 1.15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Join us and start requesting groceries from stores near you.',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.darkGreen,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}