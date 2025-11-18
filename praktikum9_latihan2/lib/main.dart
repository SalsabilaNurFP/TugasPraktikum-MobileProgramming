// Tugas Praktikum 9 Latihan 1 - Salsabila Nur Fadhilah Permana

import 'package:flutter/material.dart';
import 'hewan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HewanScreen());
  }
}

class HewanScreen extends StatefulWidget {
  const HewanScreen({super.key});

  @override
  State<HewanScreen> createState() => _HewanScreenState();
}

class _HewanScreenState extends State<HewanScreen> {
  Kucing kucing1 = Kucing('Onil', 4.5, 'Putih Abu');
  String pesan = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan 2')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Berat ${kucing1.nama}: ${kucing1.berat.toStringAsFixed(1)} kg',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              pesan,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  kucing1.berat += 1;
                  pesan = "${kucing1.nama} makan, berat bertambah 1 kg.";
                });
              },
              child: const Text('Makan'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  kucing1.berat -= 0.5;
                  pesan = "${kucing1.nama} berlari, berat berkurang 0.5 kg.";
                });
              },
              child: const Text('Lari'),
            ),
          ],
        ),
      ),
    );
  }
}
