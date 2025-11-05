import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage using flutter_secure_storage.
class TokenStore {
  final FlutterSecureStorage _storage;

  const TokenStore._(this._storage);

  factory TokenStore() => TokenStore._(const FlutterSecureStorage());

  static const _kAccess = 'accessToken';
  static const _kRefresh = 'refreshToken';

  Future<void> save(String accessToken, String refreshToken) async {
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
  }

  Future<String?> get access async => _storage.read(key: _kAccess);
  Future<String?> get refresh async => _storage.read(key: _kRefresh);

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}

