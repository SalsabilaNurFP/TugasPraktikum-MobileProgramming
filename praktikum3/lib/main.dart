//Tugas Praktikum 3 - Salsabila Nur Fadhilah Permana

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color softPink = Color(0xFFFDEBF7);
    const Color softPurple = Color(0xFFE1D5E7);
    const Color darkText = Color(0xFF4A445D);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Mahasiswa',
      theme: ThemeData(
        primaryColor: softPink,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: darkText,
          elevation: 1.0,
          iconTheme: IconThemeData(color: darkText),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: softPurple,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: darkText),
          bodyMedium: TextStyle(color: darkText),
          headlineMedium: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color softPink = Color(0xFFFDEBF7);
    const Color softPurple = Color(0xFFE1D5E7);
    const Color darkText = Color(0xFF4A445D);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Mahasiswa'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 120, 
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              alignment: Alignment.bottomLeft, 
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [softPink, softPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Text(
                'Menu Utama',
                style: TextStyle(
                  color: darkText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: darkText),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: darkText),
              title: const Text('Halaman Counter'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CounterPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school_outlined,
              size: 80,
              color: softPurple,
            ),
            const SizedBox(height: 20),
            Text(
              'Selamat Datang!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Silahkan buka menu di kiri atas untuk memulai.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }
  
  void decrement() {
    setState(() {
      if (count > 0) {
        count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color softPink = Color(0xFFFDEBF7);
    const Color darkText = Color(0xFF4A445D);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Jumlah Klik:',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'decrement_button',
              onPressed: decrement,
              tooltip: 'Kurangi',
              backgroundColor: softPink,
              elevation: 2.0,
              child: const Icon(Icons.remove, color: darkText),
            ),
            FloatingActionButton(
              heroTag: 'increment_button',
              onPressed: increment,
              tooltip: 'Tambah',
              elevation: 2.0,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}