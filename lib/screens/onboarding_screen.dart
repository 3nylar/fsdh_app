import 'package:flutter/material.dart';
import 'package:fsdh_app/screens/welcome_screen.dart';
import '../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = const [
    {
      'image': 'assets/images/onboarding_image1.png',
      'label': 'FSDH Dollar Fund (FDF)',
      'description':
      'This is an open-ended mutual fund authorized by the provisions of '
          'section 160 of the ISA, which invests in US Dollar denominated '
          'Fixed Income Securities issued by Nigerian Sovereign and '
          'Corporate Entities.',
    },
    {
      'image': 'assets/images/onboarding_image2.png',
      'label': 'Coral Balanced Fund (CBF)',
      'description':
      'This is an actively managed, open-ended unit trust scheme that '
          'invests a maximum of 65% in equities quoted on any Nigerian '
          'stock exchange and the balance in Fixed Income Securities.',
    },
    {
      'image': 'assets/images/onboarding_image3.png',
      'label': 'Coral Income Fund (CIF)',
      'description':
      'The CIF is an actively managed, open-ended, unit trust scheme '
          'that invests exclusively in Fixed Income Securities and Money '
          'Market instruments.',
    },
    {
      'image': 'assets/images/onboarding_image4.jpg',
      'label': 'Coral Money Market Fund (CMMF)',
      'description':
      'This is an actively managed, open-ended, unit trust scheme that '
          'invests exclusively in Money Market instruments with maturities '
          'less than 365 days.',
    },
    {
      'image': 'assets/images/onboarding_image5.png',
      'label': 'FSDH Halal Fund (CHF)',
      'description':
      "The Fund aims to provide investors with long-term income "
          "generation and stable cash distributions through exposure to "
          "Shari'ah-compliant fixed income securities, contracts and "
          "investment products.",
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
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
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            final page = _pages[index];
            return Column(
              children: [
                Expanded(
                  flex: 6,
                  child: _OnboardingHero(
                    image: page['image']!,
                    onBack: _previousPage,
                    onSkip: _skip,
                    showBack: _currentPage > 0,
                    showSkip: _currentPage < _pages.length - 1,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _PageDescription(
                    label: page['label']!,
                    description: page['description']!,
                    currentPage: _currentPage,
                    totalPages: _pages.length,
                    onPressed: _nextPage,
                    lastPage: _currentPage == _pages.length - 1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingHero extends StatelessWidget {
  final String image;
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final bool showBack;
  final bool showSkip;

  const _OnboardingHero({
    required this.image,
    required this.onBack,
    required this.onSkip,
    required this.showBack,
    required this.showSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 73, 135, 0.0),
                  Color.fromRGBO(0, 73, 135, 0.36),
                ],
                stops: [0.0, 0.8821],
              ),
            ),
          ),
        ),
        if (showSkip)
          Positioned(
            top: 35,
            right: 15,
            child: GestureDetector(
              onTap: onSkip,
              child: Row(
                children: const [
                  Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: AppColors.textPrimary
                  ),
                ],
              ),
            ),
          ),
        if (showBack)
          Positioned(
            top: 35,
            left: 15,
            child: GestureDetector(
              onTap: onBack,
              child: Row(
                children: const [
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: AppColors.textPrimary
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) {
            final isActive = index == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 20 : 15,
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.indicatorInactive,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }
        ),
      ),
    );
  }
}

class _PageDescription extends StatelessWidget {
  final String label;
  final String description;
  final int currentPage;
  final int totalPages;
  final VoidCallback onPressed;
  final bool lastPage;

  const _PageDescription({
    required this.label,
    required this.description,
    required this.currentPage,
    required this.totalPages,
    required this.onPressed,
    required this.lastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            _PageIndicator(
              currentPage: currentPage,
              totalPages: totalPages
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textFaint,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  lastPage ? 'Create Account' : 'Continue',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}