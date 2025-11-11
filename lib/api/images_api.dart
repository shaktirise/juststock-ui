import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_config.dart';

class ImagesApi {
  static const String baseUrl = ApiConfig.apiBaseUrl;
  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<List<CloudImage>> list({int limit = 5}) async {
    if (limit < 1) limit = 1;
    if (limit > 200) limit = 200;
    final uri = _uri('/api/images?limit=$limit');
    final res = await http.get(uri, headers: const {'Accept': 'application/json'});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final items = (data is Map && data['items'] is List)
          ? (data['items'] as List)
          : (data is List ? data : const <dynamic>[]);
      return items
          .map((e) => CloudImage.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }
    // Swallow errors; return empty for robustness on home
    return const <CloudImage>[];
  }
}

class CloudImage {
  final String id;
  final String url;
  final int? width;
  final int? height;
  final String? format;
  final String? folder;
  final DateTime? createdAt;

  const CloudImage({
    required this.id,
    required this.url,
    this.width,
    this.height,
    this.format,
    this.folder,
    this.createdAt,
  });

  factory CloudImage.fromJson(Map<String, dynamic> json) => CloudImage(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
        width: (json['width'] as num?)?.toInt(),
        height: (json['height'] as num?)?.toInt(),
        format: json['format']?.toString(),
        folder: json['folder']?.toString(),
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      );
}

