import 'package:flutter/material.dart';
import 'activity_detail_page.dart';

class ActivitiesPage extends StatefulWidget {
  final String category;
  const ActivitiesPage({super.key, required this.category});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  static const _categoryActivities = {
    'Craft Corner': [
      {'title': 'Rainbow Paper Craft', 'duration': '10 mins', 'emoji': '🌈'},
      {'title': 'Paper Plate Animals', 'duration': '15 mins', 'emoji': '🦁'},
      {'title': 'Collage Making', 'duration': '20 mins', 'emoji': '✂️'},
      {'title': 'Clay Modelling', 'duration': '25 mins', 'emoji': '🏺'},
      {'title': 'Origami Shapes', 'duration': '12 mins', 'emoji': '📄'},
      {'title': 'Puppet Making', 'duration': '18 mins', 'emoji': '🎭'},
    ],
    'Letters & Phonics': [
      {'title': 'Letter Tracing', 'duration': '10 mins', 'emoji': '✍️'},
      {'title': 'Rhyme Time', 'duration': '8 mins', 'emoji': '🎵'},
      {'title': 'Alphabet Puzzle', 'duration': '15 mins', 'emoji': '🔤'},
      {'title': 'Word Building', 'duration': '12 mins', 'emoji': '📝'},
      {'title': 'Sound Sorting', 'duration': '10 mins', 'emoji': '👂'},
      {'title': 'Silly Sentences', 'duration': '8 mins', 'emoji': '😄'},
    ],
    'Story Time': [
      {'title': 'Story Building', 'duration': '12 mins', 'emoji': '📖'},
      {'title': 'Character Drawing', 'duration': '15 mins', 'emoji': '✏️'},
      {'title': 'Story Sequencing', 'duration': '10 mins', 'emoji': '🃏'},
      {'title': 'Puppet Theatre', 'duration': '20 mins', 'emoji': '🎭'},
      {'title': 'Book Review', 'duration': '8 mins', 'emoji': '⭐'},
      {'title': 'Make a Comic', 'duration': '18 mins', 'emoji': '💬'},
    ],
    'Numbers & Logic': [
      {'title': 'Number Puzzles', 'duration': '10 mins', 'emoji': '🔢'},
      {'title': 'Counting Bears', 'duration': '8 mins', 'emoji': '🐻'},
      {'title': 'Shape Patterns', 'duration': '12 mins', 'emoji': '🔷'},
      {'title': 'Simple Addition', 'duration': '15 mins', 'emoji': '➕'},
      {'title': 'Memory Match', 'duration': '10 mins', 'emoji': '🧠'},
      {'title': 'Time Telling', 'duration': '12 mins', 'emoji': '🕐'},
    ],
    'Thinking Skills': [
      {'title': 'Shape Sorting Game', 'duration': '15 mins', 'emoji': '🔷'},
      {'title': 'Maze Runner', 'duration': '10 mins', 'emoji': '🌀'},
      {'title': 'Pattern Copying', 'duration': '8 mins', 'emoji': '🎨'},
      {'title': 'Block Building', 'duration': '20 mins', 'emoji': '🧱'},
      {'title': 'What Comes Next?', 'duration': '10 mins', 'emoji': '❓'},
      {'title': 'Spot the Difference', 'duration': '12 mins', 'emoji': '🔍'},
    ],
    'Science & Nature': [
      {'title': 'Nature Walk', 'duration': '25 mins', 'emoji': '🌿'},
      {'title': 'Leaf Printing', 'duration': '15 mins', 'emoji': '🍂'},
      {'title': 'Sink or Float', 'duration': '10 mins', 'emoji': '🌊'},
      {'title': 'Bug Hunting', 'duration': '20 mins', 'emoji': '🐛'},
      {'title': 'Mini Garden', 'duration': '30 mins', 'emoji': '🌱'},
      {'title': 'Cloud Watching', 'duration': '15 mins', 'emoji': '☁️'},
    ],
  };

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allActivities = _categoryActivities[widget.category] ?? [
      {'title': 'Rainbow Paper Craft', 'duration': '10 mins', 'emoji': '🌈'},
      {'title': 'Shape Sorting Game', 'duration': '15 mins', 'emoji': '🔷'},
      {'title': 'Finger Painting', 'duration': '20 mins', 'emoji': '🎨'},
      {'title': 'Story Building', 'duration': '12 mins', 'emoji': '📖'},
      {'title': 'Number Puzzles', 'duration': '10 mins', 'emoji': '🔢'},
      {'title': 'Nature Walk', 'duration': '25 mins', 'emoji': '🌿'},
    ];

    final activities = _searchQuery.isEmpty
        ? allActivities
        : allActivities
            .where((a) => a['title']!.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
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
            child: Column(
              children: [
                Row(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Choose an activity',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    key: const Key('activitySearch'),
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Search activities...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF8EC5FC), size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: activities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          'No activities match "$_searchQuery"',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final isDark = Theme.of(context).brightness == Brightness.dark;
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ActivityDetailPage(
                              title: activity['title']!,
                              emoji: activity['emoji']!,
                              duration: activity['duration']!,
                              category: widget.category,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                activity['emoji']!,
                                style: const TextStyle(fontSize: 36),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 14,
                                          color: isDark ? Colors.white54 : Colors.black45,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          activity['duration']!,
                                          style: TextStyle(
                                            color: isDark ? Colors.white54 : Colors.black45,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'View →',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
