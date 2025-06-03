import 'dart:io'; // Untuk tipe data File
import 'package:myapp/domain/repositories/ingredient_detection_repository.dart'; // Sesuaikan 'myapp' dengan nama paket proyek Anda
// Mungkin perlu import 'package:dartz/dartz.dart'; dan Failure class jika menggunakan Either

// Use case untuk mendeteksi bahan dari gambar
class DetectIngredientsUseCase {
  final IngredientDetectionRepository repository;

  DetectIngredientsUseCase(this.repository);

  // Method 'call' menerima File gambar sebagai parameter
  Future<List<String>> call(File imageFile) async {
    // Memanggil method dari repository untuk mendeteksi bahan
    print("DetectIngredientsUseCase: Memanggil repository.detectIngredients()");
    try {
      final ingredients = await repository.detectIngredients(imageFile);
      print(
        "DetectIngredientsUseCase: Menerima bahan dari repository: $ingredients",
      );
      return ingredients;
    } catch (e) {
      print("DetectIngredientsUseCase: Error saat memanggil repository - $e");
      // Melempar kembali error agar bisa ditangani oleh Cubit
      // Anda bisa juga mengubahnya menjadi tipe kembalian Either<Failure, List<String>> di sini
      rethrow;
    }
  }
}
