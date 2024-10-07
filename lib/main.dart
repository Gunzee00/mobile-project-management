import 'package:flutter/material.dart';
import 'package:project_management/views/page/homepage/homepage.dart';
import 'package:project_management/views/splashscreen/home_splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeSplashscreen(),
    );
  }
}
