import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';
import 'token_storage.dart';

class WalletApi {
  static const String baseUrl = AuthApi.baseUrl;
  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<Map<String, dynamic>> createOrder({
    required int amountInRupees,
  }) async {
    final headers = await TokenStorage.authHeaders(extra: const {'Content-Type': 'application/json'});
    final res = await http.post(
      _uri('/api/wallet/topups/create-order'),
      headers: headers,
      body: jsonEncode({'amountInRupees': amountInRupees}),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<Map<String, dynamic>> verify({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final headers = await TokenStorage.authHeaders(extra: const {'Content-Type': 'application/json'});
    final res = await http.post(
      _uri('/api/wallet/topups/verify'),
      headers: headers,
      body: jsonEncode({
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      }),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<int> getBalancePaise() async {
    final headers = await TokenStorage.authHeaders();
    final res = await http.get(
      _uri('/api/wallet/balance'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['balancePaise'] as num?)?.toInt() ?? 0;
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

