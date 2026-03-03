import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:kreative_kindle/features/activities/presentation/pages/activities_page.dart';
import 'package:kreative_kindle/features/activities/presentation/pages/activity_detail_page.dart';
import '../widgets/feature_tile.dart';
import './profile_page.dart';
import './settings_page.dart';
import './updates_page.dart';
import './progress_page.dart';
import './more_page.dart';
import '../../../../core/widgets/offline_banner.dart';

class DashboardPage extends ConsumerStatefulWidget {
  final String role;
  const DashboardPage({super.key, required this.role});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int index = 2;
  StreamSubscription<AccelerometerEvent>? _shakeSub;
  DateTime _lastShake = DateTime.now();

  bool get isParent => widget.role.toLowerCase() == "parent";

  static const _shakeActivities = [
    {
      'title': 'Rainbow Paper Craft',
      'emoji': '🌈',
      'category': 'Craft Corner',
      'duration': '10 mins',
    },
    {
      'title': 'Shape Sorting Game',
      'emoji': '🔷',
      'category': 'Thinking Skills',
      'duration': '15 mins',
    },
    {
      'title': 'Finger Painting',
      'emoji': '🎨',
      'category': 'Craft Corner',
      'duration': '20 mins',
    },
    {
      'title': 'Story Building',
      'emoji': '📖',
      'category': 'Story Time',
      'duration': '12 mins',
    },
    {
      'title': 'Number Puzzles',
      'emoji': '🔢',
      'category': 'Numbers & Logic',
      'duration': '10 mins',
    },
    {
      'title': 'Nature Walk',
      'emoji': '🌿',
      'category': 'Science & Nature',
      'duration': '25 mins',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startShakeListener();
  }

  @override
  void dispose() {
    _shakeSub?.cancel();
    super.dispose();
  }

  void _startShakeListener() {
    _shakeSub = accelerometerEventStream().listen((event) {
      final magnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude > 15) {
        final now = DateTime.now();
        // Only trigger on home tab, and debounce to 1.5s
        if (index == 2 &&
            now.difference(_lastShake).inMilliseconds > 1500) {
          _lastShake = now;
          final activity =
              _shakeActivities[Random().nextInt(_shakeActivities.length)];
          _showActivitySuggestion(activity);
        }
      }
    });
  }

  void _showActivitySuggestion(Map<String, String> activity) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ActivitySuggestionSheet(
        activity: activity,
        onStart: () {
          Navigator.pop(context); // close sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivityDetailPage(
                title: activity['title']!,
                emoji: activity['emoji']!,
                duration: activity['duration']!,
                category: activity['category']!,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const UpdatesPage(),
      const SettingsPage(),
      _homeUi(),
      ProfilePage(role: widget.role),
      const MorePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: pages[index]),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF8EC5FC),
          unselectedItemColor: Colors.grey.shade400,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Updates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeUi() {
    final greeting = isParent ? "Hi Parent!" : "Hi Instructor!";

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    "assets/images/LoginRegister/Group_8037.png",
                    height: 140,
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "4 Y/O | Beginner",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.black54,
                        size: 34,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Shake hint banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF8EC5FC).withValues(alpha: 0.4),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.vibration, color: Color(0xFF8EC5FC), size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '🎲 Shake your phone to get a random activity suggestion!',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Today's highlight
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E8),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: const Row(
              children: [
                Text("🌈", style: TextStyle(fontSize: 42)),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Highlight",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text("Rainbow Paper Craft"),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.black54),
                          SizedBox(width: 4),
                          Text(
                            "10 mins",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Feature grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                FeatureTile(
                  title: "Craft Corner",
                  icon: Icons.palette,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ActivitiesPage(category: 'Craft Corner'),
                    ),
                  ),
                ),
                FeatureTile(
                  title: "Letters & Phonics",
                  icon: Icons.text_fields,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ActivitiesPage(category: 'Letters & Phonics'),
                    ),
                  ),
                ),
                FeatureTile(
                  title: "Story Time",
                  icon: Icons.book,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ActivitiesPage(category: 'Story Time'),
                    ),
                  ),
                ),
                FeatureTile(
                  title: "Numbers & Logic",
                  icon: Icons.calculate,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ActivitiesPage(category: 'Numbers & Logic'),
                    ),
                  ),
                ),
                FeatureTile(
                  title: "Thinking Skills",
                  icon: Icons.psychology,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ActivitiesPage(category: 'Thinking Skills'),
                    ),
                  ),
                ),
                FeatureTile(
                  title: "Science & Nature",
                  icon: Icons.eco,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ActivitiesPage(category: 'Science & Nature'),
                    ),
                  ),
                ),
                FeatureTile(
                  title: "Post Update",
                  icon: Icons.post_add,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PostUpdatePage()),
                  ),
                ),
                FeatureTile(
                  title: "Learning Progress",
                  icon: Icons.show_chart,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProgressPage()),
                  ),
                ),
                FeatureTile(
                  title: "Rewards & Badges",
                  icon: Icons.workspace_premium,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Recommended
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                "Recommended for You",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFE8A3),
                  Color(0xFFFFCFA8),
                  Color(0xFFFFB88A),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.extension, size: 36, color: Color(0xFFFF9A3E)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Shape Sorting Game\nBoosts thinking + fine motor skills!",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─── Activity Suggestion Bottom Sheet ────────────────────────────────────────
class _ActivitySuggestionSheet extends StatelessWidget {
  final Map<String, String> activity;
  final VoidCallback onStart;
  const _ActivitySuggestionSheet({
    required this.activity,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            '🎲 Activity Suggestion',
            style: TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 8),

          Text(
            activity['emoji']!,
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 10),

          Text(
            activity['title']!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '${activity['category']} · ${activity['duration']}',
            style: const TextStyle(color: Colors.black45, fontSize: 13),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onStart,
                child: const Text(
                  'Start Activity →',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe later'),
          ),
        ],
      ),
    );
  }
}
