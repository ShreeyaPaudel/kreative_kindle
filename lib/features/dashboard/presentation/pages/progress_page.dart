import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../progress/presentation/viewmodel/progress_viewmodel.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state  = ref.watch(progressViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learning Progress 📈',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Track your child's journey",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      ref.read(progressViewModelProvider.notifier).load(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('😕',
                                style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 10),
                            Text(state.error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black54)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref
                                  .read(progressViewModelProvider.notifier)
                                  .load(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: const Color(0xFF8EC5FC),
                              unselectedLabelColor:
                                  isDark ? Colors.white54 : Colors.black45,
                              indicatorColor: const Color(0xFF8EC5FC),
                              tabs: const [
                                Tab(text: 'Completed'),
                                Tab(text: 'Favourites'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  _CompletedTab(completed: state.completed),
                                  _FavouritesTab(favourites: state.favourites),
                                ],
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

// ── Completed Tab ─────────────────────────────────────────────────
class _CompletedTab extends ConsumerWidget {
  final List<Map<String, dynamic>> completed;
  const _CompletedTab({required this.completed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF);
    final subColor  = isDark ? Colors.white54 : Colors.black45;
    final itemBg    = isDark ? const Color(0xFF161B22) : Colors.white;

    if (completed.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎯', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            const Text('No activities completed yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text('Complete activities to see them here',
                style: TextStyle(color: subColor)),
          ],
        ),
      );
    }

    // Group by category
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final item in completed) {
      final cat = item['category']?.toString() ?? 'Other';
      grouped.putIfAbsent(cat, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: grouped.entries.map((entry) {
        final count    = entry.value.length;
        final progress = (count / 10).clamp(0.0, 1.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _progressCard(
              entry.key,
              progress,
              '$count activities',
              _emoji(entry.key),
              cardColor: cardColor,
              subColor: subColor,
            ),
            ...entry.value.map((item) => _completedItem(
                  item['activityTitle']?.toString() ?? 'Activity',
                  ref,
                  item['activityId'] is int ? item['activityId'] as int : 0,
                  itemBg: itemBg,
                  subColor: subColor,
                )),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget _progressCard(
    String title,
    double progress,
    String subtitle,
    String emoji, {
    required Color cardColor,
    required Color subColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    Text(subtitle,
                        style: TextStyle(color: subColor, fontSize: 12)),
                  ],
                ),
              ),
              Text('${(progress * 100).toInt()}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade400,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF8EC5FC)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _completedItem(
    String title,
    WidgetRef ref,
    int activityId, {
    required Color itemBg,
    required Color subColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF8EC5FC).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF8EC5FC), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
            onTap: () => ref
                .read(progressViewModelProvider.notifier)
                .undoComplete(activityId),
            child: Icon(Icons.undo, size: 18, color: subColor),
          ),
        ],
      ),
    );
  }

  String _emoji(String category) {
    const map = {
      'Art': '🎨',
      'Math': '🔢',
      'Reading': '📖',
      'Science': '🌿',
    };
    return map[category] ?? '📚';
  }
}

// ── Favourites Tab ────────────────────────────────────────────────
class _FavouritesTab extends ConsumerWidget {
  final List<Map<String, dynamic>> favourites;
  const _FavouritesTab({required this.favourites});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF);
    final subColor  = isDark ? Colors.white54 : Colors.black45;

    if (favourites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⭐', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            const Text('No favourites yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              'Favourite activities from the activity detail page',
              style: TextStyle(color: subColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: favourites.length,
      itemBuilder: (_, i) {
        final fav      = favourites[i];
        final title    = fav['activityTitle']?.toString() ?? 'Activity';
        final category = fav['category']?.toString() ?? '';
        final age      = fav['age']?.toString() ?? '';
        final actId    = fav['activityId'] is int
            ? fav['activityId'] as int
            : 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5)
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFE8A3), Color(0xFFFFB88A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text('⭐', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('$category · Age $age',
                        style: TextStyle(color: subColor, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 20),
                onPressed: () => ref
                    .read(progressViewModelProvider.notifier)
                    .removeFavourite(actId),
              ),
            ],
          ),
        );
      },
    );
  }
}
