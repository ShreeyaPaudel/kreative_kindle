import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';

final progressRemoteDatasourceProvider =
    Provider<ProgressRemoteDatasource>((ref) {
  return ProgressRemoteDatasource(ref.read(apiClientProvider).dio);
});

class ProgressRemoteDatasource {
  final Dio _dio;
  ProgressRemoteDatasource(this._dio);

  // GET /api/progress
  Future<Map<String, dynamic>> getProgress() async {
    final res  = await _dio.get(ApiEndpoints.progress);
    final data = res.data;
    return (data is Map) ? Map<String, dynamic>.from(data) : {};
  }

  // POST /api/progress/complete
  Future<void> markComplete({
    required int activityId,
    required String activityTitle,
    required String category,
  }) async {
    await _dio.post(ApiEndpoints.progressComplete, data: {
      'activityId':    activityId,
      'activityTitle': activityTitle,
      'category':      category,
    });
  }

  // DELETE /api/progress/complete/:activityId
  Future<void> undoComplete(int activityId) async {
    await _dio.delete('${ApiEndpoints.progressComplete}/$activityId');
  }

  // GET /api/progress/favourites
  Future<List<Map<String, dynamic>>> getFavourites() async {
    final res  = await _dio.get(ApiEndpoints.progressFavourites);
    final data = res.data;
    final list = data is List ? data : (data is Map ? (data['data'] ?? []) : []);
    return (list as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // POST /api/progress/favourites
  Future<void> addFavourite({
    required int    activityId,
    required String activityTitle,
    required String category,
    required String age,
    required String image,
  }) async {
    await _dio.post(ApiEndpoints.progressFavourites, data: {
      'activityId':    activityId,
      'activityTitle': activityTitle,
      'category':      category,
      'age':           age,
      'image':         image,
    });
  }

  // DELETE /api/progress/favourites/:activityId
  Future<void> removeFavourite(int activityId) async {
    await _dio.delete('${ApiEndpoints.progressFavourites}/$activityId');
  }
}
