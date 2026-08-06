import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/labeled_text_field.dart';

final _emailRegex = RegExp(r'^[\w\.\-]+@([\w-]+\.)+[\w-]{2,4}$');

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _showErrorBanner = false;
  bool _passwordInvalid = false;
  FieldStatus _emailStatus = FieldStatus.none;

  String? _rememberedName;

  static const _demoPassword = 'password123';

  void _onEmailChanged(String value) {
    setState(() {
      _emailStatus =
      _emailRegex.hasMatch(value) ? FieldStatus.success : FieldStatus.none;
    });
  }

  void _attemptLogin() {
    final isCorrect = _passwordController.text == _demoPassword;
    setState(() {
      _showErrorBanner = !isCorrect;
      _passwordInvalid = !isCorrect;
    });
    if (isCorrect) {
      final name = _emailController.text.split('@').first;
      setState(() {
        _rememberedName =
        _rememberMe && name.isNotEmpty ? _capitalize(name) : 'there';
      });
    }
  }

  void _logout() {
    setState(() {
      _rememberedName = null;
      _passwordController.clear();
      _showErrorBanner = false;
      _passwordInvalid = false;
    });
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReturningUser = _rememberedName != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/logo.png'),
                        ],
                      ),
                    ),
                    if (_showErrorBanner) _buildErrorBanner(),
                    const SizedBox(height: 30),
                    _buildHeading(isReturningUser),
                    const SizedBox(height: 30),
                    _buildFields(isReturningUser),
                    if (!isReturningUser) ...[
                      const SizedBox(height: 15),
                      _buildRememberRow(),
                    ] else ...[
                      const SizedBox(height: 8),
                      _buildForgotPasswordOnly(),
                    ],
                    const SizedBox(height: 15),
                    _buildActionRow(),
                    if (isReturningUser) ...[
                      const SizedBox(height: 16),
                      _buildLogoutBanner(),
                    ],
                    const SizedBox(height: 30),
                    _buildSignUpFooter(),
                  ],
                ),
              ),
            ),
            _buildQuickNav(),
          ],
        ),
      ),
    );
  }
  

  Widget _buildErrorBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Invalid Credentials\nPlease try again!',
                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _showErrorBanner = false),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(bool isReturningUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isReturningUser ? 'Hi $_rememberedName,' : 'Log In.',
              style: AppTextStyles.heading),
          const SizedBox(height: 15),
          const Text(
            'Welcome, we are glad to see you back',
            style: AppTextStyles.subheading,
          ),
        ],
      ),
    );
  }

  Widget _buildFields(bool isReturningUser) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (!isReturningUser) ...[
            LabeledTextField(
              label: 'Email Address',
              controller: _emailController,
              status: _emailStatus,
              successText: 'Success',
              onChanged: _onEmailChanged,
            ),
            const SizedBox(height: 30),
          ],
          LabeledTextField(
            label: 'Password',
            controller: _passwordController,
            isPassword: true,
            status: _passwordInvalid ? FieldStatus.error : FieldStatus.none,
            errorText: 'Invalid password',
          ),
        ],
      ),
    );
  }

  Widget _buildRememberRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (newValue) =>
                      setState(() => _rememberMe = newValue ?? false),
                  side: const BorderSide(color: AppColors.border, width: 2),
                  checkColor: Colors.white,
                  activeColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Text('Remember me', style: AppTextStyles.body),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: AppColors.accent, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordOnly() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {},
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: AppColors.accent, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _attemptLogin,
              child: Container(
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 70,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: AppColors.accent),
              color: AppColors.accentBg,
            ),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.fingerprint,
                color: AppColors.accent,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Not $_rememberedName? ', style: AppTextStyles.body),
            GestureDetector(
              onTap: _logout,
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpFooter() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30),
      color: AppColors.surfaceMuted,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account yet? ", style: AppTextStyles.subheading),
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNav() {
    return Container(
      padding: const EdgeInsets.all(22),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _QuickNavItem(icon: Icons.home_filled, label: 'Quick Services'),
          _QuickNavItem(icon: Icons.headphones_rounded, label: 'Support'),
        ],
      ),
    );
  }
}

class _QuickNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickNavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 25),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}