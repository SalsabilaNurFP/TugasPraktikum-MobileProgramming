import 'package:flutter/material.dart';
import 'mahasiswa.dart';

class HasilDataPage extends StatelessWidget {
  final Mahasiswa dataMahasiswa;

  const HasilDataPage({super.key, required this.dataMahasiswa});

  @override
  Widget build(BuildContext context) {
    final jam = dataMahasiswa.jamBimbingan.hour.toString().padLeft(2, '0');
    final menit = dataMahasiswa.jamBimbingan.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Data Mahasiswa'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDataTile(
            context: context,
            icon: Icons.person_outline,
            label: 'Nama Lengkap',
            value: dataMahasiswa.nama,
          ),
          _buildDataTile(
            context: context,
            icon: Icons.school_outlined,
            label: 'NPM',
            value: dataMahasiswa.npm,
          ),
          _buildDataTile(
            context: context,
            icon: Icons.email_outlined,
            label: 'Email',
            value: dataMahasiswa.email,
          ),
          _buildDataTile(
            context: context,
            icon: Icons.home_outlined,
            label: 'Alamat',
            value: dataMahasiswa.alamat,
          ),
          _buildDataTile(
            context: context,
            icon: Icons.phone_outlined,
            label: 'Nomor HP',
            value: dataMahasiswa.noHp,
          ),
          _buildDataTile(
            context: context,
            icon: Icons.wc_outlined,
            label: 'Jenis Kelamin',
            value: dataMahasiswa.jenisKelamin,
          ),
          _buildDataTile(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: 'Tanggal Lahir',
            value:
                '${dataMahasiswa.tglLahir.day}/${dataMahasiswa.tglLahir.month}/${dataMahasiswa.tglLahir.year}',
          ),
          _buildDataTile(
            context: context,
            icon: Icons.access_time_outlined,
            label: 'Jam Bimbingan',
            value: '$jam:$menit',
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Kembali ke Formulir'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTile(
      {required BuildContext context,
      required IconData icon,
      required String label,
      required String value}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}