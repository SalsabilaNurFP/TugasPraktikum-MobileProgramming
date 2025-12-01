// Praktik PraUAS - Salsabila Nur Fadhilah Permana

import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.init();
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()),
  );
}
