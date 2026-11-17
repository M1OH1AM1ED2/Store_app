import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/splash_fixed.mp4');

    _controller.initialize().then((_) {
      if (!mounted) return;

      setState(() {});
      _controller.play();

      _controller.addListener(_checkVideo);
    });
  }

  void _checkVideo() {
    if (!_controller.value.isInitialized || _navigated) return;

    if (_controller.value.position >= _controller.value.duration) {
      _navigated = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideo);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 11, 11),
      body: SizedBox.expand(
        child: _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF7900)),
              ),
      ),
    );
  }
}
