import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  int page = 0;

  final pages = const [
    (
    title: 'Fresh groceries,\nfaster than the\ncheckout queue.',
    subtitle:
    'Order fruit, veg and pantry staples\n'
        'from local stores, delivered today.',
    image: 'assets/images/onboarding/onboarding_1.png',
    ),
    (
    title: 'Everything you need,\nin one beautiful app.',
    subtitle:
    'Browse categories, save favourites\n'
        'and build your basket in seconds.',
    image: 'assets/images/onboarding/onboarding_2.png',
    ),
    (
    title: 'Simple checkout,\nfast delivery.',
    subtitle:
    'Choose a delivery time, payment method\n'
        'and track your order from your phone.',
    image: 'assets/images/onboarding/onboarding_3.png',
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void handlePrimaryButton() {
    if (page == pages.length - 1) {
      openLogin();
      return;
    }

    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, screenConstraints) {
            final screenHeight = screenConstraints.maxHeight;

            final imageHeight = (screenHeight * 0.50).clamp(
              250.0,
              500.0,
            );

            return PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (value) {
                if (!mounted) return;

                setState(() {
                  page = value;
                });
              },
              itemBuilder: (context, index) {
                final item = pages[index];

                return Column(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: _OnboardingImageSection(
                        imagePath: item.image,
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, contentConstraints) {
                          return SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: contentConstraints.maxHeight,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  40,
                                  30,
                                  40,
                                  20,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    _OnboardingTextContent(
                                      title: item.title,
                                      subtitle: item.subtitle,
                                    ),
                                    const SizedBox(height: 28),
                                    _OnboardingActions(
                                      currentPage: page,
                                      pageCount: pages.length,
                                      buttonLabel:
                                      page == pages.length - 1
                                          ? 'Get started'
                                          : 'Continue',
                                      onPrimaryPressed:
                                      handlePrimaryButton,
                                      onLoginPressed: openLogin,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingImageSection extends StatelessWidget {
  const _OnboardingImageSection({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkGreen,
      padding: const EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.softGreen,
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.darkGreen,
                size: 54,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingTextContent extends StatelessWidget {
  const _OnboardingTextContent({
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
            fontSize: 34,
            height: 1.18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _OnboardingActions extends StatelessWidget {
  const _OnboardingActions({
    required this.currentPage,
    required this.pageCount,
    required this.buttonLabel,
    required this.onPrimaryPressed,
    required this.onLoginPressed,
  });

  final int currentPage;
  final int pageCount;
  final String buttonLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            pageCount,
                (index) {
              final isSelected = index == currentPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: isSelected ? 24 : 10,
                height: 10,
                margin: const EdgeInsets.only(right: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.green
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: buttonLabel,
          onPressed: onPrimaryPressed,
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: onLoginPressed,
            child: const Text(
              'Already have an account? Log in',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}