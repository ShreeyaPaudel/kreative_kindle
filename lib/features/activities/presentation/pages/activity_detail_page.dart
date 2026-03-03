import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ActivityDetailPage extends StatefulWidget {
  final String title;
  final String emoji;
  final String duration;
  final String category;

  const ActivityDetailPage({
    super.key,
    required this.title,
    required this.emoji,
    required this.duration,
    required this.category,
  });

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  // ── Step navigator state (gyroscope) ──────────────────────────────────────
  int _currentStep = 0;
  bool _gyroDebounce = false;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  // ── Pause state (proximity) ────────────────────────────────────────────────
  bool _isPaused = false;
  StreamSubscription<dynamic>? _proxSub;

  // Unique content per activity
  Map<String, dynamic> get _activityData {
    final Map<String, Map<String, dynamic>> data = {
      'Rainbow Paper Craft': {
        'description':
            'A colourful craft activity where children create beautiful rainbow artwork using paper strips. This boosts fine motor skills, colour recognition, and creativity.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'materials': [
          '📄 Coloured paper strips',
          '✂️ Child-safe scissors',
          '🧴 Glue stick',
          '✏️ Pencil',
        ],
        'steps': [
          'Cut coloured paper into strips of equal size',
          'Arrange strips in rainbow colour order (red, orange, yellow, green, blue, purple)',
          'Glue each strip onto white paper in a curved shape',
          'Add cotton wool clouds at the ends',
          'Let dry and display your rainbow!',
        ],
      },
      'Shape Sorting Game': {
        'description':
            'An interactive game where children match and sort shapes by colour and size. Develops logical thinking, spatial awareness, and problem-solving skills.',
        'ageGroup': '2-5 yrs',
        'level': 'Beginner',
        'materials': [
          '🔷 Shape cutouts (circle, square, triangle)',
          '🎨 Coloured markers',
          '📦 Sorting box with holes',
        ],
        'steps': [
          'Lay out all shape cutouts on the table',
          'Ask your child to identify each shape by name',
          'Sort shapes by colour first, then by size',
          'Try matching shapes to the correct holes in the box',
          'Celebrate each correct match with encouragement!',
        ],
      },
      'Finger Painting': {
        'description':
            'A sensory art activity using fingers as paintbrushes. Encourages self-expression, sensory exploration, and develops hand-eye coordination.',
        'ageGroup': '2-6 yrs',
        'level': 'Beginner',
        'materials': [
          '🎨 Non-toxic finger paint',
          '📄 Large white paper',
          '🧴 Baby wipes for cleanup',
          '👕 Old shirt/apron',
        ],
        'steps': [
          'Cover the table with newspaper and put on an apron',
          'Squeeze small amounts of different paint colours onto a palette',
          'Dip fingers into paint and press onto paper',
          'Try making handprints, swirls, and dots',
          'Let the painting dry completely before displaying',
        ],
      },
      'Story Building': {
        'description':
            'A creative storytelling activity where children build their own stories using picture cards. Develops language skills, imagination, and narrative thinking.',
        'ageGroup': '4-7 yrs',
        'level': 'Intermediate',
        'materials': [
          '🃏 Picture story cards',
          '📖 Blank story book',
          '🖍️ Crayons',
          '⭐ Sticker rewards',
        ],
        'steps': [
          'Spread picture cards face down on the table',
          'Child picks 3 random cards',
          'Ask them: "Can you make a story with these pictures?"',
          'Help them draw their story in the blank book',
          'Read the story back together and celebrate!',
        ],
      },
      'Number Puzzles': {
        'description':
            'Fun number matching and counting puzzles that make maths enjoyable. Builds number recognition, counting skills, and basic arithmetic.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'materials': [
          '🔢 Number puzzle cards (1-10)',
          '🟡 Counting tokens/beads',
          '📝 Worksheet',
          '✏️ Pencil',
        ],
        'steps': [
          'Lay out number cards 1-10 in order',
          'Count out the matching number of tokens for each card',
          'Mix up the cards and ask child to reorder them',
          'Try the worksheet — trace numbers and draw matching dots',
          'Award a sticker for every completed puzzle!',
        ],
      },
      'Nature Walk': {
        'description':
            'An outdoor exploration activity where children discover the natural world. Encourages curiosity, observation skills, and appreciation for nature.',
        'ageGroup': '3-8 yrs',
        'level': 'Beginner',
        'materials': [
          '🎒 Small backpack',
          '🔍 Magnifying glass',
          '📋 Nature checklist',
          '🫙 Collection jar',
        ],
        'steps': [
          'Print or draw a nature checklist (leaf, flower, rock, bug, bird)',
          'Head to a park or garden with your child',
          'Use the magnifying glass to examine small things closely',
          'Collect safe items like leaves, pebbles, and seed pods',
          'Come home and identify everything you collected!',
        ],
      },
    };

    return data[widget.title] ??
        {
          'description':
              'A fun and engaging activity designed to support your child\'s development.',
          'ageGroup': '3-6 yrs',
          'level': 'Beginner',
          'materials': ['📄 Paper', '✏️ Pencil', '🎨 Colours'],
          'steps': [
            'Prepare your materials',
            'Follow the instructions',
            'Have fun!',
          ],
        };
  }

  @override
  void initState() {
    super.initState();
    _startGyroscope();
    _startProximity();
  }

  // ── Gyroscope: tilt left/right to navigate steps ─────────────────────────
  void _startGyroscope() {
    _gyroSub = gyroscopeEventStream().listen((event) {
      if (_gyroDebounce) return;
      final steps = List<String>.from(_activityData['steps']);

      if (event.y > 2.5 && _currentStep < steps.length - 1) {
        // Tilt right → next step
        _gyroDebounce = true;
        setState(() => _currentStep++);
        Future.delayed(
          const Duration(milliseconds: 700),
          () => _gyroDebounce = false,
        );
      } else if (event.y < -2.5 && _currentStep > 0) {
        // Tilt left → previous step
        _gyroDebounce = true;
        setState(() => _currentStep--);
        Future.delayed(
          const Duration(milliseconds: 700),
          () => _gyroDebounce = false,
        );
      }
    });
  }

  // ── Proximity: face-down to pause activity ───────────────────────────────
  void _startProximity() {
    _proxSub = ProximitySensor.events.listen((event) {
      final isNear = (event == 0);
      if (isNear != _isPaused && mounted) {
        setState(() => _isPaused = isNear);
      }
    });
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    _proxSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _activityData;
    final materials = List<String>.from(data['materials']);
    final steps = List<String>.from(data['steps']);

    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              // Header
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.category,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 36),
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
                      // Stats row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 6),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem(
                              context,
                              Icons.timer,
                              widget.duration,
                              'Duration',
                            ),
                            _statItem(
                              context,
                              Icons.star,
                              data['level'],
                              'Level',
                            ),
                            _statItem(
                              context,
                              Icons.people,
                              data['ageGroup'],
                              'Age Group',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      _sectionTitle(context, 'About this Activity'),
                      const SizedBox(height: 8),
                      Text(
                        data['description'],
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _sectionTitle(context, 'Materials Needed'),
                      const SizedBox(height: 8),
                      ...materials.map((m) => _materialItem(context, m)),

                      const SizedBox(height: 20),

                      // Steps with gyroscope navigation hint
                      Row(
                        children: [
                          Expanded(
                            child: _sectionTitle(context, 'Steps'),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8EC5FC)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.screen_rotation,
                                  size: 14,
                                  color: Color(0xFF8EC5FC),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_currentStep + 1}/${steps.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8EC5FC),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Tilt hint
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          '← Tilt phone left/right to navigate steps →',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black38,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      ...steps.asMap().entries.map(
                        (e) => _stepItem(
                          context,
                          e.key + 1,
                          e.value,
                          isActive: e.key == _currentStep,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Proximity pause overlay ──────────────────────────────────────────
        if (_isPaused)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.75),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pause_circle_filled,
                    size: 72,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Activity Paused',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lift phone face-up to resume',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
    );
  }

  Widget _statItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF8EC5FC), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade400
                : Colors.black45,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _materialItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  Widget _stepItem(
    BuildContext context,
    int step,
    String text, {
    bool isActive = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      padding: isActive
          ? const EdgeInsets.all(12)
          : const EdgeInsets.only(bottom: 2),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF8EC5FC).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF8EC5FC).withValues(alpha: 0.4),
              ),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(
                      colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                    )
                  : null,
              color: isActive ? null : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black45,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  height: 1.5,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.normal,
                  color: isActive ? Colors.black87 : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
