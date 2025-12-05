import 'package:flutter/material.dart';
import '../../Parent/Dashboard/parent_dashboard.dart';
import '../../Role/user_role.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                if (UserRole.role == "parent") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ParentDashboard()),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
