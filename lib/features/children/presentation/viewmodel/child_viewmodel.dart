import 'package:riverpod/legacy.dart';

import '../../data/models/child_model.dart';
import '../../data/repositories/child_repository.dart';

class ChildState {
  final List<ChildModel> children;
  final bool isLoading;
  final String? error;

  const ChildState({
    this.children = const [],
    this.isLoading = false,
    this.error,
  });

  ChildState copyWith({
    List<ChildModel>? children,
    bool? isLoading,
    String? error,
  }) => ChildState(
    children:  children  ?? this.children,
    isLoading: isLoading ?? this.isLoading,
    error:     error,
  );
}

final childViewModelProvider =
    StateNotifierProvider<ChildViewModel, ChildState>((ref) {
  return ChildViewModel(ref.read(childRepositoryProvider));
});

class ChildViewModel extends StateNotifier<ChildState> {
  final ChildRepository _repo;

  ChildViewModel(this._repo) : super(const ChildState()) {
    loadChildren();
  }

  Future<void> loadChildren() async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await _repo.getChildren();
      state = state.copyWith(children: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addChild({required String name, required int age}) async {
    state = state.copyWith(isLoading: true);
    try {
      final child = await _repo.createChild(name: name, age: age);
      state = state.copyWith(
        children:  [...state.children, child],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateChild({required String id, String? name, int? age}) async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await _repo.updateChild(id: id, name: name, age: age);
      state = state.copyWith(
        children:  state.children.map((c) => c.id == id ? updated : c).toList(),
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteChild(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repo.deleteChild(id);
      state = state.copyWith(
        children:  state.children.where((c) => c.id != id).toList(),
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}
