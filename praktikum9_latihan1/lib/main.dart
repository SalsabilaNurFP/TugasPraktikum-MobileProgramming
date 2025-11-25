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
    Kucing kucing1 = Kucing('Onil', 4.5, 'Putih Abu');
    String sedangMakan = kucing1.makan(200);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Latihan 1')),
        body: Center(
          child: Text(
            sedangMakan,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
