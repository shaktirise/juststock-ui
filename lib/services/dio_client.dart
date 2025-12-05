import 'package:dio/dio.dart';
import 'api_config.dart';
import 'token_store.dart';
import 'package:juststock/api/token_storage.dart' as legacy;
import 'package:juststock/api/auth_api.dart' show TokenPair;

Dio createDio(TokenStore store) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Prefer secure storage token; fall back to legacy SharedPreferences
        String? token = await store.access;
        token ??= await legacy.TokenStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final status = error.response?.statusCode;
        if (status == 401) {
          // Try refresh from either store
          String? rt = await store.refresh;
          rt ??= await legacy.TokenStorage.getRefreshToken();
          if (rt != null && rt.isNotEmpty) {
            try {
              final r = await dio.post('/api/auth/refresh-token', data: {'refreshToken': rt});
              final at = r.data['token'] as String;
              final nr = r.data['refreshToken'] as String;
              await store.save(at, nr);
              // Keep legacy store in sync for http-based clients
              final tp = TokenPair(
                token: at,
                tokenExpiresAt: r.data['tokenExpiresAt']?.toString(),
                refreshToken: nr,
                refreshTokenExpiresAt: r.data['refreshTokenExpiresAt']?.toString(),
              );
              await legacy.TokenStorage.updateTokens(tp);
              final req = error.requestOptions;
              req.headers['Authorization'] = 'Bearer $at';
              final clone = await dio.fetch(req);
              return handler.resolve(clone);
            } catch (_) {
              await store.clear();
              await legacy.TokenStorage.clear();
            }
          }
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}

