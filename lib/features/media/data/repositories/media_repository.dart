import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/remote/media_remote_datasource.dart';

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepository(ref.read(mediaRemoteDatasourceProvider));
});

class MediaRepository {
  final MediaRemoteDatasource remote;
  MediaRepository(this.remote);

  Future<String> uploadImage(File file) {
    return remote.uploadImage(file);
  }
}
