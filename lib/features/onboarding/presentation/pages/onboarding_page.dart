import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_item.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/page_indicator.dart';
import '../../../../features/auth/presentation/pages/login_screen.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      imagePath: 'assets/images/onboarding1.png',
      title: '',
      description: 'Where imagination meets learning beautifully.',
    ),
    OnboardingItem(
      imagePath: 'assets/illustrations/Onboarding/middle.png',
      title: '',
      description:
          'KreativeKindle helps you discover age-appropriate, meaningful activities that spark imagination and support child development.',
    ),
    OnboardingItem(
      imagePath: 'assets/illustrations/Onboarding/page3.png',
      title: 'Engaging hands-on learning experience',
      description:
          'Dive into interactive lessons enriched with educational games and various creative activities.',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Page content
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return OnboardingContent(item: _items[index]);
              },
            ),

            // Skip button top right
            Positioned(
              top: 16,
              right: 20,
              child: TextButton(
                onPressed: _navigateToLogin,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xFF3EBBDB),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Bottom: dots + next button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  PageIndicator(
                    itemCount: _items.length,
                    currentPage: _currentPage,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3EBBDB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _nextPage,
                        child: Text(
                          _currentPage == _items.length - 1
                              ? 'Get Started 🚀'
                              : 'Next →',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
