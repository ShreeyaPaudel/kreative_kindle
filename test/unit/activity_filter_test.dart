import 'package:flutter_test/flutter_test.dart';

/// Mirrors the search filter logic in ActivitiesPage.
List<Map<String, String>> filterActivities(
  List<Map<String, String>> activities,
  String query,
) {
  if (query.isEmpty) return activities;
  final q = query.toLowerCase();
  return activities.where((a) => a['title']!.toLowerCase().contains(q)).toList();
}

void main() {
  const activities = [
    {'title': 'Rainbow Paper Craft', 'duration': '10 mins', 'emoji': '🌈'},
    {'title': 'Paper Plate Animals', 'duration': '15 mins', 'emoji': '🦁'},
    {'title': 'Nature Walk', 'duration': '25 mins', 'emoji': '🌿'},
    {'title': 'Number Puzzles', 'duration': '10 mins', 'emoji': '🔢'},
  ];

  group('Activity search filter', () {
    test('PASS: empty query returns all activities', () {
      expect(filterActivities(activities, '').length, 4);
    });

    test('PASS: query "paper" matches two activities', () {
      final result = filterActivities(activities, 'paper');
      expect(result.length, 2);
    });

    test('PASS: query is case-insensitive', () {
      final result = filterActivities(activities, 'NATURE');
      expect(result.length, 1);
      expect(result.first['title'], 'Nature Walk');
    });

    test('PASS: non-matching query returns empty list', () {
      expect(filterActivities(activities, 'xyz123').isEmpty, true);
    });
  });
}
