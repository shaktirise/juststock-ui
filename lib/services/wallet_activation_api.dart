import 'package:dio/dio.dart';

class WalletActivationApi {
  final Dio dio;
  WalletActivationApi(this.dio);

  /// GET /api/wallet/activation/countdown
  /// Returns activation window meta and countdown timing.
  Future<Map<String, dynamic>> countdown() async {
    final r = await dio.get('/api/wallet/activation/countdown');
    if (r.data is Map) return (r.data as Map).cast<String, dynamic>();
    return const {};
  }
}

