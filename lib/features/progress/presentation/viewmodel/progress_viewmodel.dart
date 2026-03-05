import 'package:riverpod/legacy.dart';

import '../../data/datasources/progress_remote_datasource.dart';

// ── State ────────────────────────────────────────────────────────
class ProgressState {
  final List<Map<String, dynamic>> completed;
  final List<Map<String, dynamic>> favourites;
  final bool isLoading;
  final String? error;

  const ProgressState({
    this.completed  = const [],
    this.favourites = const [],
    this.isLoading  = false,
    this.error,
  });

  ProgressState copyWith({
    List<Map<String, dynamic>>? completed,
    List<Map<String, dynamic>>? favourites,
    bool? isLoading,
    String? error,
  }) => ProgressState(
    completed:  completed  ?? this.completed,
    favourites: favourites ?? this.favourites,
    isLoading:  isLoading  ?? this.isLoading,
    error:      error,
  );
}

// ── Provider ─────────────────────────────────────────────────────
final progressViewModelProvider =
    StateNotifierProvider<ProgressViewModel, ProgressState>((ref) {
  return ProgressViewModel(ref.read(progressRemoteDatasourceProvider));
});

// ── ViewModel ────────────────────────────────────────────────────
class ProgressViewModel extends StateNotifier<ProgressState> {
  final ProgressRemoteDatasource _ds;

  ProgressViewModel(this._ds) : super(const ProgressState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _ds.getProgress();
      // Backend returns { activities: [...] } (not 'completed')
      final rawList = data['activities'] ?? data['completed'];
      final completed = rawList is List
          ? rawList
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList()
          : <Map<String, dynamic>>[];

      final favs = await _ds.getFavourites();

      state = state.copyWith(
        completed:  completed,
        favourites: favs,
        isLoading:  false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markComplete({
    required int    activityId,
    required String activityTitle,
    required String category,
  }) async {
    try {
      await _ds.markComplete(
        activityId:    activityId,
        activityTitle: activityTitle,
        category:      category,
      );
      await load();
    } catch (_) {}
  }

  Future<void> undoComplete(int activityId) async {
    try {
      await _ds.undoComplete(activityId);
      await load();
    } catch (_) {}
  }

  Future<void> addFavourite({
    required int    activityId,
    required String activityTitle,
    required String category,
    required String age,
    required String image,
  }) async {
    try {
      await _ds.addFavourite(
        activityId:    activityId,
        activityTitle: activityTitle,
        category:      category,
        age:           age,
        image:         image,
      );
      final favs = await _ds.getFavourites();
      state = state.copyWith(favourites: favs);
    } catch (_) {}
  }

  Future<void> removeFavourite(int activityId) async {
    try {
      await _ds.removeFavourite(activityId);
      final favs = await _ds.getFavourites();
      state = state.copyWith(favourites: favs);
    } catch (_) {}
  }

  bool isCompleted(int activityId) =>
      state.completed.any((c) => c['activityId'] == activityId);

  bool isFavourite(int activityId) =>
      state.favourites.any((f) => f['activityId'] == activityId);
}
