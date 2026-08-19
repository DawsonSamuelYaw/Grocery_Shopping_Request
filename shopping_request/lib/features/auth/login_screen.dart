import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _formError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final error = await auth.login(email: _email.text, password: _password.text);
    if (!mounted) return;
    if (error != null) {
      setState(() => _formError = error);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                IconButton(
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
                const SizedBox(height: 12),
                Text('Welcome back', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 6),
                Text(
                  'Log in to keep your cart and orders in sync.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Email',
                  controller: _email,
                  hint: 'name@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter your email.' : null,
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Password',
                  controller: _password,
                  obscure: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter your password.' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text('Forgot password?', style: TextStyle(color: AppColors.leafDark)),
                  ),
                ),
                if (_formError != null) ...[
                  Text(_formError!, style: const TextStyle(color: AppColors.tomato, fontSize: 13)),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 8),
                AppButton(label: 'Log in', onPressed: _submit, isLoading: isLoading),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New here?", style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: const Text('Create an account', style: TextStyle(color: AppColors.leafDark)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
