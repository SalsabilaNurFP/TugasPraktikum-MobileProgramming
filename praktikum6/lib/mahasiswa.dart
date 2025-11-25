import 'package:flutter/material.dart';

class Mahasiswa {
  final String nama;
  final String npm;
  final String email;
  final String alamat;
  final String noHp;
  final String jenisKelamin;
  final DateTime tglLahir;
  final TimeOfDay jamBimbingan;

  Mahasiswa({
    required this.nama,
    required this.npm,
    required this.email,
    required this.alamat,
    required this.noHp,
    required this.jenisKelamin,
    required this.tglLahir,
    required this.jamBimbingan,
  });
}