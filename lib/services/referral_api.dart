import 'package:dio/dio.dart';

num rupees(int paise) => paise / 100;

class ReferralApi {
  final Dio dio;
  ReferralApi(this.dio);

  Future<List<dynamic>> tree({int depth = 10}) async {
    final r = await dio.get('/api/auth/referrals/tree', queryParameters: {'depth': depth});
    final data = r.data as Map<String, dynamic>;
    return (data['levels'] as List).toList();
  }

  Future<Map<String, dynamic>> earnings() async {
    final r = await dio.get('/api/auth/referrals/earnings');
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> listL1({int limit = 50, int offset = 0}) async {
    final r = await dio.get('/api/auth/referrals', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> config() async {
    final r = await dio.get('/api/auth/referrals/config');
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> requestWithdraw({String? note}) async {
    final r = await dio.post('/api/auth/referrals/withdraw', data: {
      if (note != null) 'note': note,
    });
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<List<dynamic>> withdrawals() async {
    final r = await dio.get('/api/auth/referrals/withdrawals');
    final data = r.data as Map<String, dynamic>;
    return (data['items'] as List).toList();
  }
}

