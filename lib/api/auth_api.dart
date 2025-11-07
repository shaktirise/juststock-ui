import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_config.dart';

class AuthApi {
  static const String baseUrl = ApiConfig.apiBaseUrl;

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<AuthResponse> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
    String? referralCode,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
    // Normalize optional Indian phone. 10 digits -> +91XXXXXXXXXX
    if (phone != null) {
      final p = phone.trim();
      if (p.isNotEmpty) {
        final onlyDigits = RegExp(r'^\d{10}$');

        final withCode = RegExp(r'^\+91\d{10}$');

        String normalized = p;
        if (onlyDigits.hasMatch(p)) {
          normalized = '+91$p';
        }
        body['phone'] = normalized;
      }
    }
    if (referralCode != null && referralCode.trim().isNotEmpty) {
      body['referralCode'] = referralCode.trim();
    }

    final res = await http.post(
      _uri('/api/auth/signup'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _handleAuthResponse(res);
  }

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      _uri('/api/auth/login'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleAuthResponse(res);
  }

  static Future<TokenPair> refreshToken({
    required String refreshToken,
  }) async {
    final res = await http.post(
      _uri('/api/auth/refresh-token'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return TokenPair(
        token: data['token'] as String,
        tokenExpiresAt: data['tokenExpiresAt']?.toString(),
        refreshToken: data['refreshToken'] as String,
        refreshTokenExpiresAt: data['refreshTokenExpiresAt']?.toString(),
      );
    }

    throw HttpException(
      statusCode: res.statusCode,
      message: _extractError(res),
    );
  }

  static AuthResponse _handleAuthResponse(http.Response res) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return AuthResponse(
        token: data['token'] as String,
        tokenExpiresAt: data['tokenExpiresAt']?.toString(),
        refreshToken: data['refreshToken'] as String,
        refreshTokenExpiresAt: data['refreshTokenExpiresAt']?.toString(),
        user: data['user'] as Map<String, dynamic>?,
      );
    }

    throw HttpException(
      statusCode: res.statusCode,
      message: _extractError(res),
    );
  }

  static String _extractError(http.Response res) {
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message']?.toString() ?? decoded['error']?.toString() ?? 'Request failed (${res.statusCode})';
      }
      return decoded.toString();
    } catch (_) {
      return 'Request failed (${res.statusCode})';
    }
  }
}

class AuthResponse extends TokenPair {
  final Map<String, dynamic>? user;
  AuthResponse({
    required super.token,
    required super.tokenExpiresAt,
    required super.refreshToken,
    required super.refreshTokenExpiresAt,
    this.user,
  });
}

class TokenPair {
  final String token;
  final String? tokenExpiresAt;
  final String refreshToken;
  final String? refreshTokenExpiresAt;

  TokenPair({
    required this.token,
    required this.tokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
  });
}

class HttpException implements Exception {
  final int statusCode;
  final String message;
  HttpException({required this.statusCode, required this.message});
  @override
  String toString() => 'HttpException($statusCode): $message';
}
