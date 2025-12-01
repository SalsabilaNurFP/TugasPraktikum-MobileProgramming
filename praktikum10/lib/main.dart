import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'session_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getHome() async {
    bool loggedIn = await SessionManager.isLoggedIn();
    return loggedIn ? const HomePage() : const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Mono Auth',
      theme: ThemeData(
        useMaterial3: true,
        // Satu warna dominan: Soft Lavender
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA294F9),
          primary: const Color(0xFFA294F9),
          surface: Colors.white,
          background: const Color(0xFFFDFBF7), // Cream lembut untuk background
        ),
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),

        // Input Field (Flat & Clean)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFA294F9), width: 2),
          ),
        ),

        // Tombol (Solid Color)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA294F9),
            foregroundColor: Colors.white,
            elevation: 0, // Flat, tidak ada bayangan
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDFBF7),
          foregroundColor: Color(0xFFA294F9), // Text warna ungu
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: FutureBuilder(
        future: _getHome(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFA294F9)),
              ),
            );
          }
          return snapshot.data ?? const LoginPage();
        },
      ),
    );
  }
}
