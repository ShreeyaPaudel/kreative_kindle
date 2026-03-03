import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../features/auth/data/repositories/user_repository.dart';
import '../../../media/presentation/view_model/media_viewmodel.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final String role;
  const ProfilePage({super.key, required this.role});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Map<String, dynamic>? _userData;
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
    final data = await ref.read(userRepositoryProvider).getLoggedInUser();
    setState(() => _userData = data);
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('profile_image_url');
    if (saved != null && mounted) {
      setState(() => _savedImageUrl = saved);
    }
  }

  Future<void> _pickAndUpload() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (x == null) return;
    setState(() => _selectedImage = File(x.path));
    await ref.read(mediaViewModelProvider.notifier).upload(File(x.path));
    final state = ref.read(mediaViewModelProvider);

    if (state.imageUrl != null) {
      // Ensure we store a full URL so it survives app restarts
      final fullUrl = state.imageUrl!.startsWith('http')
          ? state.imageUrl!
          : 'http://192.168.1.69:3001/uploads/${state.imageUrl!}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_url', fullUrl);
      if (mounted) setState(() => _savedImageUrl = fullUrl);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.error != null ? state.error! : 'Profile photo updated! ✅',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(mediaViewModelProvider);
    final name = _userData?['fullName'] ?? _userData?['name'] ?? 'Parent';
    final email = _userData?['email'] ?? '';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
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
                            ? NetworkImage(
                                    (_savedImageUrl ?? mediaState.imageUrl)!)
                                as ImageProvider
                            : null,
                        child: (_selectedImage == null &&
                                _savedImageUrl == null &&
                                mediaState.imageUrl == null)
                            ? const Icon(
                                Icons.person,
                                size: 38,
                                color: Colors.black45,
                              )
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
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.black54,
                          ),
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
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Parent',
                          style: TextStyle(
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

          // Child info card
          _infoCard(
            title: "Child Info",
            rows: const [
              ("Child", "Demo Child"),
              ("Age", "4 years"),
              ("Level", "Beginner"),
            ],
          ),

          const SizedBox(height: 16),

          // Account info
          _infoCard(
            title: "Account Info",
            rows: [("Name", name), ("Email", email), ("Role", "Parent")],
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
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.camera_alt, color: Colors.white),
                label: Text(
                  mediaState.loading ? 'Uploading...' : 'Update Profile Photo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.$1, style: const TextStyle(color: Colors.black54)),
                  Text(
                    r.$2,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
