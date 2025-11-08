import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';
import 'token_storage.dart';

class WalletHistoryItem {
  final String id;
  final DateTime createdAt;
  final int amountPaise; // debits should be negative
  final String? note;
  final String? title;
  final String? category;

  const WalletHistoryItem({
    required this.id,
    required this.createdAt,
    required this.amountPaise,
    this.note,
    this.title,
    this.category,
  });

  static WalletHistoryItem fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    final created = DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now();
    // Amount could come in various fields
    int paise = (json['amountPaise'] as num?)?.toInt() ??
        (json['amountInPaise'] as num?)?.toInt() ??
        (json['amount'] as num?)?.toInt() ??
        (((json['amountInRupees'] as num?)?.toDouble() ?? 0) * 100).toInt();
    // History endpoint lists debits. Ensure negative sign for debits when missing
    final isDebit = (json['type']?.toString().toUpperCase() == 'DEBIT') || (json['debit'] == true) || json.containsKey('call');
    if (isDebit && paise > 0) paise = -paise;
    return WalletHistoryItem(
      id: id,
      createdAt: created,
      amountPaise: paise,
      note: json['note']?.toString(),
      title: json['title']?.toString() ?? (json['call'] is Map ? (json['call']['title']?.toString()) : null),
      category: json['category']?.toString() ?? (json['call'] is Map ? (json['call']['category']?.toString()) : null),
    );
  }
}

class WalletApi {
  static const String baseUrl = AuthApi.baseUrl;
  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<Map<String, dynamic>> createOrder({
    required int amountInRupees,
  }) async {
    final headers = await TokenStorage.authHeaders(extra: const {'Content-Type': 'application/json'});
    final paise = amountInRupees * 100;
    final body = {
      'amountInRupees': amountInRupees,
      'amountInPaise': paise,
      'amount': paise,
      'currency': 'INR',
    };
    final res = await http
        .post(
          _uri('/api/wallet/topups/create-order'),
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 25));
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<Map<String, dynamic>> verify({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required int amountInRupees,
    String currency = 'INR',
  }) async {
    final headers = await TokenStorage.authHeaders(extra: const {'Content-Type': 'application/json'});
    final paise = amountInRupees * 100;
    final body = {
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
      'amountInRupees': amountInRupees,
      'amountInPaise': paise,
      'amount': paise,
      'currency': currency,
    };
    final res = await http
        .post(
          _uri('/api/wallet/topups/verify'),
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<int> getBalancePaise() async {
    final headers = await TokenStorage.authHeaders();
    final res = await http
        .get(
          _uri('/api/wallet/balance'),
          headers: headers,
        )
        .timeout(const Duration(seconds: 20));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['balancePaise'] as num?)?.toInt() ?? 0;
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<Map<String, dynamic>> debit({
    required int amountInRupees,
    String? note,
  }) async {
    final headers = await TokenStorage.authHeaders(extra: const {'Content-Type': 'application/json'});
    final body = {
      'amountInRupees': amountInRupees,
      if (note != null) 'note': note,
    };
    final res = await http
        .post(
          _uri('/api/wallet/debit'),
          headers: headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 20));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  /// Returns purchase history (debits). Falls back gracefully for varying shapes.
  static Future<List<WalletHistoryItem>> history({int page = 1, int limit = 20}) async {
    final headers = await TokenStorage.authHeaders(extra: const {'Accept': 'application/json'});
    final uri = _uri('/api/wallet/history?page=$page&limit=$limit');
    final res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 20));
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      List list;
      if (decoded is Map<String, dynamic> && decoded['items'] is List) {
        list = decoded['items'] as List;
      } else if (decoded is List) {
        list = decoded;
      } else {
        list = const [];
      }
      return list
          .map((e) => (e is Map<String, dynamic>) ? e : (e as Map).cast<String, dynamic>())
          .map(WalletHistoryItem.fromJson)
          .toList();
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  /// Attempts to call unified ledger if available. If 404/Not found, returns
  /// debits from [history]. In the ledger shape, credits should be positive and
  /// debits negative.
  static Future<List<WalletHistoryItem>> ledgerOrHistory({int page = 1, int limit = 25}) async {
    try {
      final headers = await TokenStorage.authHeaders(extra: const {'Accept': 'application/json'});
      final uri = _uri('/api/wallet/ledger?page=$page&limit=$limit');
      final res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        List list;
        if (decoded is Map<String, dynamic> && decoded['items'] is List) {
          list = decoded['items'] as List;
        } else if (decoded is List) {
          list = decoded;
        } else {
          list = const [];
        }
        return list
            .map((e) => (e is Map<String, dynamic>) ? e : (e as Map).cast<String, dynamic>())
            .map((m) {
          // For ledger, expect explicit sign. Keep as is.
          int paise = (m['amountPaise'] as num?)?.toInt() ??
              (m['amountInPaise'] as num?)?.toInt() ??
              (m['amount'] as num?)?.toInt() ??
              (((m['amountInRupees'] as num?)?.toDouble() ?? 0) * 100).toInt();
          // If type provided, adjust sign consistent with DEBIT negative
          final type = m['type']?.toString().toUpperCase();
          if (type == 'DEBIT' && paise > 0) paise = -paise;
          final created = DateTime.tryParse(m['createdAt']?.toString() ?? '') ?? DateTime.now();
          return WalletHistoryItem(
            id: m['id']?.toString() ?? m['_id']?.toString() ?? '',
            createdAt: created,
            amountPaise: paise,
            note: m['note']?.toString(),
            title: m['title']?.toString() ?? (m['call'] is Map ? (m['call']['title']?.toString()) : null),
            category: m['category']?.toString() ?? (m['call'] is Map ? (m['call']['category']?.toString()) : null),
          );
        }).toList();
      }
      // If endpoint missing or unauthorized, fall back
      throw HttpException(statusCode: res.statusCode, message: _extractError(res));
    } catch (_) {
      return history(page: page, limit: limit);
    }
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
