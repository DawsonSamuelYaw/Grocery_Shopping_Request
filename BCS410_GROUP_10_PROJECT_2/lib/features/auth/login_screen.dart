import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../navigation/main_shell.dart';
import '../../providers/grocery_store.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController(text: 'iddrissarazak@gmail.com');

  final TextEditingController _passwordController =
  TextEditingController(text: 'password');

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 700),
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

  void _openSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SignUpScreen(),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController(
      text: _emailController.text.trim(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your email address and we will send you password reset instructions.',
              ),
              const SizedBox(height: 18),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final email = emailController.text.trim();

                Navigator.pop(dialogContext);

                if (email.isEmpty) {
                  return;
                }

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password reset instructions sent to $email.',
                      ),
                    ),
                  );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Send link'),
            ),
          ],
        );
      },
    ).whenComplete(emailController.dispose);
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
                28,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 46,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            color: AppColors.softGreen,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder:
                              const CircleBorder(),
                              onTap: () {
                                Navigator.maybePop(context);
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
                        ),

                        const SizedBox(height: 28),

                        const _LoginHeader(),

                        const SizedBox(height: 30),

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
                              const Text(
                                'Email address',
                                style: TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _emailController,
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

                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller:
                                _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction:
                                TextInputAction.done,
                                autofillHints: const [
                                  AutofillHints.password,
                                ],
                                onFieldSubmitted: (_) {
                                  _submit();
                                },
                                validator: (value) {
                                  final password = value ?? '';

                                  if (password.isEmpty) {
                                    return 'Enter your password';
                                  }

                                  if (password.length < 6) {
                                    return 'Password must contain at least 6 characters';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                  ),
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? 'Show password'
                                        : 'Hide password',
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

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    activeColor:
                                    AppColors.green,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Remember me',
                                      style: TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                    _showForgotPasswordDialog,
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: AppColors.green,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              PrimaryButton(
                                label: _isLoading
                                    ? 'Signing in...'
                                    : 'Log in',
                                onPressed:
                                _isLoading ? null : _submit,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.border,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Text(
                                'New to the app?',
                                style: TextStyle(
                                  color: AppColors.muted
                                      .withValues(alpha: 0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: AppColors.border,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _openSignUp,
                            icon: const Icon(
                              Icons.person_add_alt_1_outlined,
                            ),
                            label: const Text(
                              'Create an account',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                              AppColors.darkGreen,
                              side: const BorderSide(
                                color: AppColors.green,
                              ),
                              padding:
                              const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        const SizedBox(height: 24),

                        const Center(
                          child: Text(
                            'By continuing, you agree to our Terms and Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

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
            Icons.shopping_basket_outlined,
            color: AppColors.darkGreen,
            size: 28,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Welcome back',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: 33,
            height: 1.15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue shopping and manage your grocery orders.',
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