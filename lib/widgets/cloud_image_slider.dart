import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Dark mode.dart';
import '../api/images_api.dart';

class CloudImageSlider extends StatefulWidget {
  final int limit;
  const CloudImageSlider({super.key, this.limit = 5});

  @override
  State<CloudImageSlider> createState() => _CloudImageSliderState();
}

class _CloudImageSliderState extends State<CloudImageSlider> {
  final PageController _pageController = PageController(viewportFraction: 1);
  Timer? _timer;
  int _index = 0;
  List<CloudImage> _images = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final list = await ImagesApi.list(limit: widget.limit);
    if (!mounted) return;
    // Optional: filter only folder == 'slider' if provided
    final filtered = list.where((e) => (e.folder == null || e.folder == 'slider')).toList();
    setState(() {
      _images = filtered;
      _loading = false;
    });
    if (_images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!mounted || _images.isEmpty) return;
        final next = (_index + 1) % _images.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = Provider.of<ColorNotifire>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: n.onboardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: n.getContainerBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              )
            else if (_images.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text('No images', style: TextStyle(color: n.tabBarText2)),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemCount: _images.length,
                    itemBuilder: (context, i) {
                      final img = _images[i];
                      return Container(
                        color: n.onboardBackgroundColor,
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.contain, // Show full image
                          child: Image.network(
                            img.url,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (_images.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_images.length, (i) {
                  final selected = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: selected ? 18 : 6,
                    decoration: BoxDecoration(
                      color: selected ? n.textColor : (n.getContainerBorder ?? Colors.grey),
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

