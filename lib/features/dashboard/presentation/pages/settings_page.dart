import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kreative_kindle/features/auth/presentation/pages/login_screen.dart';
import '../../../auth/presentation/view_model/auth_viewmodel.dart';
import '../../../../core/providers/theme_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _name = '';
  String _email = '';
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _name   = prefs.getString('user_name') ?? '';
      _email  = prefs.getString('user_email') ?? '';
      _userId = prefs.getString('user_id');
    });
  }

  Future<void> _showEditProfileDialog() async {
    final nameCtrl  = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final passCtrl  = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit_outlined, color: Color(0xFF8EC5FC)),
            SizedBox(width: 10),
            Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(controller: nameCtrl,  label: 'Display Name', icon: Icons.person_outline),
              const SizedBox(height: 12),
              _dialogField(controller: emailCtrl, label: 'Email Address', icon: Icons.email_outlined, keyboard: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _dialogField(controller: passCtrl,  label: 'New Password (leave blank to keep)', icon: Icons.lock_outline, obscure: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF8EC5FC),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              if (_userId == null) return;
              final ok = await ref.read(authViewModelProvider.notifier).updateProfile(
                userId: _userId!,
                username: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : null,
                email: emailCtrl.text.trim().isNotEmpty && emailCtrl.text.trim() != _email
                    ? emailCtrl.text.trim()
                    : null,
                password: passCtrl.text.isNotEmpty ? passCtrl.text : null,
              );
              if (ok) {
                final prefs = await SharedPreferences.getInstance();
                if (nameCtrl.text.trim().isNotEmpty) {
                  await prefs.setString('user_name', nameCtrl.text.trim());
                }
                if (!mounted) return;
                setState(() {
                  if (nameCtrl.text.trim().isNotEmpty) _name = nameCtrl.text.trim();
                  if (emailCtrl.text.trim().isNotEmpty && emailCtrl.text.trim() != _email) {
                    _email = emailCtrl.text.trim();
                  }
                });
                messenger.showSnackBar(const SnackBar(content: Text('Profile updated! ✅')));
              } else {
                final err = ref.read(authViewModelProvider).error ?? 'Update failed';
                messenger.showSnackBar(SnackBar(content: Text(err)));
              }
            },
            child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF8EC5FC)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8EC5FC), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  void _showInfoDialog(String title, IconData icon, String content) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: const Color(0xFF8EC5FC), size: 22),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17))),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(content, style: const TextStyle(height: 1.7, fontSize: 14)),
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF8EC5FC),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = ref.watch(themeProvider);
    final cardBg    = isDark ? const Color(0xFF1E2530) : Colors.white;
    final subColor  = isDark ? Colors.white54 : Colors.black54;
    final divColor  = isDark ? Colors.white10 : Colors.grey.shade100;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Account ──────────────────────────────────────
                  _label('Account', isDark),
                  const SizedBox(height: 8),
                  _card(cardBg, [
                    _row(
                      icon: Icons.person_outline,
                      iconBg: const Color(0xFFE8F4FF),
                      iconColor: const Color(0xFF3B9EFF),
                      title: 'Edit Profile',
                      subtitle: 'Name, email and password',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: true,
                      onTap: _showEditProfileDialog,
                    ),
                    _row(
                      icon: Icons.notifications_outlined,
                      iconBg: const Color(0xFFFFF3E0),
                      iconColor: const Color(0xFFFF9800),
                      title: 'Notifications',
                      subtitle: 'Coming in a future update',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: false,
                      onTap: () => _showInfoDialog(
                        'Notifications',
                        Icons.notifications_outlined,
                        'Push notification settings will be available in a future update. You\'ll be able to set reminders for daily activities and receive updates from the community.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Appearance ───────────────────────────────────
                  _label('Appearance', isDark),
                  const SizedBox(height: 8),
                  _card(cardBg, [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                              color: const Color(0xFF9C27B0),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87)),
                                Text(isDark ? 'Currently on' : 'Currently off', style: TextStyle(fontSize: 12, color: subColor)),
                              ],
                            ),
                          ),
                          Switch(
                            value: isDark,
                            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                            activeThumbColor: Colors.white,
                            activeTrackColor: const Color(0xFF8EC5FC),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: divColor, height: 1, indent: 72),
                    _row(
                      icon: Icons.language_outlined,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Language',
                      subtitle: 'English (more coming soon)',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: false,
                      onTap: () => _showInfoDialog(
                        'Language',
                        Icons.language_outlined,
                        'Currently, Kreative Kindle supports English only.\n\nAdditional language support — including Nepali — is planned for a future release. Stay tuned!',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Support ──────────────────────────────────────
                  _label('Support', isDark),
                  const SizedBox(height: 8),
                  _card(cardBg, [
                    _row(
                      icon: Icons.help_outline_rounded,
                      iconBg: const Color(0xFFE3F2FD),
                      iconColor: const Color(0xFF2196F3),
                      title: 'Help Center',
                      subtitle: 'FAQs and user guidance',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: true,
                      onTap: () => _showInfoDialog(
                        'Help Center',
                        Icons.help_outline_rounded,
                        'Frequently Asked Questions\n\n'
                        '❓ How do I add a child profile?\n'
                        'Go to Profile → Children → tap the + button to add a child.\n\n'
                        '❓ How do I mark an activity as complete?\n'
                        'Open any activity, scroll to the bottom, and tap "Mark Complete".\n\n'
                        '❓ How do I add activities to favourites?\n'
                        'Open any activity and tap "Add Favourite" at the bottom.\n\n'
                        '❓ How does the shake feature work?\n'
                        'On the Home screen, shake your phone to get a surprise activity suggestion!\n\n'
                        '❓ How do I reset my password?\n'
                        'On the Login screen, tap "Forgot Password?" and we\'ll email you a reset link.\n\n'
                        '❓ Why aren\'t images loading?\n'
                        'Make sure you\'re connected to the same WiFi network as the server.',
                      ),
                    ),
                    _row(
                      icon: Icons.privacy_tip_outlined,
                      iconBg: const Color(0xFFE8EAF6),
                      iconColor: const Color(0xFF3F51B5),
                      title: 'Privacy Policy',
                      subtitle: 'How we protect your data',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: true,
                      onTap: () => _showInfoDialog(
                        'Privacy Policy',
                        Icons.privacy_tip_outlined,
                        'Effective Date: 1 March 2026\n\n'
                        '1. INFORMATION WE COLLECT\n'
                        'We collect only what is necessary to provide the Kreative Kindle service:\n'
                        '• Account data: name, email address, and encrypted password.\n'
                        '• Child profiles: names and ages you voluntarily add.\n'
                        '• Usage data: activities completed and favourites saved.\n'
                        '• Media: profile photos you upload.\n\n'
                        '2. HOW WE USE YOUR DATA\n'
                        'Your data is used solely to personalise your Kreative Kindle experience. We do not sell, rent, or share your personal information with third parties.\n\n'
                        '3. DATA STORAGE & SECURITY\n'
                        'All data is stored securely in an encrypted database. Passwords are hashed using industry-standard bcrypt encryption and are never stored in plain text.\n\n'
                        '4. YOUR RIGHTS\n'
                        'You have the right to access, correct, or delete your personal data at any time. To request account deletion, contact us at privacy@kreativekindleapp.com.\n\n'
                        '5. CHILDREN\'S PRIVACY\n'
                        'We take children\'s privacy seriously. Child profiles contain only a name and age, which are visible only to the account holder.',
                      ),
                    ),
                    _row(
                      icon: Icons.article_outlined,
                      iconBg: const Color(0xFFFCE4EC),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Terms & Conditions',
                      subtitle: 'Rules for using this app',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: false,
                      onTap: () => _showInfoDialog(
                        'Terms & Conditions',
                        Icons.article_outlined,
                        'Effective Date: 1 March 2026\n\n'
                        'By downloading or using Kreative Kindle ("the App"), you agree to be bound by these Terms and Conditions. Please read them carefully.\n\n'
                        '1. ACCEPTANCE OF TERMS\n'
                        'Your access to and use of the App is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users, and others who access or use the App.\n\n'
                        '2. ELIGIBILITY\n'
                        'The App is intended for use by parents, guardians, and early childhood educators. Users must be at least 18 years of age to create an account.\n\n'
                        '3. USER ACCOUNTS\n'
                        'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorised use.\n\n'
                        '4. ACCEPTABLE USE\n'
                        'You agree not to post content that is offensive, harmful, or inappropriate for an early childhood platform. We reserve the right to remove any content that violates these guidelines without notice.\n\n'
                        '5. INTELLECTUAL PROPERTY\n'
                        'All content within the App — including activities, designs, text, and graphics — is the intellectual property of Kreative Kindle and is protected by applicable copyright law.\n\n'
                        '6. LIMITATION OF LIABILITY\n'
                        'Kreative Kindle is not liable for any injury, loss, or damage arising from the use of activities suggested within the App. All activities should be conducted under appropriate adult supervision.\n\n'
                        '7. CHANGES TO TERMS\n'
                        'We reserve the right to modify these Terms at any time. Continued use of the App after changes constitutes your acceptance of the new Terms.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── About ────────────────────────────────────────
                  _label('About', isDark),
                  const SizedBox(height: 8),
                  _card(cardBg, [
                    _row(
                      icon: Icons.info_outline_rounded,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF9C27B0),
                      title: 'App Version',
                      subtitle: 'Kreative Kindle v1.0.0',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: false,
                      onTap: () {},
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8EC5FC).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('v1.0.0', style: TextStyle(fontSize: 12, color: Color(0xFF8EC5FC), fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Logout ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      label: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 15)),
                      onPressed: () {
                        ref.read(authViewModelProvider.notifier).clearAuth();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Kreative Kindle • Made with ❤️ for early learners',
                      style: TextStyle(color: subColor, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
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

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                    Text('Manage your account & preferences', style: TextStyle(color: Colors.white70, fontSize: 13), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text, bool isDark) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 2),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? Colors.white38 : Colors.black38,
      ),
    ),
  );

  Widget _card(Color bg, List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(children: children),
  );

  Widget _row({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color subColor,
    required Color divColor,
    required bool showDiv,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: subColor)),
          trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
        ),
        if (showDiv) Divider(color: divColor, height: 1, indent: 72, endIndent: 16),
      ],
    );
  }
}
