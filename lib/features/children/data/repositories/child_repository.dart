import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/child_remote_datasource.dart';
import '../models/child_model.dart';

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  return ChildRepository(ref.read(childRemoteDatasourceProvider));
});

class ChildRepository {
  final ChildRemoteDatasource _ds;
  ChildRepository(this._ds);

  Future<List<ChildModel>> getChildren() async {
    try {
      return await _ds.getChildren();
    } on DioException catch (e) {
      throw Exception(_msg(e, 'Failed to load children'));
    }
  }

  Future<ChildModel> createChild({required String name, required int age}) async {
    try {
      return await _ds.createChild(name: name, age: age);
    } on DioException catch (e) {
      throw Exception(_msg(e, 'Failed to create child'));
    }
  }

  Future<ChildModel> updateChild({required String id, String? name, int? age}) async {
    try {
      return await _ds.updateChild(id: id, name: name, age: age);
    } on DioException catch (e) {
      throw Exception(_msg(e, 'Failed to update child'));
    }
  }

  Future<void> deleteChild(String id) async {
    try {
      await _ds.deleteChild(id);
    } on DioException catch (e) {
      throw Exception(_msg(e, 'Failed to delete child'));
    }
  }

  String _msg(DioException e, String fallback) {
    final d = e.response?.data;
    return (d is Map && d['message'] != null) ? d['message'].toString() : fallback;
  }
}
