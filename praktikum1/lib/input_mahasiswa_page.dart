import 'package:flutter/material.dart';
import 'models/mahasiswa.dart';

class InputMahasiswaPage extends StatefulWidget {
  const InputMahasiswaPage({super.key});

  @override
  State<InputMahasiswaPage> createState() => _InputMahasiswaPageState();
}

class _InputMahasiswaPageState extends State<InputMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Mahasiswa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _umurController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Umur"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: "Alamat"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _kontakController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "No. Kontak"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final mhs = Mahasiswa(
                      nama: _namaController.text,
                      umur: int.parse(_umurController.text),
                      alamat: _alamatController.text,
                      kontak: _kontakController.text,
                    );
                    Navigator.pop(context, mhs);
                  }
                },
                child: const Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}