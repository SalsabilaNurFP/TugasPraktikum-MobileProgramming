import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'session_manager.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _newPasswordController = TextEditingController();

  void _changePassword() async {
    String newPass = _newPasswordController.text;
    if (newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru tidak boleh kosong")),
      );
      return;
    }

    await DBHelper.instance.changePassword(widget.username, newPass);

    if (!mounted) return;
    
    // --- PERUBAHAN WARNA DI SINI ---
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password berhasil diubah!"),
        backgroundColor: Color(0xFF4CAF50), // Mengubah warna menjadi Hijau
      ),
    );
    // -------------------------------
    
    _newPasswordController.clear();
  }

  void _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Akun?"),
        content: const Text("Data Anda akan hilang permanen."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await DBHelper.instance.deleteUser(widget.username);
              await SessionManager.logout();
              
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Colors.transparent, // Agar menyatu dengan background body
        foregroundColor: const Color(0xFFA294F9),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFA294F9),
                    child: const Icon(Icons.person_rounded, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA294F9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              "Ganti Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password Baru",
                prefixIcon: Icon(Icons.lock_reset_rounded, color: Color(0xFFA294F9)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text("Simpan Password"),
            ),

            const SizedBox(height: 40),

            // Tombol Hapus Akun (Sederhana, Teks Merah)
            Center(
              child: TextButton(
                onPressed: _deleteAccount,
                child: const Text(
                  "Hapus Akun Saya",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}