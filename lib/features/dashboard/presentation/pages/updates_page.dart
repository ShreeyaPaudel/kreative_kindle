import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../features/auth/data/repositories/user_repository.dart';
import '../../../../features/media/presentation/view_model/media_viewmodel.dart';

final postsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final client = ref.read(apiClientProvider);
    final res = await client.get('/posts');
    final dynamic raw = res.data;
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    if (raw is Map) {
      final inner = raw['data'] ?? raw['posts'] ?? raw['result'] ?? [];
      if (inner is List) {
        return inner.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    }
    return [];
  } catch (e) {
    return [];
  }
});

class UpdatesPage extends ConsumerWidget {
  const UpdatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Updates 📢',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Latest posts and announcements',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PostUpdatePage()),
                  ).then((_) => ref.refresh(postsProvider)),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: postsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (posts) => posts.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('📭', style: TextStyle(fontSize: 48)),
                          SizedBox(height: 10),
                          Text('No posts yet — be the first!'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: posts.length,
                      itemBuilder: (context, i) => _PostCard(post: posts[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── POST CARD ────────────────────────────────────────────────────────────────
class _PostCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> post;
  const _PostCard({required this.post});

  @override
  ConsumerState<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<_PostCard> {
  String? _currentUserId;
  late bool _liked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    final likes = widget.post['likes'];
    _likeCount = likes is List ? likes.length : 0;
    _liked = false;
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final decoded = await ref.read(userRepositoryProvider).getLoggedInUser();
    final uid = decoded?['id']?.toString();
    if (!mounted) return;
    setState(() {
      _currentUserId = uid;
      final likes = widget.post['likes'];
      if (likes is List && uid != null) {
        _liked = likes.any((l) => l.toString() == uid);
      }
    });
  }

  Future<void> _toggleLike() async {
    final postId = widget.post['_id']?.toString() ?? '';
    if (postId.isEmpty) return;
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/posts/$postId/like');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _liked = !_liked;
        _likeCount += _liked ? 1 : -1;
      });
    }
  }

  Future<void> _deletePost() async {
    final postId = widget.post['_id']?.toString() ?? '';
    if (postId.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    try {
      final client = ref.read(apiClientProvider);
      await client.delete('/posts/$postId');
      ref.invalidate(postsProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final post = widget.post;
    final caption = post['caption']?.toString() ?? '';
    final rawImage = post['image']?.toString() ?? '';
    final imageUrl = rawImage.isNotEmpty && !rawImage.startsWith('http')
        ? '${ApiEndpoints.serverBase}/uploads/$rawImage'
        : rawImage;
    final userObj = post['userId'];
    // username may be stored directly on the post or inside a populated userId object
    final userName = post['username']?.toString() ??
        (userObj is Map
            ? (userObj['username'] ?? userObj['name'] ?? userObj['fullName'] ?? 'Parent').toString()
            : 'Parent');
    // userId may be a plain string (not populated) or a populated Map
    final postOwnerId = userObj is Map
        ? (userObj['_id'] ?? userObj['id'])?.toString()
        : userObj?.toString();
    final isOwnPost =
        _currentUserId != null && postOwnerId == _currentUserId;

    final materials = post['materials']?.toString() ?? '';
    final outcomes = post['learningOutcomes']?.toString() ?? '';
    final steps = post['steps']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF8EC5FC),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isOwnPost)
                GestureDetector(
                  onTap: _deletePost,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 20),
                  ),
                ),
            ],
          ),
          if (imageUrl.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 160,
                  child: Center(
                    child:
                        Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                ),
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        height: 160,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ),
            ),
          ],
          if (caption.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(caption, style: const TextStyle(fontSize: 14, height: 1.5)),
          ],
          if (materials.isNotEmpty) ...[
            const SizedBox(height: 8),
            _infoChip('📦 Materials', materials, isDark),
          ],
          if (outcomes.isNotEmpty) ...[
            const SizedBox(height: 6),
            _infoChip('🎯 Learning Outcomes', outcomes, isDark),
          ],
          if (steps.isNotEmpty) ...[
            const SizedBox(height: 6),
            _infoChip('📋 Steps', steps, isDark),
          ],
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _toggleLike,
            child: Row(
              children: [
                Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  color: _liked ? Colors.pinkAccent : Colors.black38,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '$_likeCount',
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Color(0xFF8EC5FC),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.black54),
        ),
      ],
    );
  }
}

// ─── POST UPDATE PAGE ─────────────────────────────────────────────────────────
class PostUpdatePage extends ConsumerStatefulWidget {
  const PostUpdatePage({super.key});

  @override
  ConsumerState<PostUpdatePage> createState() => _PostUpdatePageState();
}

class _PostUpdatePageState extends ConsumerState<PostUpdatePage> {
  final _captionController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (x == null) return;
    setState(() => _selectedImage = File(x.path));
  }

  Future<void> _submitPost() async {
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please write a caption!')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl;

      if (_selectedImage != null) {
        await ref.read(mediaViewModelProvider.notifier).upload(_selectedImage!);
        final mediaState = ref.read(mediaViewModelProvider);
        imageUrl = mediaState.imageUrl;
      }

      final client = ref.read(apiClientProvider);
      await client.post(
        '/posts',
        data: {
          'caption': _captionController.text.trim(),
          if (imageUrl != null) 'image': imageUrl,
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post shared! ✅')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Post Update 📝',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Share with the community',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              const Color(0xFF8EC5FC).withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 40,
                                  color: Color(0xFF8EC5FC),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add photo (optional)',
                                  style: TextStyle(color: isDark ? Colors.white38 : Colors.black45),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Caption *',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: TextField(
                      controller: _captionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'What\'s on your mind?',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isLoading ? null : _submitPost,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send, color: Colors.white),
                        label: Text(
                          _isLoading ? 'Posting...' : 'Share Post',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
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
