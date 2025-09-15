//Tugas Praktikum 2 - Salsabila Nur Fadhilah Permana

import 'package:flutter/material.dart';

import 'profile_page.dart';
import 'input_mahasiswa_page.dart';
import 'models/mahasiswa.dart';

import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF9FB),

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.grey[800],
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[200],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[800], fontSize: 16),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Mahasiswa? mahasiswa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(
                      namaaplikasi: "FlutterLog",
                      versiaplikasi: "1.0.0",
                      namadeveloper: "Salsabila Nur Fadhilah Permana",
                    ),
                  ),
                );
              },
              child: const Text("Go to Profile Page"),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<Mahasiswa>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputMahasiswaPage(),
                  ),
                );

                if (!mounted) return;

                if (result != null) {
                  setState(() {
                    mahasiswa = result;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Data ${result.nama} berhasil disimpan"),
                    ),
                  );
                }
              },
              child: const Text("Input Mahasiswa"),
            ),

            if (mahasiswa != null) ...[
              const SizedBox(height: 20),
              Text("Nama: ${mahasiswa!.nama}"),
              Text("Umur: ${mahasiswa!.umur}"),
              Text("Alamat: ${mahasiswa!.alamat}"),
              Text("Kontak: ${mahasiswa!.kontak}"),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  final Uri telUri = Uri(
                    scheme: 'tel',
                    path: mahasiswa!.kontak,
                  );
                  if (await canLaunchUrl(telUri)) {
                    await launchUrl(
                      telUri,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Tidak ada aplikasi Telepon di perangkat ini",
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Panggil Mahasiswa"),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
