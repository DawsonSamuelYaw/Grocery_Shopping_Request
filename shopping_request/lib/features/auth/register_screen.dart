import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _formError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final error = await auth.register(name: _name.text, email: _email.text, password: _password.text);
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
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                ),
                const SizedBox(height: 12),
                Text('Create an account', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 6),
                Text(
                  'Save your delivery details and reorder in one tap.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Full name',
                  controller: _name,
                  hint: 'Ama Kufuor',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter your full name.' : null,
                ),
                const SizedBox(height: 18),
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
                  validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters.' : null,
                ),
                const SizedBox(height: 20),
                if (_formError != null) ...[
                  Text(_formError!, style: const TextStyle(color: AppColors.tomato, fontSize: 13)),
                  const SizedBox(height: 8),
                ],
                AppButton(label: 'Create account', onPressed: _submit, isLoading: isLoading),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?', style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Log in', style: TextStyle(color: AppColors.leafDark)),
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
