import 'dart:io';
import 'package:riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/media_repository.dart';

final mediaViewModelProvider =
    StateNotifierProvider<MediaViewModel, MediaState>((ref) {
      return MediaViewModel(ref.read(mediaRepositoryProvider));
    });

class MediaState {
  final bool loading;
  final String? imageUrl;
  final String? error;

  const MediaState({this.loading = false, this.imageUrl, this.error});

  MediaState copyWith({bool? loading, String? imageUrl, String? error}) {
    return MediaState(
      loading: loading ?? this.loading,
      imageUrl: imageUrl ?? this.imageUrl,
      error: error,
    );
  }
}

class MediaViewModel extends StateNotifier<MediaState> {
  final MediaRepository repo;
  MediaViewModel(this.repo) : super(const MediaState());

  Future<void> upload(File file) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final url = await repo.uploadImage(file);
      state = state.copyWith(loading: false, imageUrl: url);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
