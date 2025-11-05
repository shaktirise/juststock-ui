import 'package:dio/dio.dart';
import '../api/token_storage.dart' as legacy;
import 'token_store.dart';

class AuthApiV2 {
  final Dio dio;
  final TokenStore store;
  AuthApiV2(this.dio, this.store);

  Future<void> logout() async {
    try {
      final rt = await store.refresh;
      if (rt != null && rt.isNotEmpty) {
        await dio.post('/api/auth/logout', data: {'refreshToken': rt});
      }
    } catch (_) {
      // best-effort
    } finally {
      await store.clear();
      await legacy.TokenStorage.clear();
    }
  }
}

