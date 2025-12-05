import 'package:flutter/material.dart';
import '../Parent_Instructor/Auth/signup_screen.dart';
import 'user_role.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  void goToSignup(BuildContext context) {
    UserRole.role = "parent";
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  Widget roleCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(width: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Your Role",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              roleCard(
                context: context,
                title: "Parent",
                icon: Icons.family_restroom,
                color: const Color(0xFF7ECFFF),
                onTap: () => goToSignup(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
