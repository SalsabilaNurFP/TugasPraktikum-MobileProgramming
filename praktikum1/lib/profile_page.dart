import "package:flutter/material.dart";

class ProfilePage extends StatelessWidget {
  final String namaaplikasi;
  final String versiaplikasi;
  final String namadeveloper;

  const ProfilePage({
    super.key,
    required this.namaaplikasi,
    required this.versiaplikasi,
    required this.namadeveloper,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nama Aplikasi: $namaaplikasi"),
            Text("Versi Aplikasi: $versiaplikasi"),
            Text("Nama Developer: $namadeveloper"),
          ],
        ),
      ),
    );
  }
}