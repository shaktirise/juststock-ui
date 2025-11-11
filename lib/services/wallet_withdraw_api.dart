import 'package:dio/dio.dart';

class WalletWithdrawApi {
  final Dio dio;
  WalletWithdrawApi(this.dio);

  Future<Map<String, dynamic>> createWithdrawalUpi({
    required int amountInRupees,
    required String upiId,
    required String name,
    required String mobile,
    String? note,
  }) async {
    final r = await dio.post('/api/wallet/withdrawals', data: {
      'amountInRupees': amountInRupees,
      'method': 'UPI',
      'upiId': upiId,
      'name': name,
      'mobile': mobile,
      if (note != null) 'note': note,
    });
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> createWithdrawalBank({
    required int amountInRupees,
    required String bankAccountName,
    required String bankAccountNumber,
    required String bankIfsc,
    required String bankName,
    required String name,
    required String mobile,
    String? note,
  }) async {
    final r = await dio.post('/api/wallet/withdrawals', data: {
      'amountInRupees': amountInRupees,
      'method': 'BANK',
      'bankAccountName': bankAccountName,
      'bankAccountNumber': bankAccountNumber,
      'bankIfsc': bankIfsc,
      'bankName': bankName,
      'name': name,
      'mobile': mobile,
      if (note != null) 'note': note,
    });
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<List<dynamic>> myWithdrawals() async {
    final r = await dio.get('/api/wallet/withdrawals');
    final raw = r.data;
    if (raw is List) return raw;
    if (raw is Map<String, dynamic>) {
      if (raw['items'] is List) return (raw['items'] as List).toList();
      if (raw['data'] is List) return (raw['data'] as List).toList();
    }
    return const [];
  }
}

