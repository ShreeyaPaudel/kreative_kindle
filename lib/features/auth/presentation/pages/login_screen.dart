import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../view_model/auth_viewmodel.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;
  bool _googleLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardPage(role: 'parent'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOP IMAGE
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/LoginRegister/blue_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/LoginRegister/Group_8037.png',
                      height: 180,
                    ),
                  ),
                ),
              ],
            ),

            // FORM CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Login to continue',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 28),

                      // EMAIL
                      _inputField(
                        controller: emailController,
                        label: 'Email',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Email required'
                            : null,
                      ),

                      const SizedBox(height: 18),

                      // PASSWORD
                      _inputField(
                        controller: passwordController,
                        label: 'Password',
                        obscure: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Password required'
                            : null,
                      ),

                      // FORGOT PASSWORD
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF8EC5FC),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFE8A3),
                                Color(0xFFFFCFA8),
                                Color(0xFFFFB88A),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _loading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    setState(() => _loading = true);
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    final success = await ref
                                        .read(authViewModelProvider.notifier)
                                        .login(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        );
                                    if (!mounted) return;
                                    setState(() => _loading = false);
                                    if (success) {
                                      _goToDashboard();
                                    } else {
                                      final err =
                                          ref.read(authViewModelProvider).error;
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            err ?? 'Invalid email or password',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: _loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DIVIDER
                      _divider('OR'),

                      const SizedBox(height: 16),

                      // GOOGLE BUTTON
                      _googleButton(),

                      const SizedBox(height: 20),

                      // SIGNUP REDIRECT
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          ),
                          child: const Text(
                            "Don't have an account? Sign up",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(String label) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(color: Colors.black45, fontSize: 13),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          side: const BorderSide(color: Colors.black26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: _googleLoading
            ? null
            : () async {
                setState(() => _googleLoading = true);
                final messenger = ScaffoldMessenger.of(context);
                final success = await ref
                    .read(authViewModelProvider.notifier)
                    .loginWithGoogle();
                if (!mounted) return;
                setState(() => _googleLoading = false);
                if (success) {
                  _goToDashboard();
                } else {
                  final err = ref.read(authViewModelProvider).error;
                  if (err != null) {
                    messenger.showSnackBar(SnackBar(content: Text(err)));
                  }
                }
              },
        icon: _googleLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.g_mobiledata,
                size: 26,
                color: Color(0xFF4285F4),
              ),
        label: Text(
          _googleLoading ? 'Signing in...' : 'Continue with Google',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
