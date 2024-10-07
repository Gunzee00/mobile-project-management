import 'package:flutter/material.dart';
import 'package:project_management/views/page/homepage/homepage.dart';

class HomeSplashscreen extends StatefulWidget {
  const HomeSplashscreen({super.key});

  @override
  State<HomeSplashscreen> createState() => _HomeSplashscreenState();
}

class _HomeSplashscreenState extends State<HomeSplashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(_fadePageTransition(const Homepage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 59, 36, 163),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/face.png', // Ganti ikon dengan gambar
              width: 30, // Ukuran gambar dikurangi menjadi 30
              height: 30,
            ),
            const SizedBox(width: 8), // Jarak antara gambar dan teks
            const Text(
              "Hy Gunn",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _fadePageTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 2.0;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin, end: end);
        var curveAnimation = CurvedAnimation(parent: animation, curve: curve);
        var opacityAnimation = tween.animate(curveAnimation);

        return FadeTransition(opacity: opacityAnimation, child: child);
      },
    );
  }
}
