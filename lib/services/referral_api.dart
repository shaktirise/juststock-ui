import 'package:dio/dio.dart';

num rupees(int paise) => paise / 100;

class ReferralApi {
  final Dio dio;
  ReferralApi(this.dio);

  Future<List<dynamic>> tree({int depth = 10}) async {
    try {
      final r = await dio.get('/api/auth/referrals/tree', queryParameters: {'depth': depth});
      List<dynamic> levels = const [];
      final raw = r.data;
      if (raw is List) {
        levels = raw;
      } else if (raw is Map) {
        final data = raw.cast<String, dynamic>();
        if (data['levels'] is List) levels = (data['levels'] as List).toList();
        else if (data['items'] is List) levels = (data['items'] as List).toList();
        else if (data['data'] is List) levels = (data['data'] as List).toList();
      }
      if (levels.isEmpty) {
        try {
          final l1 = await listL1(limit: 100);
          final items = (l1['items'] as List?) ?? const [];
          if (items.isNotEmpty) {
            return [
              {
                'level': 1,
                'users': items,
              }
            ];
          }
        } catch (_) {}
      }
      return levels;
    } catch (_) {
      try {
        final l1 = await listL1(limit: 100);
        final items = (l1['items'] as List?) ?? const [];
        if (items.isNotEmpty) {
          return [
            {
              'level': 1,
              'users': items,
            }
          ];
        }
      } catch (_) {}
      return const [];
    }
  }

  Future<Map<String, dynamic>> earnings() async {
    try {
      final r = await dio.get('/api/auth/referrals/earnings');
      final raw = r.data;
      Map<String, dynamic> map;
      if (raw is Map) {
        map = raw.cast<String, dynamic>();
      } else {
        map = {'totalEarnedPaise': 0, 'totalPaidPaise': 0, 'totalPendingPaise': 0};
      }
      if (!map.containsKey('entries')) {
        final items = map['items'];
        if (items is List) map['entries'] = items;
      }
      if (map.containsKey('totalEarned') && !map.containsKey('totalEarnedPaise')) {
        final v = map['totalEarned'];
        if (v is num) map['totalEarnedPaise'] = (v * 100).round();
      }
      if (map.containsKey('totalPaid') && !map.containsKey('totalPaidPaise')) {
        final v = map['totalPaid'];
        if (v is num) map['totalPaidPaise'] = (v * 100).round();
      }
      if (map.containsKey('totalPending') && !map.containsKey('totalPendingPaise')) {
        final v = map['totalPending'];
        if (v is num) map['totalPendingPaise'] = (v * 100).round();
      }
      return map;
    } catch (_) {
      return {'totalEarnedPaise': 0, 'totalPaidPaise': 0, 'totalPendingPaise': 0, 'entries': const []};
    }
  }

  Future<Map<String, dynamic>> listL1({int limit = 50, int offset = 0}) async {
    final r = await dio.get('/api/auth/referrals', queryParameters: {
      'limit': limit,
      'offset': offset,
    });
    final raw = r.data;
    if (raw is Map) return raw.cast<String, dynamic>();
    if (raw is List) return {'items': raw};
    return {'items': const []};
  }

  Future<Map<String, dynamic>> config() async {
    try {
      final r = await dio.get('/api/auth/referrals/config');
      final raw = r.data;
      if (raw is Map) return raw.cast<String, dynamic>();
      return const {};
    } catch (_) {
      return const {};
    }
  }

  /// Non-paid referrals (pending activation)
  Future<Map<String, dynamic>> pending({int limit = 50, int offset = 0}) async {
    try {
      final r = await dio.get('/api/auth/referrals/pending', queryParameters: {
        'limit': limit,
        'offset': offset,
      });
      final raw = r.data;
      if (raw is Map) return raw.cast<String, dynamic>();
      if (raw is List) return {'items': raw, 'total': raw.length, 'offset': offset, 'limit': limit};
      return {'items': const [], 'total': 0, 'offset': offset, 'limit': limit};
    } catch (_) {
      return {'items': const [], 'total': 0, 'offset': offset, 'limit': limit};
    }
  }

  /// Activated referrals
  Future<Map<String, dynamic>> active({int limit = 50, int offset = 0}) async {
    try {
      final r = await dio.get('/api/auth/referrals/active', queryParameters: {
        'limit': limit,
        'offset': offset,
      });
      final raw = r.data;
      if (raw is Map) return raw.cast<String, dynamic>();
      if (raw is List) return {'items': raw, 'total': raw.length, 'offset': offset, 'limit': limit};
      return {'items': const [], 'total': 0, 'offset': offset, 'limit': limit};
    } catch (_) {
      return {'items': const [], 'total': 0, 'offset': offset, 'limit': limit};
    }
  }

  Future<Map<String, dynamic>> requestWithdraw({String? note}) async {
    try {
      final r = await dio.post('/api/auth/referrals/withdraw', data: {
        if (note != null) 'note': note,
      });
      return (r.data as Map).cast<String, dynamic>();
    } catch (_) {
      return const {'ok': false};
    }
  }

  Future<Map<String, dynamic>> requestWithdrawUpi({
    required String upiId,
    String? name,
    String? mobile,
    String? note,
  }) async {
    final r = await dio.post('/api/auth/referrals/withdraw', data: {
      'method': 'UPI',
      'upiId': upiId,
      if (name != null && name.isNotEmpty) 'name': name,
      if (mobile != null && mobile.isNotEmpty) 'mobile': mobile,
      if (note != null) 'note': note,
    });
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> requestWithdrawBank({
    required String bankAccountName,
    required String bankAccountNumber,
    required String bankIfsc,
    required String bankName,
    String? contactName,
    String? contactMobile,
    String? note,
  }) async {
    final r = await dio.post('/api/auth/referrals/withdraw', data: {
      'method': 'BANK',
      'bankAccountName': bankAccountName,
      'bankAccountNumber': bankAccountNumber,
      'bankIfsc': bankIfsc,
      'bankName': bankName,
      if (contactName != null && contactName.isNotEmpty) 'contactName': contactName,
      if (contactMobile != null && contactMobile.isNotEmpty) 'contactMobile': contactMobile,
      if (note != null) 'note': note,
    });
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<List<dynamic>> withdrawals() async {
    try {
      final r = await dio.get('/api/auth/referrals/withdrawals');
      final raw = r.data;
      if (raw is List) return raw;
      if (raw is Map<String, dynamic>) {
        if (raw['items'] is List) return (raw['items'] as List).toList();
        if (raw['data'] is List) return (raw['data'] as List).toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }
}
