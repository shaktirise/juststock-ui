import 'package:googleapis_auth/auth_io.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoData {
  final String id;
  final String name;
  final String url;
  final String thumbnailUrl;
  final String description;
  final String duration;

  VideoData({
    required this.id,
    required this.name,
    required this.url,
    required this.thumbnailUrl,
    required this.description,
    required this.duration,
  });

  factory VideoData.fromDriveId({
    required String fileId,
    required String name,
    required String description,
    required String duration,
  }) {
    return VideoData(
      id: fileId,
      name: name,
      url: 'https://drive.google.com/uc?export=download&id=$fileId',
      thumbnailUrl:
          'https://drive.google.com/thumbnail?id=$fileId&sz=w400-h300',
      description: description,
      duration: duration,
    );
  }
}

class SimpleDriveService {
  // Method 1: Manual Configuration (Easiest)
  static List<VideoData> getConfiguredVideos() {
    const baseUrl = 'https://juststock.in/assets/videos';
    // Course-level thumbnails (one per course)
    const courseThumbs = [
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829218/1ch_YouTube_Thumbnail_pq5w9i.jpg',
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829219/2ch_YouTube_Thumbnail_zwtmk8.jpg',
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829218/3ch_YouTube_Thumbnail_qaygbd.jpg',
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829218/4ch_YouTube_Thumbnail_egdp61.jpg',
    ];

    return List.generate(40, (index) {
      final number = index + 1;
      final courseIndex = (index ~/ 10) % courseThumbs.length;
      return VideoData(
        id: 'video_$number',
        name: 'Lecture $number',
        url: '$baseUrl/$number.mp4',
        thumbnailUrl: courseThumbs[courseIndex],
        description: 'JustStock lesson $number',
        duration: '--:--',
      );
    });
  }

  // Method 2: Fetch from Google Drive API (requires API key)
  static Future<List<VideoData>> fetchVideosFromDrive({
    required String apiKey,
    required String folderId,
  }) async {
    try {
      final url = Uri.parse(
        'https://www.googleapis.com/drive/v3/files?'
        'q="$folderId"+in+parents+and+mimeType+contains+"video/"&'
        'key=$apiKey&'
        'fields=files(id,name,mimeType,thumbnailLink,videoMediaMetadata,description)',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final files = data['files'] as List;

        return files.map((file) {
          final durationMillis = file['videoMediaMetadata']?['durationMillis'];
          final duration = durationMillis != null
              ? _formatDuration(int.parse(durationMillis.toString()))
              : '00:00';

          return VideoData(
            id: file['id'],
            name: file['name'] ?? 'Untitled Video',
            url: 'https://drive.google.com/uc?export=download&id=${file['id']}',
            thumbnailUrl: file['thumbnailLink'] ?? '',
            description: file['description'] ?? 'No description',
            duration: duration,
          );
        }).toList();
      } else {
        throw Exception('Failed to load videos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      return [];
    }
  }

  static String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
