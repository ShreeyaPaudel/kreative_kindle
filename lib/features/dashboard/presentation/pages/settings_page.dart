import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kreative_kindle/features/auth/presentation/pages/login_screen.dart';
import '../../../media/presentation/pages/upload_image.dart';
import '../../../auth/presentation/view_model/auth_viewmodel.dart';
import '../../../../core/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _sectionTitle("Account"),
                  const SizedBox(height: 10),
                  _settingsCard(
                    child: Column(
                      children: [
                        _tile(
                          context,
                          icon: Icons.person,
                          title: "Edit Profile",
                          subtitle: "Update name, photo, details",
                          onTap: () => _soon(context),
                        ),
                        _divider(context),
                        _tile(
                          context,
                          icon: Icons.lock_outline,
                          title: "Change Password",
                          subtitle: "Update your login password",
                          onTap: () => _soon(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  _sectionTitle("App"),
                  const SizedBox(height: 10),
                  _settingsCard(
                    child: Column(
                      children: [
                        // Theme toggle
                        ListTile(
                          onTap: () =>
                              ref.read(themeProvider.notifier).toggleTheme(),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4E8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: Colors.black87,
                            ),
                          ),
                          title: const Text(
                            "Theme",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(isDark ? "Dark mode" : "Light mode"),
                          trailing: Switch(
                            value: isDark,
                            onChanged: (_) =>
                                ref.read(themeProvider.notifier).toggleTheme(),
                            activeColor: const Color(0xFF8EC5FC),
                          ),
                        ),
                        _divider(context),
                        _tile(
                          context,
                          icon: Icons.notifications_none,
                          title: "Notifications",
                          subtitle: "Reminders and updates (later)",
                          onTap: () => _soon(context),
                        ),
                        _divider(context),
                        _tile(
                          context,
                          icon: Icons.image_outlined,
                          title: "Upload Image",
                          subtitle: "Send image to server",
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UploadImagePage(),
                            ),
                          ),
                        ),
                        _divider(context),
                        _tile(
                          context,
                          icon: Icons.language,
                          title: "Language",
                          subtitle: "English / Nepali (later)",
                          onTap: () => _soon(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  _sectionTitle("Support"),
                  const SizedBox(height: 10),
                  _settingsCard(
                    child: Column(
                      children: [
                        _tile(
                          context,
                          icon: Icons.help_outline,
                          title: "Help Center",
                          subtitle: "FAQs and guidance",
                          onTap: () => _soon(context),
                        ),
                        _divider(context),
                        _tile(
                          context,
                          icon: Icons.privacy_tip_outlined,
                          title: "Privacy Policy",
                          subtitle: "Read policy (later)",
                          onTap: () => _soon(context),
                        ),
                        _divider(context),
                        _tile(
                          context,
                          icon: Icons.description_outlined,
                          title: "Terms & Conditions",
                          subtitle: "Read terms (later)",
                          onTap: () => _soon(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFE8A3),
                            Color(0xFFFFCFA8),
                            Color(0xFFFFB88A),
                          ],
                        ),
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.black),
                        label: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          ref.read(authViewModelProvider.notifier).clearAuth();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text(
                    "Kreative Kindle • v1.0",
                    style: TextStyle(color: Colors.black45),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage your account and app preferences",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _settingsCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Divider(color: Colors.grey.shade200, height: 1),
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Coming soon 👀")));
  }
}
