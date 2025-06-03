import 'dart:io'; // Untuk tipe data File
import 'dart:typed_data'; // Untuk Uint8List
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IngredientDetectionRemoteDatasource {
  Future<List<String>> detectIngredientsFromImage(File imageFile);
}

// // Mendefinisikan kontrak (interface) untuk IngredientDetectionRepository
// abstract class IngredientDetectionRepository {
//   // Mengembalikan Future yang berisi List<String> dari bahan-bahan yang terdeteksi.
//   // Nantinya bisa diubah menjadi Future<Either<Failure, List<String>>> untuk error handling.
//   Future<List<String>> detectIngredients(File imageFile);
// }

class IngredientDetectionRemoteDatasourceImpl
    implements IngredientDetectionRemoteDatasource {
  final GenerativeModel _model;

  IngredientDetectionRemoteDatasourceImpl()
    // Mengambil API key dari environment variable yang dimuat oleh flutter_dotenv
    : _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest', // Model yang mendukung input gambar
        apiKey: dotenv.env['GEMINI_API_KEY'] ?? "API_KEY_NOT_FOUND",
        // Safety settings bisa disesuaikan jika perlu
        // safetySettings: [
        //   SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        //   SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        // ],
      ) {
    if (dotenv.env['GEMINI_API_KEY'] == null ||
        dotenv.env['GEMINI_API_KEY']!.isEmpty) {
      print(
        "PERINGATAN: GEMINI_API_KEY tidak ditemukan di file .env atau kosong.",
      );
      // Anda bisa melempar error di sini jika API key wajib ada
      // throw Exception("GEMINI_API_KEY tidak ditemukan.");
    }
  }

  @override
  Future<List<String>> detectIngredientsFromImage(File imageFile) async {
    print(
      "IngredientDetectionRemoteDatasourceImpl: Memulai deteksi bahan dari gambar: ${imageFile.path}",
    );
    try {
      // 1. Baca gambar sebagai bytes
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // 2. Siapkan prompt untuk Gemini API
      // Prompt ini sangat penting untuk mendapatkan output yang diinginkan.
      // Anda mungkin perlu bereksperimen dengan prompt yang berbeda.
      final prompt = TextPart(
        "Analisis gambar ini dan identifikasi semua bahan makanan mentah yang terlihat. "
        "Fokus hanya pada bahan makanan individual yang dapat digunakan untuk memasak. "
        "Jangan sertakan nama masakan jadi atau alat masak. "
        "Jika tidak ada bahan makanan yang jelas terdeteksi, kembalikan string kosong. "
        "Jika ada, kembalikan daftar bahan tersebut dipisahkan oleh koma. Contoh: tomat,bawang merah,ayam potong,daun bawang,cabai",
      );

      // 3. Siapkan gambar sebagai DataPart
      // Pastikan tipe MIME sesuai dengan format gambar Anda (image/jpeg, image/png, dll.)
      // Kita bisa mencoba mendapatkan tipe MIME dari path file jika memungkinkan,
      // atau asumsikan jpeg/png.
      String mimeType = 'image/jpeg'; // Default
      if (imageFile.path.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (imageFile.path.endsWith('.webp')) {
        mimeType = 'image/webp';
      }
      // Anda bisa menggunakan paket 'mime' untuk deteksi tipe MIME yang lebih akurat jika perlu.

      final imagePart = DataPart(mimeType, imageBytes);

      // 4. Buat permintaan ke Gemini API
      print(
        "IngredientDetectionRemoteDatasourceImpl: Mengirim permintaan ke Gemini API...",
      );
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart]), // Mengirim prompt teks dan gambar
      ]);

      // 5. Proses respons
      final String? textResponse = response.text;
      print(
        "IngredientDetectionRemoteDatasourceImpl: Menerima respons dari Gemini API: $textResponse",
      );

      if (textResponse == null || textResponse.trim().isEmpty) {
        print(
          "IngredientDetectionRemoteDatasourceImpl: Tidak ada bahan terdeteksi atau respons kosong.",
        );
        return []; // Kembalikan list kosong jika tidak ada bahan terdeteksi
      }

      // Pisahkan string respons berdasarkan koma menjadi list
      // dan bersihkan spasi ekstra dari setiap item.
      List<String> ingredients =
          textResponse
              .split(',')
              .map(
                (ingredient) => ingredient.trim().toLowerCase(),
              ) // Normalisasi ke huruf kecil
              .where(
                (ingredient) => ingredient.isNotEmpty,
              ) // Hapus item kosong jika ada
              .toList();

      // Hapus duplikat jika ada
      ingredients = ingredients.toSet().toList();

      print(
        "IngredientDetectionRemoteDatasourceImpl: Bahan terdeteksi: $ingredients",
      );
      return ingredients;
    } on GenerativeAIException catch (e) {
      print(
        "IngredientDetectionRemoteDatasourceImpl: Error GenerativeAIException - ${e.message}",
      );
      // Anda bisa memetakan error ini ke custom exception atau pesan yang lebih ramah pengguna
      throw Exception(
        "Gagal mendeteksi bahan dari gambar (API Error): ${e.message}",
      );
    } catch (e) {
      print(
        "IngredientDetectionRemoteDatasourceImpl: Error umum saat deteksi bahan: $e",
      );
      throw Exception("Terjadi error tidak diketahui saat memproses gambar.");
    }
  }
}
