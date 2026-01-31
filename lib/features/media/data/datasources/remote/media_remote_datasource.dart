import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:3001", // backend
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
});

final mediaRemoteDatasourceProvider = Provider<MediaRemoteDatasource>((ref) {
  return MediaRemoteDatasource(ref.read(dioProvider));
});

class MediaRemoteDatasource {
  final Dio dio;
  MediaRemoteDatasource(this.dio);

  Future<String> uploadImage(File file) async {
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path),
    });

    final res = await dio.post(
      "/api/upload",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    final data = res.data;

    if (data is Map && data["imageUrl"] != null) {
      return data["imageUrl"].toString();
    }

    throw Exception("Upload failed");
  }
}
