import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../models/child_model.dart';

final childRemoteDatasourceProvider = Provider<ChildRemoteDatasource>((ref) {
  return ChildRemoteDatasource(ref.read(apiClientProvider).dio);
});

class ChildRemoteDatasource {
  final Dio _dio;
  ChildRemoteDatasource(this._dio);

  Future<List<ChildModel>> getChildren() async {
    final res  = await _dio.get(ApiEndpoints.children);
    final data = res.data;
    final list = data is List ? data : (data is Map ? (data['data'] ?? []) : []);
    return (list as List)
        .map((e) => ChildModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<ChildModel> createChild({required String name, required int age}) async {
    final res  = await _dio.post(ApiEndpoints.children, data: {'name': name, 'age': age});
    final data = res.data;
    final json = (data is Map && data['data'] is Map)
        ? data['data'] as Map
        : (data is Map ? data : {});
    return ChildModel.fromJson(Map<String, dynamic>.from(json));
  }

  Future<ChildModel> updateChild({
    required String id,
    String? name,
    int? age,
  }) async {
    final res  = await _dio.put(
      '${ApiEndpoints.children}/$id',
      data: {
        if (name != null) 'name': name,
        if (age  != null) 'age':  age,
      },
    );
    final data = res.data;
    final json = (data is Map && data['data'] is Map)
        ? data['data'] as Map
        : (data is Map ? data : {});
    return ChildModel.fromJson(Map<String, dynamic>.from(json));
  }

  Future<void> deleteChild(String id) async {
    await _dio.delete('${ApiEndpoints.children}/$id');
  }
}
