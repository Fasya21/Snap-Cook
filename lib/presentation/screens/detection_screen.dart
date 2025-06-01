import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Akan dibutuhkan nanti
// import 'dart:io'; // Akan dibutuhkan nanti

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  String _detectionResult = "Belum ada Resep yang terdeteksi.";
  // File? _selectedImage; // Untuk menyimpan gambar yang dipilih

  // Warna dari palet yang telah kita sepakati
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFFFF7043);
  final Color textFieldFillColor = const Color(0xFFFFF0E5);
  final Color textColor = const Color(0xFF212121);
  final Color hintTextColor = Colors.grey.shade500;
  final Color iconColor = const Color(0xFFFF7043).withOpacity(0.8);
  final Color borderColor = Colors.grey.shade300;

  // Fungsi placeholder untuk pengambilan gambar
  Future<void> _pickImage(ImageSource source) async {
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: source, imageQuality: 80);
    // if (image != null) {
    //   setState(() {
    //     _selectedImage = File(image.path);
    //     _detectionResult = "Gambar dipilih. Tekan 'DETEKSI RESEP'."; // Update status
    //   });
    //   // TODO: Kirim gambar ke API atau proses lebih lanjut
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fitur pilih gambar dari ${source.name} belum implementasi penuh.',
        ),
      ),
    );
  }

  void _detectRecipes() {
    // TODO: Implementasi logika deteksi resep berdasarkan _selectedImage atau _ingredientController.text
    // Untuk sekarang, hanya simulasi
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        _detectionResult =
            "Mencari resep untuk: ${_ingredientController.text}... (Simulasi)";
      });
    } else /* if (_selectedImage != null) */ {
      // Hapus komentar jika _selectedImage sudah dipakai
      setState(() {
        _detectionResult = "Memproses gambar untuk deteksi bahan... (Simulasi)";
      });
    }
    // else {
    //   setState(() {
    //     _detectionResult = "Silakan pilih gambar atau masukkan bahan terlebih dahulu.";
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Deteksi Resep',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // Warna ikon back jika ada
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ambil foto bahan makanan dengan overlay guide, atau ketik bahan secara manual.',
              style: TextStyle(fontSize: 15, color: textColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 24),

            // Area Input Gambar
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color:
                    cardColor, // Bisa juga textFieldFillColor agar lebih lembut
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // if (_selectedImage != null)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 16.0),
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(12),
                  //       child: Image.file(
                  //         _selectedImage!,
                  //         height: 150,
                  //         width: double.infinity,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildImageInputAction(
                        icon: Icons.camera_alt_outlined,
                        label: 'Ambil Gambar\nKamera',
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                      _buildImageInputAction(
                        icon: Icons.photo_library_outlined,
                        label: 'Pilih dari\nGaleri',
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Area Input Teks Manual
            Text(
              'Tulis daftar bahan :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                hintText: 'Contoh : Telur, Tomat, Bayam',
                hintStyle: TextStyle(color: hintTextColor),
                filled: true,
                fillColor: cardColor, // Atau textFieldFillColor
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accentColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              minLines: 2,
              maxLines: 4,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            const SizedBox(height: 24),

            // Tombol Deteksi Resep
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _detectRecipes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  'DETEKSI RESEP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Area Hasil Deteksi
            Text(
              'Hasil Deteksi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: textFieldFillColor, // Warna yang lembut untuk hasil
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor.withOpacity(0.7)),
              ),
              child: Text(
                _detectionResult,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      // BottomNavigationBar bisa ditambahkan di sini jika halaman ini berdiri sendiri
      // atau dikelola oleh widget parent (seperti HomeScreen atau MainScreen)
    );
  }

  Widget _buildImageInputAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: textFieldFillColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor.withOpacity(0.5)),
            ),
            child: Icon(icon, size: 36, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
