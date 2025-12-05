import 'package:flutter/material.dart';
import '../../Role/user_role.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                            UserRole.role == "parent"
                                ? "Hi Parent!"
                                : "Hi Instructor!",
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
                        decoration: BoxDecoration(
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

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E8),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  const Text("🌈", style: TextStyle(fontSize: 42)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Today's Highlight",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Rainbow Paper Craft",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 16, color: Colors.black54),
                            SizedBox(width: 4),
                            Text(
                              "10 mins",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.1,
                children: [
                  featureTile("Craft Corner", Icons.palette),
                  featureTile("Letters & Phonics", Icons.text_fields),
                  featureTile("Story Time", Icons.book),
                  featureTile("Numbers & Logic", Icons.calculate),
                  featureTile("Thinking Skills", Icons.psychology),
                  featureTile("Science & Nature", Icons.eco),
                  featureTile("Post Update", Icons.post_add),
                  featureTile("Learning Progress", Icons.show_chart),
                  featureTile("Rewards & Badges", Icons.workspace_premium),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: const Text(
                  "Recommended for You",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    child: const Icon(
                      Icons.lightbulb,
                      size: 36,
                      color: Color(0xFFFF9A3E),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Shape Sorting Game",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Boosts thinking + fine motor skills!",
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
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

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget featureTile(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8EC5FC), // pastel blue
                  Color(0xFFE0C3FC), // pastel purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 36,
              color: Colors.white, // white icon looks clean on gradient circle
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
