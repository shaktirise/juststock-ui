import 'package:dio/dio.dart';
import 'api_config.dart';
import 'token_store.dart';

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
        final token = await store.access;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final status = error.response?.statusCode;
        if (status == 401) {
          final rt = await store.refresh;
          if (rt != null && rt.isNotEmpty) {
            try {
              final r = await dio.post('/api/auth/refresh-token', data: {'refreshToken': rt});
              final at = r.data['token'] as String;
              final nr = r.data['refreshToken'] as String;
              await store.save(at, nr);
              final req = error.requestOptions;
              req.headers['Authorization'] = 'Bearer $at';
              final clone = await dio.fetch(req);
              return handler.resolve(clone);
            } catch (_) {
              await store.clear();
            }
          }
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}

