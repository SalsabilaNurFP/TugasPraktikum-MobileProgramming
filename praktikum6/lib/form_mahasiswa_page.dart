import 'package:flutter/material.dart';
import 'mahasiswa.dart';
import 'hasil_data_page.dart';

class FormMahasiswaPage extends StatefulWidget {
  const FormMahasiswaPage({super.key});
  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final cNama = TextEditingController();
  final cNpm = TextEditingController();
  final cEmail = TextEditingController();
  final cAlamat = TextEditingController();
  final cNoHp = TextEditingController();

  DateTime? tglLahir;
  TimeOfDay? jamBimbingan;
  String? jenisKelamin;

  String get tglLahirLabel => tglLahir == null
      ? 'Pilih Tanggal Lahir'
      : '${tglLahir!.day}/${tglLahir!.month}/${tglLahir!.year}';

  String get jamLabel => jamBimbingan == null
      ? 'Pilih Jam Bimbingan'
      : '${jamBimbingan!.hour.toString().padLeft(2, '0')}:${jamBimbingan!.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    cNama.dispose();
    cNpm.dispose();
    cEmail.dispose();
    cAlamat.dispose();
    cNoHp.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final res = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (res != null) {
      setState(() => tglLahir = res);
    }
  }

  Future<void> _pickTime() async {
    final res = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (res != null) {
      setState(() => jamBimbingan = res);
    }
  }

  void _simpan() {
    final isDataLengkap = _formKey.currentState!.validate() &&
        tglLahir != null &&
        jamBimbingan != null &&
        jenisKelamin != null;

    if (!isDataLengkap) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data belum lengkap, mohon periksa kembali'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final dataMahasiswa = Mahasiswa(
      nama: cNama.text,
      npm: cNpm.text,
      email: cEmail.text,
      alamat: cAlamat.text,
      noHp: cNoHp.text,
      jenisKelamin: jenisKelamin!,
      tglLahir: tglLahir!,
      jamBimbingan: jamBimbingan!,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HasilDataPage(
          dataMahasiswa: dataMahasiswa,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Formulir Mahasiswa',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CustomTextFormField(
                      controller: cNama,
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icons.person,
                      validator: (v) => v!.isEmpty ? 'Nama harus diisi' : null,
                    ),
                    _CustomTextFormField(
                      controller: cNpm,
                      labelText: 'NPM',
                      prefixIcon: Icons.school,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'NPM harus diisi' : null,
                    ),
                    _CustomTextFormField(
                      controller: cEmail,
                      labelText: 'Email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Email harus diisi';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@student\.unsika\.ac\.id$',
                        );
                        return emailRegex.hasMatch(v.trim())
                            ? null
                            : 'Gunakan email @student.unsika.ac.id';
                      },
                    ),
                    _CustomTextFormField(
                      controller: cAlamat,
                      labelText: 'Alamat',
                      prefixIcon: Icons.home,
                      maxLines: 2,
                      validator: (v) =>
                          v!.isEmpty ? 'Alamat harus diisi' : null,
                    ),
                    _CustomTextFormField(
                      controller: cNoHp,
                      labelText: 'Nomor HP',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Nomor HP harus diisi';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                          return 'Hanya boleh berisi angka';
                        }
                        if (v.length < 10) {
                          return 'Nomor HP minimal 10 digit';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: DropdownButtonFormField<String>(
                        value: jenisKelamin,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: Icon(Icons.wc),
                        ),
                        items: ['Laki-laki', 'Perempuan']
                            .map(
                              (label) => DropdownMenuItem(
                                value: label,
                                child: Text(label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => jenisKelamin = value),
                        validator: (v) =>
                            v == null ? 'Pilih Jenis Kelamin' : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _CustomPickerField(
                        label: 'Tanggal Lahir',
                        value: tglLahirLabel,
                        icon: Icons.calendar_today,
                        onTap: _pickDate,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _CustomPickerField(
                        label: 'Jam Bimbingan',
                        value: jamLabel,
                        icon: Icons.access_time,
                        onTap: _pickTime,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _simpan,
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Data'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final int? maxLines;

  const _CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, size: 20),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }
}

class _CustomPickerField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _CustomPickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
        ),
        child: Text(value),
      ),
    );
  }
}