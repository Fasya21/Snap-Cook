import 'dart:io'; // Untuk File
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart'; // Untuk ImageSource
import 'package:myapp/domain/entities/recipe.dart'; // Sesuaikan 'myapp'
import 'package:myapp/domain/usecases/detect_ingredients_usecase.dart'; // Sesuaikan 'myapp'
import 'package:myapp/domain/repositories/recipe_repository.dart'; // Untuk mengambil semua resep

part 'recipe_detection_state.dart'; // Menghubungkan dengan file state

class RecipeDetectionCubit extends Cubit<RecipeDetectionState> {
  final DetectIngredientsUseCase _detectIngredientsUseCase;
  final RecipeRepository
  _recipeRepository; // Untuk mengambil semua resep dari Firestore
  final ImagePicker _imagePicker; // Instance ImagePicker

  RecipeDetectionCubit({
    required DetectIngredientsUseCase detectIngredientsUseCase,
    required RecipeRepository recipeRepository,
  }) : _detectIngredientsUseCase = detectIngredientsUseCase,
       _recipeRepository = recipeRepository,
       _imagePicker = ImagePicker(), // Inisialisasi ImagePicker
       super(RecipeDetectionInitial());

  // Method untuk memilih gambar
  Future<void> pickImage(ImageSource source) async {
    emit(RecipeDetectionImageLoading());
    try {
      final XFile? imageXFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1000,
      );
      if (imageXFile != null) {
        final imageFile = File(imageXFile.path);
        print("RecipeDetectionCubit: Gambar dipilih - ${imageFile.path}");
        emit(RecipeDetectionImagePicked(imageFile));
      } else {
        print("RecipeDetectionCubit: Tidak ada gambar dipilih.");
        emit(
          RecipeDetectionInitial(),
        ); // Kembali ke initial jika tidak ada gambar
      }
    } catch (e) {
      print("RecipeDetectionCubit: Error saat memilih gambar - $e");
      emit(RecipeDetectionError("Gagal memilih gambar: ${e.toString()}"));
    }
  }

  // Method untuk memproses gambar yang sudah dipilih (dari state ImagePicked)
  // atau bahan manual
  Future<void> processInput({
    File? imageFile,
    List<String>? manualIngredients,
  }) async {
    if (imageFile == null &&
        (manualIngredients == null || manualIngredients.isEmpty)) {
      emit(const RecipeDetectionError("Tidak ada input untuk diproses."));
      return;
    }

    emit(const RecipeDetectionProcessing(message: "Mempersiapkan bahan..."));

    List<String> detectedIngredients = [];

    try {
      if (imageFile != null) {
        emit(
          const RecipeDetectionProcessing(
            message: "Mendeteksi bahan dari gambar...",
          ),
        );
        detectedIngredients = await _detectIngredientsUseCase.call(imageFile);
        print(
          "RecipeDetectionCubit: Bahan dari gambar via UseCase: $detectedIngredients",
        );
        if (detectedIngredients.isEmpty) {
          emit(
            RecipeDetectionNoMatch([], imageFile: imageFile),
          ); // Tidak ada bahan dari gambar
          return;
        }
        emit(
          RecipeDetectionIngredientsDetected(
            detectedIngredients,
            imageFile: imageFile,
          ),
        );
      } else if (manualIngredients != null && manualIngredients.isNotEmpty) {
        detectedIngredients = manualIngredients;
        print(
          "RecipeDetectionCubit: Bahan dari input manual: $detectedIngredients",
        );
        // Tidak perlu emit RecipeDetectionIngredientsDetected khusus untuk manual, langsung ke matching
      }

      emit(RecipeDetectionProcessing(message: "Mencari resep yang cocok..."));
      // 1. Ambil semua resep dari Firestore
      final List<Recipe> allRecipes = await _recipeRepository.getAllRecipes();
      print(
        "RecipeDetectionCubit: Mendapatkan ${allRecipes.length} resep dari repository.",
      );

      // 2. Logika pencocokan resep (minimal 3 bahan)
      List<Recipe> matchedRecipes = [];
      if (detectedIngredients.isNotEmpty && allRecipes.isNotEmpty) {
        for (var recipe in allRecipes) {
          int matchCount = 0;
          // Normalisasi bahan resep dan bahan terdeteksi ke huruf kecil untuk pencocokan
          final recipeIngredientsLower =
              recipe.ingredients.map((e) => e.toLowerCase()).toList();
          final detectedIngredientsLower =
              detectedIngredients.map((e) => e.toLowerCase()).toList();

          for (var detectedIngredient in detectedIngredientsLower) {
            if (recipeIngredientsLower.any(
              (recipeIngredient) =>
                  recipeIngredient.contains(detectedIngredient) ||
                  detectedIngredient.contains(recipeIngredient),
            )) {
              matchCount++;
            }
          }
          if (matchCount >= 3) {
            matchedRecipes.add(recipe);
          }
        }
      }

      print(
        "RecipeDetectionCubit: Jumlah resep cocok: ${matchedRecipes.length}",
      );
      if (matchedRecipes.isNotEmpty) {
        emit(
          RecipeDetectionSuccess(
            matchedRecipes,
            detectedIngredients,
            imageFile: imageFile,
          ),
        );
      } else {
        emit(RecipeDetectionNoMatch(detectedIngredients, imageFile: imageFile));
      }
    } catch (e) {
      print("RecipeDetectionCubit: Error saat memproses input - $e");
      emit(
        RecipeDetectionError(
          "Gagal memproses permintaan: ${e.toString()}",
          imageFile: imageFile,
        ),
      );
    }
  }

  // Method untuk mereset state ke initial
  void resetDetection() {
    emit(RecipeDetectionInitial());
  }
}
// **Penjelasan `RecipeDetectionCubit`:**
// * **Dependensi**: Menerima `DetectIngredientsUseCase` dan `RecipeRepository`.
// * **`_imagePicker`**: Instance untuk memilih gambar.
// * **`pickImage(ImageSource source)`**:
//     * Meng-emit `RecipeDetectionImageLoading`.
//     * Memanggil `_imagePicker.pickImage`.
//     * Jika berhasil, meng-emit `RecipeDetectionImagePicked` dengan `File` gambar.
//     * Jika gagal atau dibatalkan, kembali ke `RecipeDetectionInitial` atau `RecipeDetectionError`.
// * **`processInput({File? imageFile, List<String>? manualIngredients})`**:
//     * Ini adalah method utama untuk memulai proses deteksi dan pencocokan.
//     * Meng-emit `RecipeDetectionProcessing`.
//     * **Jika `imageFile` ada**: Memanggil `_detectIngredientsUseCase` untuk mendapatkan bahan. Jika tidak ada bahan, emit `RecipeDetectionNoMatch`.
//     * **Jika `manualIngredients` ada**: Menggunakan bahan tersebut.
//     * **Mengambil Semua Resep**: Memanggil `_recipeRepository.getAllRecipes()` untuk mendapatkan semua resep dari Firestore.
//     * **Logika Pencocokan**: Melakukan iterasi untuk membandingkan `detectedIngredients` dengan `recipe.ingredients` dari setiap resep. Pencocokan dilakukan secara case-insensitive dan menggunakan `contains` untuk fleksibilitas (misalnya, "bawang" akan cocok dengan "bawang merah"). Minimal 3 bahan harus cocok.
//     * Meng-emit `RecipeDetectionSuccess` jika ada resep yang cocok, atau `RecipeDetectionNoMatch` jika tidak.
//     * Meng-emit `RecipeDetectionError` jika ada kesalahan.
// * **`resetDetection()`**: Untuk mengembalikan state ke awal, misalnya jika pengguna ingin memulai deteksi baru.