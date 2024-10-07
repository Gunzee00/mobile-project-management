import 'package:flutter/material.dart';
import 'package:project_management/models/onprogress_model.dart';
import 'package:project_management/views/page/onprogress/add_project_onprogress.dart';
import 'package:project_management/views/page/projectdone/projectdone.dart';

import '../onprogress/onprogress_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 59, 36, 163),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding untuk kedua tombol
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Projek Gunawan", // Teks di luar padding
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 30), // Jarak antara dua tombol
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(250, 60), // Ukuran tombol
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnprogressPage()));
                },
                child: const Text(
                  "Project on Progress",
                  style: TextStyle(
                    color: Colors.black,
                  ), // Warna teks
                ),
              ),
              const SizedBox(height: 30), // Jarak antara dua tombol
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(250, 60), // Ukuran tombol
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProjectDonePage()));
                },
                child: const Text(
                  "Project Done",
                  style: TextStyle(
                    color: Colors.black,
                  ), // Warna teks
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
