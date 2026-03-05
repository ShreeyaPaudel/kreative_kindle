import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../features/auth/data/repositories/user_repository.dart';
import '../../../../features/auth/presentation/view_model/auth_viewmodel.dart';
import '../../../../features/children/presentation/pages/children_page.dart';
import '../../../media/presentation/view_model/media_viewmodel.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final String role;
  const ProfilePage({super.key, required this.role});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? _userId;
  String _name = 'Parent';
  String _email = '';
  File? _selectedImage;
  String? _savedImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadSavedImage();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId    = prefs.getString('user_id');
    final storedEmail = prefs.getString('user_email');
    final storedName  = prefs.getString('user_name');

    // Also decode JWT to get id if SharedPreferences is empty
    final decoded = await ref.read(userRepositoryProvider).getLoggedInUser();
    final jwtId = decoded?['id']?.toString();

    if (!mounted) return;
    setState(() {
      _userId = storedId ?? jwtId;
      _email  = storedEmail ?? '';
      _name   = storedName ?? 'Parent';
    });
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('profile_image_url');
    if (saved != null && mounted) {
      setState(() => _savedImageUrl = saved);
    }
  }

  Future<void> _pickAndUpload() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x == null) return;
    setState(() => _selectedImage = File(x.path));
    await ref.read(mediaViewModelProvider.notifier).upload(File(x.path));
    final mediaState = ref.read(mediaViewModelProvider);

    if (mediaState.imageUrl != null) {
      final fullUrl = mediaState.imageUrl!.startsWith('http')
          ? mediaState.imageUrl!
          : 'http://192.168.1.115:3001/uploads/${mediaState.imageUrl!}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_url', fullUrl);
      if (mounted) setState(() => _savedImageUrl = fullUrl);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mediaState.error != null ? mediaState.error! : 'Profile photo updated! ✅')),
    );
  }

  Future<void> _showEditProfileDialog() async {
    final nameCtrl  = TextEditingController(text: _name == 'Parent' ? '' : _name);
    final emailCtrl = TextEditingController(text: _email);
    final passCtrl  = TextEditingController();

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'New Password (optional)'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              navigator.pop();
              if (_userId == null) return;

              final ok = await ref.read(authViewModelProvider.notifier).updateProfile(
                userId: _userId!,
                username: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : null,
                // Only send email if it actually changed — avoids E11000 duplicate key
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
                  if (emailCtrl.text.trim().isNotEmpty) _email = emailCtrl.text.trim();
                });
                messenger.showSnackBar(const SnackBar(content: Text('Profile updated! ✅')));
              } else {
                final err = ref.read(authViewModelProvider).error ?? 'Update failed';
                messenger.showSnackBar(SnackBar(content: Text(err)));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF);
    final subColor  = isDark ? Colors.white54 : Colors.black54;
    final mediaState = ref.watch(mediaViewModelProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              TextButton.icon(
                onPressed: _showEditProfileDialog,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickAndUpload,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : (_savedImageUrl ?? mediaState.imageUrl) != null
                                ? NetworkImage((_savedImageUrl ?? mediaState.imageUrl)!)
                                    as ImageProvider
                                : null,
                        child: (_selectedImage == null &&
                                _savedImageUrl == null &&
                                mediaState.imageUrl == null)
                            ? const Icon(Icons.person, size: 38, color: Colors.black45)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.role.isNotEmpty ? widget.role : 'Parent',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Children card — tap to manage
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChildrenPage()),
            ),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Children', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('Manage your children\'s profiles', style: TextStyle(color: subColor, fontSize: 13)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: subColor),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Account info
          _infoCard(
            title: "Account Info",
            rows: [
              ("Name", _name),
              ("Email", _email.isNotEmpty ? _email : '—'),
              ("Role", widget.role.isNotEmpty ? widget.role : 'Parent'),
            ],
            cardColor: cardColor,
            subColor: subColor,
          ),

          const SizedBox(height: 16),

          // Upload photo button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
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
                icon: mediaState.loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.camera_alt, color: Colors.white),
                label: Text(
                  mediaState.loading ? 'Uploading...' : 'Update Profile Photo',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                onPressed: mediaState.loading ? null : _pickAndUpload,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required List<(String, String)> rows,
    required Color cardColor,
    required Color subColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.$1, style: TextStyle(color: subColor)),
                  Text(r.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
