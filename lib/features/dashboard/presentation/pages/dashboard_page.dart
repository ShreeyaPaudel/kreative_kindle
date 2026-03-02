import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/feature_tile.dart';
import './profile_page.dart';
import '../../../../features/dashboard/presentation/pages/settings_page.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/services/sensors/accelerometer_screen.dart';

class DashboardPage extends ConsumerStatefulWidget {
  final String role;
  const DashboardPage({super.key, required this.role});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int index = 2;

  bool get isParent => widget.role.toLowerCase() == "parent";

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Center(child: Text("Updates", style: TextStyle(fontSize: 18))),
      const SettingsPage(),
      _homeUi(),
      ProfilePage(role: widget.role),
      const Center(child: Text("More", style: TextStyle(fontSize: 18))),
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
                          style: TextStyle(color: Colors.white70, fontSize: 14),
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

          // Sensor tile
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AccelerometerScreen()),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.sensors, color: Colors.white, size: 32),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Motion Sensor',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Tap to view accelerometer data',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
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
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.1,
              children: const [
                FeatureTile(title: "Craft Corner", icon: Icons.palette),
                FeatureTile(
                  title: "Letters & Phonics",
                  icon: Icons.text_fields,
                ),
                FeatureTile(title: "Story Time", icon: Icons.book),
                FeatureTile(title: "Numbers & Logic", icon: Icons.calculate),
                FeatureTile(title: "Thinking Skills", icon: Icons.psychology),
                FeatureTile(title: "Science & Nature", icon: Icons.eco),
                FeatureTile(title: "Post Update", icon: Icons.post_add),
                FeatureTile(title: "Learning Progress", icon: Icons.show_chart),
                FeatureTile(
                  title: "Rewards & Badges",
                  icon: Icons.workspace_premium,
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
