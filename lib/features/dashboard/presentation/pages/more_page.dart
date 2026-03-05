import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../children/presentation/pages/children_page.dart';
import '../../../progress/presentation/viewmodel/progress_viewmodel.dart';
import './progress_page.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final cardBg   = isDark ? const Color(0xFF1E2530) : Colors.white;
    final subColor = isDark ? Colors.white54 : Colors.black54;
    final divColor = isDark ? Colors.white10 : Colors.grey.shade100;

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

                  // ── Activity Features ─────────────────────────
                  _label('Activity Features', isDark),
                  const SizedBox(height: 8),
                  _card(cardBg, [
                    _row(
                      icon: Icons.workspace_premium_outlined,
                      iconBg: const Color(0xFFFFF8E1),
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Rewards & Badges',
                      subtitle: 'View earned badges and achievements',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: true,
                      onTap: () => _showRewardsBadges(context, ref),
                    ),
                    _row(
                      icon: Icons.calendar_month_outlined,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Activity Calendar',
                      subtitle: 'Weekly activity planner',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: false,
                      onTap: () => _showCalendar(context, isDark),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Profiles & Progress ────────────────────────
                  _label('Profiles & Progress', isDark),
                  const SizedBox(height: 8),
                  _card(cardBg, [
                    _row(
                      icon: Icons.family_restroom_outlined,
                      iconBg: const Color(0xFFE8F4FF),
                      iconColor: const Color(0xFF3B9EFF),
                      title: 'Child Profiles',
                      subtitle: 'Manage your children\'s profiles',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChildrenPage()),
                      ),
                    ),
                    _row(
                      icon: Icons.bar_chart_rounded,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF9C27B0),
                      title: 'Reports',
                      subtitle: 'Detailed learning reports',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: true,
                      onTap: () => _showReports(context, ref, isDark),
                    ),
                    _row(
                      icon: Icons.trending_up_rounded,
                      iconBg: const Color(0xFFE0F7FA),
                      iconColor: const Color(0xFF00BCD4),
                      title: 'Learning Progress',
                      subtitle: 'Track completed activities',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: false,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProgressPage()),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Community ─────────────────────────────────
                  _label('Community', isDark),
                  const SizedBox(height: 8),
                  _card(cardBg, [
                    _row(
                      icon: Icons.forum_outlined,
                      iconBg: const Color(0xFFFCE4EC),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Community',
                      subtitle: 'Connect with other parents',
                      subColor: subColor,
                      divColor: divColor,
                      showDiv: false,
                      onTap: () => _showComingSoon(context, 'Community'),
                    ),
                  ]),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'More',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                Text(
                  'Extra features and resources',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared helpers (mirrors settings_page.dart) ───────────────
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
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
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

  // ── Rewards & Badges ─────────────────────────────────────────
  void _showRewardsBadges(BuildContext context, WidgetRef ref) {
    final state     = ref.read(progressViewModelProvider);
    final completed = state.completed.length;
    final favs      = state.favourites.length;
    final cats      = <String>{};
    for (final c in state.completed) {
      if (c['category'] != null) cats.add(c['category'].toString());
    }

    final badges = [
      _Badge('🌱', 'First Step',   'Complete 1 activity',          completed >= 1),
      _Badge('⭐', 'Star Learner', 'Complete 5 activities',         completed >= 5),
      _Badge('🏅', 'High Achiever','Complete 10 activities',        completed >= 10),
      _Badge('❤️', 'Collector',    'Add 1 favourite',               favs >= 1),
      _Badge('🌈', 'All-Rounder',  'Complete in 3+ categories',     cats.length >= 3),
      _Badge('🔥', 'On Fire',      'Complete 20 activities',        completed >= 20),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final dark = Theme.of(ctx).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHandle(),
              const SizedBox(height: 16),
              const Text('🏆 Rewards & Badges',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(
                '${badges.where((b) => b.earned).length} of ${badges.length} earned',
                style: TextStyle(
                  fontSize: 13,
                  color: dark ? Colors.white54 : Colors.black45,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
                physics: const NeverScrollableScrollPhysics(),
                children: badges.map((b) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: b.earned
                          ? (dark ? const Color(0xFF1E3A5F) : const Color(0xFFEAF4FF))
                          : (dark ? const Color(0xFF1A1F2B) : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: b.earned
                            ? const Color(0xFF8EC5FC).withValues(alpha: 0.6)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          b.emoji,
                          style: TextStyle(
                            fontSize: 28,
                            color: b.earned ? null : const Color(0x66000000),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: b.earned
                                ? (dark ? Colors.white : Colors.black87)
                                : Colors.grey,
                          ),
                        ),
                        if (!b.earned)
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.lock_outline, size: 11, color: Colors.grey),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Activity Calendar ─────────────────────────────────────────
  void _showCalendar(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _CalendarSheet(),
    );
  }

  // ── Reports ───────────────────────────────────────────────────
  void _showReports(BuildContext context, WidgetRef ref, bool isDark) {
    final state     = ref.read(progressViewModelProvider);
    final done      = state.completed;
    final favs      = state.favourites;
    final catCounts = <String, int>{};
    for (final c in done) {
      final cat = c['category']?.toString() ?? 'Other';
      catCounts[cat] = (catCounts[cat] ?? 0) + 1;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final dark  = Theme.of(ctx).brightness == Brightness.dark;
        final cardC = dark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF);
        final subC  = dark ? Colors.white54 : Colors.black45;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),
                const SizedBox(height: 16),
                const Text('📊 Learning Report',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _statCard('✅', '${done.length}', 'Completed', cardC, dark)),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard('⭐', '${favs.length}', 'Favourites', cardC, dark)),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard('📂', '${catCounts.length}', 'Categories', cardC, dark)),
                  ],
                ),
                if (catCounts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('By Category',
                        style: TextStyle(fontWeight: FontWeight.w700, color: subC)),
                  ),
                  const SizedBox(height: 10),
                  ...catCounts.entries.map((e) {
                    final pct = done.isEmpty ? 0.0 : (e.value / done.length).clamp(0.0, 1.0);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600)),
                              Text('${e.value} done',
                                  style: TextStyle(fontSize: 12, color: subC)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 6,
                              backgroundColor:
                                  dark ? Colors.white12 : Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF8EC5FC)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ] else ...[
                  const SizedBox(height: 16),
                  Text(
                    'Complete some activities to see your report!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subC, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(String emoji, String value, String label, Color bg, bool dark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          Text(label,
              style: TextStyle(
                fontSize: 11,
                color: dark ? Colors.white54 : Colors.black45,
              )),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🚀', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(feature,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text(
              'This feature is coming in a future update. Stay tuned!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF8EC5FC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Got it', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sheetHandle() => Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

class _Badge {
  final String emoji;
  final String title;
  final String desc;
  final bool earned;
  const _Badge(this.emoji, this.title, this.desc, this.earned);
}

// ── Functional Activity Calendar Sheet ────────────────────────
class _CalendarSheet extends StatefulWidget {
  const _CalendarSheet();

  @override
  State<_CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends State<_CalendarSheet> {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _options = [
    'Craft Corner',
    'Letters & Phonics',
    'Story Time',
    'Numbers & Logic',
    'Thinking Skills',
    'Science & Nature',
    'Rest Day',
  ];

  List<String> _plan = List.filled(7, '');
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _plan = List.generate(7, (i) => prefs.getString('calendar_day_$i') ?? '');
      _loading = false;
    });
  }

  Future<void> _save(int index, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calendar_day_$index', value);
  }

  String _emoji(String act) {
    switch (act) {
      case 'Craft Corner':       return '🎨';
      case 'Letters & Phonics':  return '🔤';
      case 'Story Time':         return '📖';
      case 'Numbers & Logic':    return '🔢';
      case 'Thinking Skills':    return '🧠';
      case 'Science & Nature':   return '🌿';
      case 'Rest Day':           return '😴';
      default:                   return '➕';
    }
  }

  void _pick(int i) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Plan for ${_days[i]}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _options.map((opt) {
                        final selected = _plan[i] == (opt == 'Rest Day' ? '' : opt);
                        return ListTile(
                          leading: Text(_emoji(opt), style: const TextStyle(fontSize: 22)),
                          title: Text(opt, style: const TextStyle(fontWeight: FontWeight.w600)),
                          trailing: selected
                              ? const Icon(Icons.check_circle_rounded, color: Color(0xFF8EC5FC))
                              : null,
                          tileColor: selected
                              ? (dark ? const Color(0xFF1E3A5F) : const Color(0xFFEAF4FF))
                              : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onTap: () {
                            Navigator.pop(context);
                            final val = opt == 'Rest Day' ? '' : opt;
                            setState(() => _plan[i] = val);
                            _save(i, val);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark       = Theme.of(context).brightness == Brightness.dark;
    final todayIndex = DateTime.now().weekday - 1;

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '📅 Weekly Activity Planner',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a day to plan an activity',
            style: TextStyle(
              fontSize: 12,
              color: dark ? Colors.white54 : Colors.black45,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final isToday = i == todayIndex;
                final act     = _plan[i];
                return GestureDetector(
                  onTap: () => _pick(i),
                  child: Container(
                    width: 82,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? const LinearGradient(
                              colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                            )
                          : null,
                      color: isToday
                          ? null
                          : (dark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: act.isNotEmpty
                            ? const Color(0xFF8EC5FC).withValues(alpha: 0.5)
                            : (dark ? Colors.white10 : Colors.grey.shade200),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _days[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? Colors.white
                                : (dark ? Colors.white70 : Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (act.isEmpty)
                          Icon(
                            Icons.add_circle_outline,
                            size: 18,
                            color: isToday
                                ? Colors.white70
                                : (dark ? Colors.white30 : Colors.grey.shade400),
                          )
                        else ...[
                          Text(_emoji(act), style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 2),
                          Text(
                            act.split(' ').first,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              color: isToday
                                  ? Colors.white
                                  : (dark ? Colors.white60 : Colors.black45),
                            ),
                          ),
                        ],
                        if (isToday && act.isEmpty) ...[
                          const SizedBox(height: 4),
                          Container(
                            width: 6, height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF1A2035) : const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF8EC5FC).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates_outlined,
                    color: Color(0xFF8EC5FC), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tap any day to assign an activity. Your plan saves automatically! 🌟',
                    style: TextStyle(
                      fontSize: 12,
                      color: dark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
