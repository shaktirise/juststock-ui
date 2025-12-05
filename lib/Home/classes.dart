import 'dart:ui';

import 'package:crowwn/DailyTip/daily_tip_page.dart';
import 'package:crowwn/Dark%20mode.dart';
import 'package:crowwn/Home/videodata.dart';
import 'package:crowwn/Home/videos_detaiils.dart';
import 'package:crowwn/Message%20&%20Notification/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const String _telegramUrl = 'https://t.me/justock8';
  ColorNotifire notifier = ColorNotifire();

  final List<String> _bannerImages = [
    'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800',
    'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?w=800',
    'https://images.unsplash.com/photo-1535320903710-d993d3d77d29?w=800',
  ];

  late List<VideoData> driveVideos;
  late List<String> videos;
  late List<String> thumbnails;
  late List<String> videoNames;
  late List<String> descriptions;
  late List<String> durations;

  int expandedCourseIndex = -1;

  @override
  void initState() {
    super.initState();

    driveVideos = SimpleDriveService.getConfiguredVideos();
    videos = driveVideos.map((v) => v.url).toList();
    thumbnails = driveVideos.map((v) => v.thumbnailUrl).toList();
    videoNames = driveVideos.map((v) => v.name).toList();
    descriptions = driveVideos.map((v) => v.description).toList();
    durations = driveVideos.map((v) => v.duration).toList();

    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (!mounted) return;

    setState(() {
      _currentPage = (_currentPage + 1) % _bannerImages.length;
    });

    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openTelegram() async {
    final uri = Uri.parse(_telegramUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final int courseCount = (videos.length / 10).ceil();
    notifier = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      backgroundColor: notifier.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: Row(
              children: [
                Image.asset(
                  'lib/assets/inside-logo.png',
                  width: 130,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF229ED9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: 'Telegram',
                  onPressed: _openTelegram,
                  icon: const FaIcon(
                    FontAwesomeIcons.telegram,
                    color: Color(0xFF229ED9),
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: 'Daily Tip',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DailyTipPage()),
                    );
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.lightbulb,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  tooltip: 'Notifications',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notifications(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    "assets/images/notification.png",
                    height: 20,
                    width: 20,
                    color: const Color(0xFF8B0000),
                  ),
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Enhanced Banner Slider
                Container(
                  height: 200,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: _bannerImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF8B0000).withOpacity(0.3),
                                  blurRadius: 25,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    _bannerImages[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF8B0000),
                                              Color(0xFF5A0000),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.play_circle_outline,
                                            size: 70,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _bannerImages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                boxShadow: _currentPage == index
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B0000),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'My Classes',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 4, 20, 20),
                  child: Text(
                    '${courseCount} courses available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // ==== Vertical Courses List ====
                for (int i = 0; i < courseCount; i++)
                  _buildCourseCard(
                    context,
                    courseIndex: i,
                    courseCount: courseCount,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required int courseIndex,
    required int courseCount,
  }) {
    // Calculate video range for this course
    final int start = courseIndex * 10;
    int end = start + 10;
    if (end > videos.length) end = videos.length;
    final videoCount = end - start;
    final courseThumbnails = thumbnails.sublist(start, end);
    final courseThumbnail = courseThumbnails.isNotEmpty
        ? courseThumbnails.first
        : 'https://picsum.photos/seed/course$courseIndex/1200/800';

    return Container(
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
          // Thumbnail Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  courseThumbnail,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF8B0000),
                            Color(0xFF5A0000),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 60,
                          color: Colors.white,
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
              //         width: 56,
              //         height: 56,
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
              //           color: Color(0xFF8B0000),
              //           size: 32,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Course Number Badge
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
                    'Course ${courseIndex + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Video Count Badge
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
                            Icons.video_library,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$videoCount videos',
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

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course ${courseIndex + 1}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete course with $videoCount video lectures',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    // Get the 10 videos for this course
                    final courseVideos = videos.sublist(start, end);
                    final courseVideoNames = videoNames.sublist(start, end);
                    final courseDescriptions = descriptions.sublist(start, end);
                    final courseThumbnails = thumbnails.sublist(start, end);
                    final courseDurations = durations.sublist(start, end);

                    // Navigate to course detail page showing 10 videos
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(
                          courseIndex: courseIndex,
                          courseVideos: courseVideos,
                          courseVideoNames: courseVideoNames,
                          courseDescriptions: courseDescriptions,
                          courseThumbnails: courseThumbnails,
                          courseDurations: courseDurations,
                          allVideos: videos,
                          allVideoNames: videoNames,
                          allDescriptions: descriptions,
                          allThumbnails: thumbnails,
                          allDurations: durations,
                        ),
                      ),
                    );
                  },
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
                        'Start Learning',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==== Course Detail Page showing 10 videos ====
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
    return Container(
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
                            Color(0xFF5A0000),
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
                GestureDetector(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
