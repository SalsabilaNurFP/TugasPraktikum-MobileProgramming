import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../model/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan Password tidak boleh kosong!")),
      );
      return;
    }

    User newUser = User(username: username, password: password);

    try {
      await DBHelper.instance.registerUser(newUser);

      if (!context.mounted) return;

      // --- PERUBAHAN WARNA DI SINI ---
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil, silakan login"),
          backgroundColor: Color(0xFF4CAF50), // Mengubah warna menjadi Hijau
        ),
      );
      // -------------------------------

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal registrasi: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFFA294F9),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Buat Akun",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA294F9),
                ),
              ),
              const SizedBox(height: 8),
               Text(
                "Mulai perjalanan Anda sekarang",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  prefixIcon: Icon(Icons.person_outline, color: Color(0xFFA294F9)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFA294F9)),
                ),
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _register, 
                child: const Text("Daftar Sekarang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}