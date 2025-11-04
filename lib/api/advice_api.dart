import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';
import 'token_storage.dart';

class AdviceApi {
  static const String baseUrl = AuthApi.baseUrl;
  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static String normalizeCategory(String category) {
    final c = category.toLowerCase();
    if (c == 'stock' || c == 'stocks') return 'stocks';
    if (c == 'option' || c == 'options') return 'options';
    if (c == 'futures' || c == 'future') return 'future';
    if (c == 'commodity' || c == 'comodity') return 'commodity';
    return c;
  }

  static Future<List<AdviceMeta>> list({
    required String category,
    int page = 1,
    int limit = 20,
  }) async {
    final cat = normalizeCategory(category);
    final headers = await TokenStorage.authHeaders();
    final uri = _uri('/api/advice-v2?category=$cat&page=$page&limit=$limit');
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final items = (data as List).cast<dynamic>();
      return items.map((e) => AdviceMeta.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<AdviceMeta?> latest({required String category}) async {
    final cat = normalizeCategory(category);
    final headers = await TokenStorage.authHeaders();
    final res = await http.get(_uri('/api/advice-v2/$cat/latest'), headers: headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final obj = data['advice'];
      if (obj == null) return null;
      return AdviceMeta.fromJson(obj as Map<String, dynamic>);
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<AdviceUnlocked> unlockById(String id) async {
    final headers = await TokenStorage.authHeaders(extra: const {'Content-Type': 'application/json'});
    final res = await http.post(_uri('/api/advice-v2/$id/unlock'), headers: headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return AdviceUnlocked.fromJson(data);
    }
    if (res.statusCode == 402) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      throw PaymentRequiredException(message: data['error']?.toString() ?? 'INSUFFICIENT_FUNDS');
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<AdviceUnlocked> unlockLatest(String category) async {
    final cat = normalizeCategory(category);
    final headers = await TokenStorage.authHeaders();
    final res = await http.post(_uri('/api/advice-v2/$cat/unlock-latest'), headers: headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return AdviceUnlocked.fromJson(data);
    }
    if (res.statusCode == 402) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      throw PaymentRequiredException(message: data['error']?.toString() ?? 'INSUFFICIENT_FUNDS');
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
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

class AdviceMeta {
  final String id;
  final String category;
  final DateTime createdAt;
  final num price;
  AdviceMeta({required this.id, required this.category, required this.createdAt, required this.price});
  factory AdviceMeta.fromJson(Map<String, dynamic> json) => AdviceMeta(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
        price: json['price'] ?? 0,
      );
}

class AdviceUnlocked {
  final AdviceDetail advice;
  final num? walletBalance;
  final int? walletBalancePaise;
  final num? walletBalanceRupees;
  AdviceUnlocked({required this.advice, this.walletBalance, this.walletBalancePaise, this.walletBalanceRupees});
  factory AdviceUnlocked.fromJson(Map<String, dynamic> json) => AdviceUnlocked(
        advice: AdviceDetail.fromJson(json['advice'] as Map<String, dynamic>),
        walletBalance: json['walletBalance'] as num?,
        walletBalancePaise: (json['walletBalancePaise'] as num?)?.toInt(),
        walletBalanceRupees: json['walletBalanceRupees'] as num?,
      );
}

class AdviceDetail {
  final String id;
  final String category;
  final String? text;
  final String? buy;
  final String? target;
  final String? stoploss;
  final num? price;
  final DateTime? createdAt;
  AdviceDetail({
    required this.id,
    required this.category,
    this.text,
    this.buy,
    this.target,
    this.stoploss,
    this.price,
    this.createdAt,
  });
  factory AdviceDetail.fromJson(Map<String, dynamic> json) => AdviceDetail(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        text: json['text']?.toString(),
        buy: json['buy']?.toString(),
        target: json['target']?.toString(),
        stoploss: json['stoploss']?.toString(),
        price: json['price'] as num?,
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      );
}

class HttpException implements Exception {
  final int statusCode;
  final String message;
  HttpException({required this.statusCode, required this.message});
  @override
  String toString() => 'HttpException($statusCode): $message';
}

class PaymentRequiredException implements Exception {
  final String message;
  PaymentRequiredException({required this.message});
  @override
  String toString() => 'PaymentRequired: $message';
}

