import 'dart:ui';
import 'package:crowwn/Home/videodata.dart';
import 'package:flutter/material.dart';
import 'package:crowwn/Home/videos_detaiils.dart';

class HomeVedioPage extends StatefulWidget {
  final String? driveApiKey;
  final String? driveFolderId;

  const HomeVedioPage({
    super.key,
    this.driveApiKey,
    this.driveFolderId,
  });

  @override
  State<HomeVedioPage> createState() => _HomeVedioPageState();
}

class _HomeVedioPageState extends State<HomeVedioPage> {
  List<VideoData> _videos = [];
  bool _isLoading = false;
  String? _error;

   static const courseThumbs = [
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829218/1ch_YouTube_Thumbnail_pq5w9i.jpg',
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829219/2ch_YouTube_Thumbnail_zwtmk8.jpg',
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829218/3ch_YouTube_Thumbnail_qaygbd.jpg',
      'https://res.cloudinary.com/deqwiyyxl/image/upload/v1764829218/4ch_YouTube_Thumbnail_egdp61.jpg',
    ];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }
  

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<VideoData> videos;

      if (widget.driveApiKey != null && widget.driveFolderId != null) {
        videos = await SimpleDriveService.fetchVideosFromDrive(
          apiKey: widget.driveApiKey!,
          folderId: widget.driveFolderId!,
        );
      } else {
        videos = SimpleDriveService.getConfiguredVideos();
      }

      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load videos: $e';
        _isLoading = false;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    // Calculate course count (10 videos per course)
    final int courseCount = (_videos.length / 10).ceil();

    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Class Videos",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _loadVideos,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("Refresh"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading videos...'),
                    ],
                  ),
                ),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 64, color: Color(0xFF8B0000)),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF8B0000)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadVideos,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_videos.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No videos available'),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Courses Section
                    const Text(
                      "Courses",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 270,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: courseCount,
                        itemBuilder: (context, index) {
                          return _buildHorizontalCourseCard(index, courseCount);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Vertical Video List
                    // const Text(
                    //   "All Videos",
                    //   style:
                    //       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 12),
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: _videos.length,
                    //     itemBuilder: (context, index) {
                    //       final video = _videos[index];
                    //       return _buildVerticalVideoCard(video, index);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCourseCard(int courseIndex, int courseCount) {
    // Calculate video range for this course
    final int start = courseIndex * 10;
    int end = start + 10;
    if (end > _videos.length) end = _videos.length;
    final videoCount = end - start;

    return GestureDetector(
      onTap: () {
        // Get the 10 videos for this course
        final courseVideos = _videos.sublist(start, end);

        // Navigate to course detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailPage(
              courseIndex: courseIndex,
              courseVideos: courseVideos.map((v) => v.url).toList(),
              courseVideoNames: courseVideos.map((v) => v.name).toList(),
              courseDescriptions:
                  courseVideos.map((v) => v.description).toList(),
              courseThumbnails:
                  courseVideos.map((v) => v.thumbnailUrl).toList(),
              courseDurations: courseVideos.map((v) => v.duration).toList(),
              allVideos: _videos.map((v) => v.url).toList(),
              allVideoNames: _videos.map((v) => v.name).toList(),
              allDescriptions: _videos.map((v) => v.description).toList(),
              allThumbnails: _videos.map((v) => v.thumbnailUrl).toList(),
              allDurations: _videos.map((v) => v.duration).toList(),
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    courseThumbs[courseIndex],
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 140,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF8B0000),
                              Color.fromARGB(255, 107, 2, 2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // // Play Button Overlay
                // Positioned.fill(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           Colors.transparent,
                //           Colors.black.withOpacity(0.3),
                //         ],
                //       ),
                //     ),
                //     child: Center(
                //       child: Container(
                //         width: 48,
                //         height: 48,
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           shape: BoxShape.circle,
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black.withOpacity(0.2),
                //               blurRadius: 12,
                //               offset: const Offset(0, 4),
                //             ),
                //           ],
                //         ),
                //         child: const Icon(
                //           Icons.play_arrow_rounded,
                //           color: Color(0xFFEF4444),
                //           size: 28,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // Course Number Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B0000),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B0000).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Course ${courseIndex + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Video Count Badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.video_library,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$videoCount',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course ${courseIndex + 1}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$videoCount video lectures',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B0000),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B0000).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Start Learning',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalVideoCard(VideoData video, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _openVideo(index),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    video.thumbnailUrl,
                    width: 100,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 75,
                        color: Colors.grey[300],
                        child: const Icon(Icons.video_library),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video.description,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video.duration,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_outline, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openVideo(int index) {
    final videos = _videos.map((v) => v.url).toList();
    final names = _videos.map((v) => v.name).toList();
    final descriptions = _videos.map((v) => v.description).toList();
    final thumbnails = _videos.map((v) => v.thumbnailUrl).toList();
    final durations = _videos.map((v) => v.duration).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          videoUrl: videos[index],
          allVideos: videos,
          videoNames: names,
          descriptions: descriptions,
          thumbnails: thumbnails,
          durations: durations,
        ),
      ),
    );
  }
}

// ==== Course Detail Page (Same as Classes Page) ====
class CourseDetailPage extends StatelessWidget {
  final int courseIndex;
  final List<String> courseVideos;
  final List<String> courseVideoNames;
  final List<String> courseDescriptions;
  final List<String> courseThumbnails;
  final List<String> courseDurations;
  final List<String> allVideos;
  final List<String> allVideoNames;
  final List<String> allDescriptions;
  final List<String> allThumbnails;
  final List<String> allDurations;

  const CourseDetailPage({
    super.key,
    required this.courseIndex,
    required this.courseVideos,
    required this.courseVideoNames,
    required this.courseDescriptions,
    required this.courseThumbnails,
    required this.courseDurations,
    required this.allVideos,
    required this.allVideoNames,
    required this.allDescriptions,
    required this.allThumbnails,
    required this.allDurations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Course ${courseIndex + 1}',
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: courseVideos.length,
        itemBuilder: (context, index) {
          final globalIndex = courseIndex * 10 + index;
          return _buildVideoCard(
            context,
            title: courseVideoNames[index],
            description: courseDescriptions[index],
            videoUrl: courseVideos[index],
            thumbnail: courseThumbnails[index],
            duration: courseDurations[index],
            index: globalIndex + 1,
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context, {
    required String title,
    required String description,
    required String videoUrl,
    required String thumbnail,
    required String duration,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        if (videoUrl.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(
                videoUrl: videoUrl,
                allVideos: allVideos,
                videoNames: allVideoNames,
                descriptions: allDescriptions,
                thumbnails: allThumbnails,
                durations: allDurations,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    thumbnail,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF8B0000),
                              Color.fromARGB(255, 66, 1, 1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xFF8B0000),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B0000),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B0000).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Lecture $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              duration,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      height: 1.3,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B0000),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B0000).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Watch',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B0000).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
