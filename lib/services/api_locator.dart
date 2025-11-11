import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'token_store.dart';
import 'auth_api_v2.dart';
import 'user_api_v2.dart';
import 'referral_api.dart';
import 'wallet_withdraw_api.dart';

/// Simple global locator for API singletons.
class ApiLocator {
  static late final TokenStore tokenStore;
  static late final Dio dio;
  static late final AuthApiV2 auth;
  static late final UserApiV2 user;
  static late final ReferralApi referral;
  static late final WalletWithdrawApi wallet;

  static bool _inited = false;

  static Future<void> init() async {
    if (_inited) return;
    tokenStore = TokenStore();
    dio = createDio(tokenStore);
    auth = AuthApiV2(dio, tokenStore);
    user = UserApiV2(dio);
    referral = ReferralApi(dio);
    wallet = WalletWithdrawApi(dio);
    _inited = true;
  }
}
