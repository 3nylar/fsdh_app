import 'package:flutter/material.dart';

void main() {
  runApp(const CreateAccount());
}

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create an Account',
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {

  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'label': 'Coral High-Yield Corporate Note (CHCN)',
      'description':
      'Introducing the CGF: These are commercial papers backed by commodities and structured to provide financing for agricultural inputs',
    },
    {
      'label': 'Coral Commodity Backed Note (CCBN)',
      'description':
      'The Coral High-Yield Corporate Note involves commercial papers structured to invest in a leading telecommunications towers operator',
    },
    {
      'label': 'Coral Income Fund (CIF)',
      'description':
      'Introducing the CIF: These are the commercial papers backed by commodities and structured to provide financing for agricultural inputs.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the next screen here
    }
  }

  void _skip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _cancel() {}


  void _create() {}

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
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
                return _OnboardingImages(
                  image: 'assets/images/image.png',
                  onForward: _nextPage,
                  onSkip: _skip,
                  showIcon: _currentPage < _pages.length - 1,
                  onCancel: _cancel,
                  label: page['label']!,
                  description: page['description']!,
                  currentPage: _currentPage,
                  totalPages: _pages.length,
                  onPressed: _create,
                  lastPage: _currentPage == _pages.length - 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingImages extends StatelessWidget {
  final String image;
  final VoidCallback onForward;
  final VoidCallback onSkip;
  final bool showIcon;
  final VoidCallback onCancel;
  final String label;
  final String description;
  final int currentPage;
  final int totalPages;
  final VoidCallback onPressed;
  final bool lastPage;

  const _OnboardingImages({
    required this.image,
    required this.onForward,
    required this.onSkip,
    required this.showIcon,
    required this.onCancel,
    required this.label,
    required this.description,
    required this.currentPage,
    required this.totalPages,
    required this.onPressed,
    required this.lastPage
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned.fill(
            child:  Image.asset(
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
                    Color.fromRGBO(196, 196, 196, 0.0),
                    Color.fromRGBO(0, 73, 135, 1),
                  ],
                  stops: [
                    0.0,
                    0.8821,
                  ],
                ),
              ),
            ),
          ),
          if(showIcon)
            Positioned(
              top: 35,
              right: 15,
              child: GestureDetector(
                onTap: onForward,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 24,
                  color: Color(0xFF004987),
                ),
              ),
            ),
          Positioned(
            top: 35,
            left: 15,
            child: GestureDetector(
              onTap: lastPage ? onCancel : onSkip,
              child: lastPage ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon (
                  Icons.close_rounded,
                  color: Color(0xFF004987),
                  size: 25,
                ),
              ) : Container(
                padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
                decoration: BoxDecoration(
                  color: Color(0xFFE2F1F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF001526),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 40,
            right: 40,
            bottom: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFFFFF),
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  description,
                  style: TextStyle(
                    color: Color(0xFFF2F4F7),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 45),
                Container(
                  width: 380,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFFFFFFF),
                  ),
                  child: GestureDetector(
                    onTap: onPressed,
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            color: Color(0xFF001526),
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: _PageIndicator(
              currentPage: currentPage,
              totalPages: totalPages,
            ),
          ),
        ]
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
        padding: EdgeInsets.all(20),
        child: Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
                (index) {
              final isActive = index == currentPage;

              return isActive ? Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: Color(0xFFFFFFFF)
                      ),
                      shape: BoxShape.circle
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 7.03,
                    height:  6.84,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFFDADADA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
              ) : AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 7.03,
                height:  6.84,
                margin: const EdgeInsets.only(right: 6, left: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF336D9F),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        )
    );
  }
}

