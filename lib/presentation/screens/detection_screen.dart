import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pastikan ini diimpor
import 'dart:io'; // Diperlukan untuk tipe data File

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  String _detectionInfo =
      "Pilih gambar atau masukkan bahan untuk dideteksi."; // Info awal
  File? _selectedImage; // Untuk menyimpan file gambar yang dipilih
  List<String> _detectedIngredientsFromImage =
      []; // Untuk menyimpan hasil deteksi dari gambar

  final ImagePicker _picker = ImagePicker(); // Instance dari ImagePicker

  // Warna dari palet yang telah kita sepakati
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFFFF7043);
  final Color textFieldFillColor = const Color(0xFFFFF0E5);
  final Color textColor = const Color(0xFF212121);
  final Color hintTextColor = Colors.grey.shade500;
  final Color iconColor = const Color(0xFFFF7043).withOpacity(0.8);
  final Color borderColor = Colors.grey.shade300;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Kualitas gambar (0-100)
        maxWidth: 1000, // Batasi lebar gambar untuk efisiensi
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _detectionInfo =
              "Gambar dipilih. Tekan 'DETEKSI RESEP' untuk memproses.";
          _detectedIngredientsFromImage
              .clear(); // Bersihkan hasil deteksi sebelumnya jika ada
          _ingredientController
              .clear(); // Bersihkan input manual jika gambar dipilih
        });
        print("Gambar dipilih: ${image.path}");
      } else {
        print("Tidak ada gambar dipilih.");
        // setState(() {
        //   _detectionInfo = "Tidak ada gambar dipilih. Silakan coba lagi.";
        // });
      }
    } catch (e) {
      print("Error saat mengambil gambar: $e");
      setState(() {
        _detectionInfo = "Error saat mengambil gambar: ${e.toString()}";
      });
    }
  }

  void _detectRecipes() {
    if (_selectedImage == null && _ingredientController.text.trim().isEmpty) {
      setState(() {
        _detectionInfo =
            "Silakan pilih gambar atau masukkan daftar bahan terlebih dahulu.";
      });
      return;
    }

    setState(() {
      // Jika ada gambar, kita akan prioritaskan deteksi dari gambar (nantinya)
      // Jika tidak ada gambar tapi ada teks, kita akan pakai teks (nantinya)
      if (_selectedImage != null) {
        _detectionInfo =
            "Memproses gambar untuk deteksi bahan... (Simulasi API)";
        // TODO: Panggil fungsi untuk mengirim _selectedImage ke Gemini API
        // Contoh: _processImageWithGemini(_selectedImage!);
        // Untuk sekarang, kita simulasi hasil deteksi:
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _detectedIngredientsFromImage = [
              "Tomat",
              "Ayam",
              "Bawang",
            ]; // Hasil dummy
            _detectionInfo =
                "Bahan terdeteksi dari gambar: ${_detectedIngredientsFromImage.join(', ')}. Mencari resep...";
            // TODO: Lanjutkan ke pencocokan resep
          });
        });
      } else if (_ingredientController.text.trim().isNotEmpty) {
        List<String> manualIngredients =
            _ingredientController.text
                .trim()
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
        _detectionInfo =
            "Bahan dari input manual: ${manualIngredients.join(', ')}. Mencari resep...";
        // TODO: Lanjutkan ke pencocokan resep dengan manualIngredients
      }
    });

    // TODO: Implementasi logika deteksi resep (pencocokan dengan data Firestore)
    // berdasarkan _detectedIngredientsFromImage atau _ingredientController.text
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
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ambil foto bahan makanan, atau ketik bahan secara manual untuk menemukan resep.',
              style: TextStyle(fontSize: 15, color: textColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 24),

            // Area Input Gambar
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                color: cardColor,
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
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          height: 200, // Tinggi pratinjau gambar
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      // Placeholder jika belum ada gambar dipilih
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Pratinjau gambar akan muncul di sini',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
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
              'Atau tulis daftar bahan :',
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
                hintText: 'Contoh : Telur, Tomat, Bayam (pisahkan dengan koma)',
                hintStyle: TextStyle(color: hintTextColor),
                filled: true,
                fillColor: cardColor,
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
              onTap: () {
                // Jika pengguna mengetik, hapus gambar yang dipilih
                if (_selectedImage != null) {
                  setState(() {
                    _selectedImage = null;
                    _detectionInfo = "Input manual dipilih. Masukkan bahan.";
                  });
                }
              },
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

            // Area Hasil Deteksi / Informasi
            Text(
              'Informasi & Hasil',
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
                color: textFieldFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor.withOpacity(0.7)),
              ),
              child: Text(
                _detectionInfo, // Menampilkan _detectionInfo
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
    );
  }

  Widget _buildImageInputAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      // Menggunakan Expanded agar tombol mengisi ruang
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          // Mengubah menjadi ElevatedButton agar lebih jelas
          icon: Icon(icon, color: Colors.white),
          label: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: iconColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

//**Perubahan Utama di `DetectionScreen`:**
// * **Impor `image_picker.dart` dan `dart:io`**.
// * **`_selectedImage`**: Variabel `File?` untuk menyimpan path gambar yang dipilih.
// * **`_picker`**: Instance dari `ImagePicker`.
// * **`_pickImage(ImageSource source)` Diperbarui**:
//     * Menggunakan `await _picker.pickImage(...)` untuk membuka kamera atau galeri.
//     * `imageQuality` dan `maxWidth` bisa ditambahkan untuk optimasi.
//     * Jika gambar berhasil dipilih (`image != null`), path gambar disimpan ke `_selectedImage` menggunakan `File(image.path)`, dan `setState` dipanggil untuk memperbarui UI (menampilkan pratinjau).
//     * `_ingredientController` dan `_detectedIngredientsFromImage` dibersihkan saat gambar baru dipilih.
// * **Pratinjau Gambar**: Di dalam `build()`, ada kondisi untuk menampilkan `Image.file(_selectedImage!)` jika `_selectedImage` tidak null, atau placeholder jika null.
// * **Input Teks Membersihkan Gambar**: Saat `TextField` untuk input manual di-tap, `_selectedImage` akan di-clear. Ini agar pengguna fokus pada satu metode input.
// * **`_detectRecipes()` Diperbarui (Sedikit)**: Sekarang mengecek apakah gambar dipilih atau teks diisi sebelum melanjutkan. Logika API dan pencocokan resep masih `// TODO`. Saya menambahkan simulasi hasil deteksi dari gambar untuk sementara.
// * **`_buildImageInputAction` Diperbarui**: Menggunakan `ElevatedButton.icon` agar terlihat lebih seperti tombol dan `Expanded` agar kedua tombol mengisi ruang secara merata.
// * **`_detectionInfo`**: Variabel string untuk memberikan feedback kepada pengguna di UI.