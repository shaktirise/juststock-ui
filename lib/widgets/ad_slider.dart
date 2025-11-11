import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../Dark mode.dart';

class AdSlider extends StatefulWidget {
  const AdSlider({super.key});

  @override
  State<AdSlider> createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  List<String> _ads = const [];

  final PageController _pageController = PageController(viewportFraction: 1);
  final List<VideoPlayerController> _controllers = [];
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadAds() async {
    try {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = jsonDecode(manifestJson);
      final ads = manifestMap.keys
          .where((k) => k.startsWith('assets/ads/') &&
              (k.toLowerCase().endsWith('.mp4')))
          .toList()
        ..sort();
      if (!mounted) return;
      setState(() => _ads = ads);
      if (_ads.isEmpty) return;
      // Initialize all videos concurrently so swiping on mobile doesn't show loaders.
      final inits = <Future<void>>[];
      for (final path in _ads) {
        final c = VideoPlayerController.asset(path)
          ..setLooping(true)
          ..setVolume(0.0);
        _controllers.add(c);
        inits.add(c.initialize().catchError((_) {}));
      }
      // Ensure first ad is ready quickly; others keep initializing concurrently.
      if (inits.isNotEmpty) {
        await inits.first;
      }
      if (!mounted) return;
      setState(() {});
      if (_controllers.isNotEmpty && _controllers.first.value.isInitialized) {
        _controllers.first.play();
      }
      // Do not await the rest, but when they finish they'll render without spinner.
      // Best-effort: wait for remaining in background (no need to handle result).
      // ignore: unawaited_futures
      Future.wait(inits).catchError((_) {});
      _timer = Timer.periodic(const Duration(seconds: 6), (_) {
        if (!mounted || _controllers.isEmpty) return;
        final next = (_index + 1) % _ads.length;
        _pageController.animateToPage(next,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOut);
      });
    } catch (_) {
      // Ignore errors; slider will stay empty if manifest missing
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: notifier.onboardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: notifier.getContainerBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_ads.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'No ads found',
                  style: TextStyle(color: notifier.tabBarText2),
                ),
              )
            else
              ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: _pageController,
                  allowImplicitScrolling: true,
                  onPageChanged: (i) {
                    setState(() => _index = i);
                    for (int k = 0; k < _controllers.length; k++) {
                      final c = _controllers[k];
                      if (!c.value.isInitialized) continue;
                      if (k == i) {
                        c.play();
                      } else {
                        c.pause();
                        c.seekTo(Duration.zero);
                      }
                    }
                  },
                  itemCount: _ads.length,
                  itemBuilder: (context, i) {
                    final c = _controllers[i];
                    if (!c.value.isInitialized) {
                      return const Center(
                        child: SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      );
                    }
                    return FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: c.value.size.width,
                        height: c.value.size.height,
                        child: VideoPlayer(c),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_ads.isNotEmpty) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_ads.length, (i) {
                final selected = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: selected ? 18 : 6,
                  decoration: BoxDecoration(
                    color: selected
                        ? notifier.textColor
                        : (notifier.getContainerBorder ?? Colors.grey),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
