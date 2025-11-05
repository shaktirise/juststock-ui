import 'package:dio/dio.dart';

class UserApiV2 {
  final Dio dio;
  UserApiV2(this.dio);

  Future<Map<String, dynamic>> me() async {
    final r = await dio.get('/api/auth/me');
    final data = r.data as Map<String, dynamic>;
    return (data['user'] as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> updateName(String name) async {
    final r = await dio.put('/api/auth/me', data: {'name': name});
    final data = r.data as Map<String, dynamic>;
    return (data['user'] as Map).cast<String, dynamic>();
  }
}

