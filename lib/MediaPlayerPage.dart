import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Mediaplayerpage extends StatefulWidget {
  final String videoUrl;
  const Mediaplayerpage({super.key, required this.videoUrl});

  @override
  _MediaplayerpageState createState() => _MediaplayerpageState();
}

class _MediaplayerpageState extends State<Mediaplayerpage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isPlaying = false;
        });
        _controller.play();
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                const SizedBox(height: 20),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
