import 'package:flutter/material.dart';
// Nantinya kita akan import image_picker di sini
import 'package:image_picker/image_picker.dart';
// import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ImagePicker _picker = ImagePicker();
  // File? _selectedImage; // Untuk menyimpan gambar yang dipilih (opsional untuk pratinjau di sini)

  // Definisikan warna tema (Anda bisa mengambil ini dari ThemeData di main.dart jika sudah terpusat)
  final Color primaryColor = const Color(
    0xFFFF7043,
  ); // Menggunakan warna aksen dari login sebagai contoh
  final Color buttonTextColor = Colors.white;
  final Color iconColor = const Color(0xFFFF7043);

  Future<void> _onPickImage(ImageSource source) async {
    // TODO: Implementasi logika pengambilan gambar menggunakan image_picker
    // final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);

    // if (pickedFile != null) {
    //   // setState(() {
    //   //   _selectedImage = File(pickedFile.path);
    //   // });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Gambar dipilih: ${pickedFile.path.split('/').last}')),
    //   );
    //   // TODO: Navigasi ke halaman hasil deteksi dengan membawa path gambar
    //   // Navigator.pushNamed(context, '/detection-result', arguments: pickedFile.path);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Tidak ada gambar dipilih.')),
    //   );
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fitur pengambilan gambar (${source.name}) belum diimplementasikan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Snap Cook',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implementasi logika logout
              // Navigator.pushReplacementNamed(context, '/login');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur Logout belum diimplementasikan.'),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Icon Aplikasi atau Gambar Ilustrasi (Opsional)
              Icon(
                Icons.camera_enhance_rounded, // Icon placeholder
                size: 100,
                color: iconColor.withOpacity(0.7),
              ),
              const SizedBox(height: 24),
              Text(
                'Temukan Resep dari Bahan Makanan Anda!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color:
                      Theme.of(context).textTheme.titleLarge?.color ??
                      Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ambil foto bahan makanan Anda atau unggah dari galeri untuk menemukan resep yang lezat.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),

              // Tombol Ambil Foto dari Kamera
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Ambil Foto dari Kamera'),
                style: ElevatedButton.styleFrom(
                  // backgroundColor: primaryColor, // Menggunakan dari ThemeData jika diset
                  // foregroundColor: buttonTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  _onPickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 20),

              // Tombol Unggah Foto dari Galeri
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Unggah Foto dari Galeri'),
                style: ElevatedButton.styleFrom(
                  // backgroundColor: primaryColor, // Menggunakan dari ThemeData jika diset
                  // foregroundColor: buttonTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  _onPickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 32),

              // // Opsional: Pratinjau Gambar yang Dipilih
              // if (_selectedImage != null)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 20.0),
              //     child: Column(
              //       children: [
              //         Text("Gambar Terpilih:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              //         const SizedBox(height: 10),
              //         Image.file(
              //           _selectedImage!,
              //           height: 200,
              //           fit: BoxFit.contain,
              //           errorBuilder: (context, error, stackTrace) => Text("Gagal memuat pratinjau gambar."),
              //         ),
              //       ],
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
