import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  String? _formError;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final error = await auth.sendPasswordReset(email: _email.text);
    if (!mounted) return;
    setState(() {
      _formError = error;
      _sent = error == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                Text('Reset your password', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 6),
                Text(
                  "Enter the email on your account and we'll send a reset link.",
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
                const SizedBox(height: 20),
                if (_sent)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.leafLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Reset link sent. Check your inbox.',
                      style: TextStyle(color: AppColors.leafDark, fontWeight: FontWeight.w500),
                    ),
                  )
                else if (_formError != null)
                  Text(_formError!, style: const TextStyle(color: AppColors.tomato, fontSize: 13)),
                const SizedBox(height: 12),
                AppButton(label: 'Send reset link', onPressed: _submit, isLoading: isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
