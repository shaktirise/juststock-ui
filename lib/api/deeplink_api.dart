class DeepLinkApi {
  /// Returns a map with keys: shareUrl, appUrl, payload
  /// Local-only implementation to ensure JustStock domain is shared.
  static Future<Map<String, dynamic>> createReferral(String refCode) async {
    final code = refCode.trim();
    final share = code.isNotEmpty
        ? 'https://juststock.vercel.app/${Uri.encodeComponent(code)}'
        : 'https://juststock.vercel.app';
    return {
      'shareUrl': share,
      'appUrl': share,
      'payload': {'referralCode': code},
    };
  }
}
