//Tugas Praktikum 5 - Salsabila Nur Fadhilah Permana

import 'package:flutter/material.dart';

void main() => runApp(const BeritaApp());

class BeritaApp extends StatelessWidget {
  const BeritaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Flutter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HalamanBerita(),
    );
  }
}

class HalamanBerita extends StatelessWidget {
  const HalamanBerita({super.key});

  final List<Map<String, String>> dataBerita = const [
    {
      'title': 'Pemerintah Resmikan Kawasan Inti Pusat Pemerintahan di IKN',
      'description':
          'Kawasan Inti Pusat Pemerintahan (KIPP) di Ibu Kota Nusantara (IKN) telah diresmikan. Proyek strategis ini diharapkan menjadi simbol kemajuan dan pemerataan pembangunan Indonesia.',
      'imageUrl':
          'https://media.suara.com/pictures/653x366/2022/01/20/90253-desain-ibu-kota-negara-ikn-nusantara.jpg',
    },
    {
      'title':
          'Timnas Indonesia Tatap Laga Krusial Kualifikasi Piala Dunia 2026',
      'description':
          'Skuad Garuda bersiap menghadapi laga tandang penentu. Kemenangan akan membuka peluang lolos ke babak selanjutnya dalam sejarah sepak bola Indonesia yang bersejarah.',
      'imageUrl':
          'https://i0.wp.com/narasitoday.com/wp-content/uploads/2025/09/Timnas-Indonesia-Siap-Hadapi-Dua-Laga-Penting-di-Kualifikasi-Piala-Dunia-2026-e1759203864755.webp?fit=800%2C470&ssl=1',
    },
    {
      'title': 'Bank Indonesia Siapkan Peluncuran Fase Pertama Rupiah Digital',
      'description':
          'Setelah melalui serangkaian uji coba, Bank Indonesia akan meluncurkan tahap awal Rupiah Digital. Kebijakan ini menjadi langkah besar menuju digitalisasi ekonomi nasional.',
      'imageUrl':
          'https://cdn.antaranews.com/cache/1200x800/2024/05/28/Foto-Pendukung-III.jpg',
    },
    {
      'title':
          'Studi Kelayakan Kereta Cepat Jakarta-Surabaya Rampung Akhir Tahun',
      'description':
          'Pemerintah menargetkan studi kelayakan rute Kereta Cepat Whoosh hingga Surabaya selesai pada akhir 2025. Proyek ini akan memangkas waktu tempuh menjadi kurang dari 4 jam.',
      'imageUrl':
          'https://img.idxchannel.com/images/idx/2022/08/03/Kereta_Cepat.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Berita')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        itemCount: dataBerita.length,
        itemBuilder: (context, index) {
          final berita = dataBerita[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  berita['imageUrl']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  headers: const {
                    'User-Agent':
                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.93 Safari/537.36',
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80),
                ),
              ),
              title: Text(
                berita['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                berita['description']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.bookmark_border),
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Mengalihkan ke halaman berita'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                );

                await Future.delayed(const Duration(milliseconds: 500));

                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanDetailBerita(
                      title: berita['title']!,
                      description: berita['description']!,
                      imageUrl: berita['imageUrl']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class HalamanDetailBerita extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const HalamanDetailBerita({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 250,
              headers: const {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.93 Safari/537.36',
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}