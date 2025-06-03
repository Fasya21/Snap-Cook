import 'dart:io'; // Untuk tipe data File

// Mendefinisikan kontrak (interface) untuk IngredientDetectionRepository
abstract class IngredientDetectionRepository {
  // Mengembalikan Future yang berisi List<String> dari bahan-bahan yang terdeteksi.
  Future<List<String>> detectIngredients(File imageFile);
}
