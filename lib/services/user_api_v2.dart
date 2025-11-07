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

  Future<Map<String, dynamic>> updatePhone(String phone) async {
    // Normalize Indian numbers: 10-digit -> +91XXXXXXXXXX
    String p = phone.trim();
    if (RegExp(r'^\d{10}$').hasMatch(p)) {
      p = '+91' + p;
    }
    final r = await dio.put('/api/auth/me', data: {'phone': p});
    final data = r.data as Map<String, dynamic>;
    return (data['user'] as Map).cast<String, dynamic>();
  }
}
