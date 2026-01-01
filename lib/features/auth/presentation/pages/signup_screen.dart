import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../screens/Parent/Dashboard/parent_dashboard.dart';
import '../../../../screens/Role/user_role.dart';
import '../view_model/auth_viewmodel.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    "assets/images/LoginRegister/blue_bg.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      "assets/images/LoginRegister/Group_8037.png",
                      height: 180,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserRole.role == "parent"
                          ? "Hi Parent!"
                          : "Hi Instructor!",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),
                    const Text(
                      "Sign Up Now!",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 25),

                    // FULL NAME
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Full name required" : null,
                    ),

                    const SizedBox(height: 14),

                    // EMAIL
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Email required";
                        if (!v.contains("@")) return "Enter valid email";
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // ADDRESS
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: "Address",
                        border: UnderlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? "Address required" : null,
                    ),

                    const SizedBox(height: 14),

                    // PASSWORD
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Password required";
                        if (v.length < 8) return "Min 8 characters";
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // CONFIRM PASSWORD
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (v) {
                        if (v != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // SIGNUP BUTTON
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .signup(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );

                            if (context.mounted && UserRole.role == "parent") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ParentDashboard(),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Sign Up"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LOGIN REDIRECT
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Already have an account? Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
