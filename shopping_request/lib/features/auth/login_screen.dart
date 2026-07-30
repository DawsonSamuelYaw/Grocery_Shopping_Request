import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../navigation/main_shell.dart';
import '../../providers/grocery_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController(text: 'iddrissarazak@gmail.com');
  final password = TextEditingController(text: 'password');

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    context.read<GroceryStore>().login();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(38, 18, 38, 28),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Log in to keep your cart and orders in sync.',
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 26),
                const Text('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: email,
                  validator: (value) =>
                      value != null && value.contains('@')
                          ? null
                          : 'Enter a valid email address',
                  decoration: const InputDecoration(hintText: 'name@email.com'),
                ),
                const SizedBox(height: 16),
                const Text('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  validator: (value) =>
                      value != null && value.length >= 6
                          ? null
                          : 'Password must contain at least 6 characters',
                  decoration: const InputDecoration(hintText: '••••••••'),
                ),
                const SizedBox(height: 18),
                PrimaryButton(label: 'Log in', onPressed: submit),
                const Spacer(),
                const Center(
                  child: Text(
                    'New here? Create an account',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
