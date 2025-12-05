import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final List<String> allVideos;
  final List<String> videoNames;
  final List<String> descriptions;
  final List<String> thumbnails;
  final List<String> durations;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.allVideos,
    required this.videoNames,
    required this.descriptions,
    required this.thumbnails,
    this.durations = const [],
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  late String currentVideo;
  int currentIndex = 0;
  Timer? _progressTimer;
  Timer? _controlsHideTimer;
  bool _showError = false;
  Duration currentPosition = Duration.zero;
  bool _showControls = true;
  static const _controlsHideDelay = Duration(seconds: 3);

  // Theme colors
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color lightRed = Color(0xFFFFEBEE);
  static const Color darkRed = Color(0xFFB71C1C);
  static const Color backgroundColor = Colors.white;
  static const Color cardBackground = Color(0xFFFAFAFA);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  bool get _isFirstVideo => currentIndex <= 0;
  bool get _isLastVideo => currentIndex >= widget.allVideos.length - 1;

  @override
  void initState() {
    super.initState();
    currentVideo = widget.videoUrl;
    currentIndex = widget.allVideos.indexOf(currentVideo);
    if (currentIndex < 0 && widget.allVideos.isNotEmpty) {
      currentIndex = 0;
      currentVideo = widget.allVideos[0];
    }
    _loadVideo(currentVideo);

    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_controller != null && _controller!.value.isInitialized) {
        setState(() {
          currentPosition = _controller!.value.position;
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _controlsHideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadVideo(String url) async {
    _controlsHideTimer?.cancel();
    _showControls = true;
    _showError = false;
    currentPosition = Duration.zero;
    await _controller?.dispose();
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await _controller!.initialize();
      await _controller!.play();
      setState(() {});
      _restartHideTimer();
    } catch (e) {
      setState(() => _showError = true);
    }
    _controller?.addListener(() {
      if (!mounted) return;
      if (_controller!.value.isInitialized &&
          _controller!.value.position >= _controller!.value.duration &&
          currentIndex < widget.allVideos.length - 1) {
        _playNextVideo();
      }
      setState(() {});
    });
  }

  void _playNextVideo() {
    if (currentIndex < widget.allVideos.length - 1) {
      _onUserInteraction();
      currentIndex++;
      currentVideo = widget.allVideos[currentIndex];
      _loadVideo(currentVideo);
    }
  }

  void _playPreviousVideo() {
    if (currentIndex > 0) {
      _onUserInteraction();
      currentIndex--;
      currentVideo = widget.allVideos[currentIndex];
      _loadVideo(currentVideo);
    }
  }

  void togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    _onUserInteraction();
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    setState(() {});
  }

  void goFullScreen() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    _onUserInteraction();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideo(
          videoController: _controller,
          themeColor: primaryRed,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  void _onScreenTap() {
    setState(() => _showControls = true);
    _restartHideTimer();
  }

  void _onUserInteraction() {
    if (!_showControls) {
      setState(() => _showControls = true);
    }
    _restartHideTimer();
  }

  void _restartHideTimer() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(_controlsHideDelay, () {
      if (!mounted) return;
      setState(() => _showControls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = _controller?.value.duration ?? Duration.zero;
    double progress = 0.0;
    if (totalDuration.inMilliseconds > 0) {
      progress = currentPosition.inMilliseconds / totalDuration.inMilliseconds;
    }
    final isReady = _controller?.value.isInitialized ?? false;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Video Player Section
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onScreenTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 240,
                  margin: const EdgeInsets.only(top: 50),
                  width: double.infinity,
                  color: Colors.black,
                  child: _showError
                      ? Container(
                          color: Colors.black87,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline,
                                    color: primaryRed, size: 52),
                                const SizedBox(height: 12),
                                Text(
                                  'Failed to load video',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _loadVideo(currentVideo),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryRed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  icon: const Icon(Icons.refresh, size: 20),
                                  label: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : isReady
                          ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            )
                          : Container(
                              color: Colors.black87,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      color: primaryRed,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Loading video...',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ),

                // Back button at top left
                Positioned(
                  top: 60,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                if (isReady)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _showControls ? 1 : 0,
                      child: IgnorePointer(
                        ignoring: !_showControls,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _formatDuration(currentPosition),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  primaryRed),
                                          minHeight: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _formatDuration(totalDuration),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: goFullScreen,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: primaryRed,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.fullscreen,
                                          color: Colors.white, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isReady)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _showControls ? 1 : 0,
                      child: IgnorePointer(
                        ignoring: !_showControls,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.skip_previous,
                                    color: Colors.white, size: 32),
                                onPressed: _playPreviousVideo,
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: Icon(
                                  (_controller?.value.isPlaying ?? false)
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                onPressed: togglePlayPause,
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const Icon(Icons.skip_next,
                                    color: Colors.white, size: 32),
                                onPressed: _playNextVideo,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Video Info Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        currentIndex < widget.videoNames.length
                            ? widget.videoNames[currentIndex]
                            : "Video ${currentIndex + 1}",
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: lightRed,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: primaryRed.withOpacity(0.25)),
                      ),
                      child: Text(
                        "Video ${currentIndex + 1}/${widget.allVideos.length}",
                        style: TextStyle(
                          color: darkRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  currentIndex < widget.descriptions.length
                      ? widget.descriptions[currentIndex]
                      : "",
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isFirstVideo ? null : _playPreviousVideo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade100,
                        foregroundColor:
                            _isFirstVideo ? Colors.grey : primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: _isFirstVideo
                                ? Colors.grey.shade300
                                : primaryRed.withOpacity(0.8),
                          ),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text(
                        "Previous",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLastVideo ? null : _playNextVideo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isLastVideo ? Colors.grey.shade200 : primaryRed,
                        foregroundColor:
                            _isLastVideo ? Colors.grey.shade500 : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      label: const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Up Next Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: lightRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_circle_filled,
                          color: primaryRed, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Up Next",
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${widget.allVideos.length} videos",
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: primaryRed,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.list, size: 16),
                  label: const Text(
                    "View All",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Video List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: widget.allVideos.length,
              itemBuilder: (context, index) {
                final isCurrent = index == currentIndex;
                final vid = widget.allVideos[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: GestureDetector(
                    onTap: () {
                      currentIndex = index;
                      currentVideo = vid;
                      _loadVideo(vid);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent
                              ? primaryRed.withOpacity(0.35)
                              : Colors.grey.shade200,
                          width: 1.2,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: primaryRed.withOpacity(0.12),
                                  blurRadius: 14,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 60,
                            decoration: BoxDecoration(
                              color:
                                  isCurrent ? primaryRed : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Thumbnail
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 80,
                                  height: 60,
                                  color: Colors.grey.shade300,
                                  child: Image.network(
                                    widget.thumbnails[index],
                                    width: 80,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Icon(
                                        Icons.videocam,
                                        color: Colors.grey.shade500,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (isCurrent)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primaryRed.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              if (index < widget.durations.length &&
                                  widget.durations[index].isNotEmpty)
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      widget.durations[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Video Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.videoNames[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              isCurrent ? darkRed : textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isCurrent)
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: primaryRed,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Now Playing",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.descriptions[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCurrent
                                        ? darkRed.withOpacity(0.8)
                                        : textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.play_circle_filled,
                                      color: isCurrent
                                          ? primaryRed
                                          : Colors.grey.shade500,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Video ${index + 1}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isCurrent
                                            ? primaryRed
                                            : Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController? videoController;
  final Color themeColor;

  const FullScreenVideo({
    super.key,
    this.videoController,
    this.themeColor = const Color(0xFFD32F2F),
  });

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  VideoPlayerController? get _vController => widget.videoController;
  Duration currentPosition = Duration.zero;
  Timer? _progressTimer;
  Timer? _controlsHideTimer;
  bool _isLandscape = false;
  bool _showControls = true;
  static const _controlsHideDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    if (_vController != null) {
      _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_vController!.value.isInitialized) {
          setState(() {
            currentPosition = _vController!.value.position;
          });
        }
      });
    }
    _restartHideTimer();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _controlsHideTimer?.cancel();
    _restorePortrait();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _rewind() {
    if (_vController == null || !_vController!.value.isInitialized) return;
    final newPos = _vController!.value.position - const Duration(seconds: 10);
    _vController!.seekTo(newPos > Duration.zero ? newPos : Duration.zero);
    _onUserInteraction();
  }

  void _forward() {
    if (_vController == null || !_vController!.value.isInitialized) return;
    final maxDuration = _vController!.value.duration;
    final newPos = _vController!.value.position + const Duration(seconds: 10);
    _vController!.seekTo(newPos < maxDuration ? newPos : maxDuration);
    _onUserInteraction();
  }

  void _togglePlayPause() {
    if (_vController == null || !_vController!.value.isInitialized) return;
    setState(() {
      if (_vController!.value.isPlaying) {
        _vController!.pause();
      } else {
        _vController!.play();
      }
    });
    _onUserInteraction();
  }

  void _onScreenTap() {
    setState(() => _showControls = true);
    _restartHideTimer();
  }

  void _onUserInteraction() {
    if (!_showControls) {
      setState(() => _showControls = true);
    }
    _restartHideTimer();
  }

  void _restartHideTimer() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(_controlsHideDelay, () {
      if (!mounted) return;
      setState(() => _showControls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = _vController?.value.duration ?? Duration.zero;
    final progress = totalDuration.inMilliseconds > 0
        ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
        : 0.0;

    Future<void> _toggleOrientation() async {
      if (_isLandscape) {
        await _restorePortrait();
      } else {
        await _setLandscape();
      }
      if (mounted) {
        setState(() => _isLandscape = !_isLandscape);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onScreenTap,
        child: Stack(
          children: [
            Center(
              child: (_vController != null && _vController!.value.isInitialized)
                  ? AspectRatio(
                      aspectRatio: _vController!.value.aspectRatio,
                      child: VideoPlayer(_vController!),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: widget.themeColor,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Loading video...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _showControls ? 1 : 0,
              child: IgnorePointer(
                ignoring: !_showControls,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Top controls - Back button only
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              _onUserInteraction();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                      // Center play controls - No container background
                      Positioned.fill(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.replay_10,
                                    color: Colors.white, size: 34),
                                onPressed: _rewind,
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: Icon(
                                  (_vController?.value.isPlaying ?? false)
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  size: 54,
                                  color: Colors.white,
                                ),
                                onPressed: _togglePlayPause,
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: Icon(Icons.forward_10,
                                    color: Colors.white, size: 34),
                                onPressed: _forward,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom progress bar
                      Positioned(
                        bottom: MediaQuery.of(context).padding.bottom + 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(currentPosition),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      _isLandscape
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    tooltip: _isLandscape
                                        ? "Exit fullscreen"
                                        : "Fullscreen",
                                    onPressed: () {
                                      _onUserInteraction();
                                      _toggleOrientation();
                                    },
                                  ),
                                ),
                                Text(
                                  _formatDuration(
                                      totalDuration - currentPosition),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: widget.themeColor,
                                  inactiveTrackColor: Colors.white30,
                                  thumbColor: widget.themeColor,
                                  overlayColor:
                                      widget.themeColor.withOpacity(0.2),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16,
                                  ),
                                  trackHeight: 4,
                                ),
                                child: Slider(
                                  value: progress.clamp(0.0, 1.0),
                                  onChanged: (val) {
                                    if (_vController == null) return;
                                    final position = totalDuration * val;
                                    _vController!.seekTo(position);
                                    _onUserInteraction();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  Future<void> _restorePortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
