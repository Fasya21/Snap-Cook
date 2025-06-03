part of 'recipe_detection_cubit.dart'; // Akan kita buat file recipe_detection_cubit.dart selanjutnya

abstract class RecipeDetectionState extends Equatable {
  const RecipeDetectionState();

  @override
  List<Object?> get props => [];
}

// State awal, sebelum ada aksi
class RecipeDetectionInitial extends RecipeDetectionState {}

// State ketika sedang memilih atau memuat gambar
class RecipeDetectionImageLoading extends RecipeDetectionState {}

// State ketika gambar berhasil dipilih dan siap diproses
class RecipeDetectionImagePicked extends RecipeDetectionState {
  final File imageFile;

  const RecipeDetectionImagePicked(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

// State ketika sedang memproses gambar ke API Gemini dan/atau mencocokkan resep
class RecipeDetectionProcessing extends RecipeDetectionState {
  final String
  message; // Pesan progres, misal "Mendeteksi bahan...", "Mencari resep..."
  const RecipeDetectionProcessing({this.message = "Memproses..."});

  @override
  List<Object?> get props => [message];
}

// State ketika bahan berhasil dideteksi dari gambar
// Mungkin tidak langsung ditampilkan ke user, tapi berguna sebagai state antara
class RecipeDetectionIngredientsDetected extends RecipeDetectionState {
  final List<String> ingredients;
  final File? imageFile; // Opsional, untuk tetap menampilkan gambar

  const RecipeDetectionIngredientsDetected(this.ingredients, {this.imageFile});

  @override
  List<Object?> get props => [ingredients, imageFile];
}

// State ketika resep yang cocok berhasil ditemukan
class RecipeDetectionSuccess extends RecipeDetectionState {
  final List<Recipe> matchedRecipes;
  final List<String> detectedIngredients; // Bahan yang digunakan untuk mencari
  final File? imageFile; // Opsional, untuk tetap menampilkan gambar

  const RecipeDetectionSuccess(
    this.matchedRecipes,
    this.detectedIngredients, {
    this.imageFile,
  });

  @override
  List<Object?> get props => [matchedRecipes, detectedIngredients, imageFile];
}

// State ketika tidak ada resep yang cocok ditemukan
class RecipeDetectionNoMatch extends RecipeDetectionState {
  final List<String> detectedIngredients;
  final File? imageFile;

  const RecipeDetectionNoMatch(this.detectedIngredients, {this.imageFile});

  @override
  List<Object?> get props => [detectedIngredients, imageFile];
}

// State ketika terjadi error selama proses
class RecipeDetectionError extends RecipeDetectionState {
  final String message;
  final File?
  imageFile; // Opsional, untuk tetap menampilkan gambar jika error terjadi setelah gambar dipilih

  const RecipeDetectionError(this.message, {this.imageFile});

  @override
  List<Object?> get props => [message, imageFile];
}
// **Penjelasan State:**
// * `RecipeDetectionInitial`: Kondisi awal.
// * `RecipeDetectionImageLoading`: Saat sedang memuat gambar (misalnya, saat `ImagePicker` aktif).
// * `RecipeDetectionImagePicked`: Setelah gambar berhasil dipilih, state ini akan membawa `File` gambar tersebut. UI bisa menampilkan pratinjau dari sini.
// * `RecipeDetectionProcessing`: Saat sedang mengirim gambar ke Gemini API atau saat sedang mencocokkan resep. Bisa membawa pesan progres.
// * `RecipeDetectionIngredientsDetected`: Setelah API Gemini mengembalikan daftar bahan. Mungkin tidak langsung ditampilkan, tapi berguna sebagai state antara sebelum pencocokan resep.
// * `RecipeDetectionSuccess`: Jika resep yang cocok ditemukan, state ini membawa daftar `Recipe` yang cocok dan bahan yang digunakan untuk mencari.
// * `RecipeDetectionNoMatch`: Jika bahan terdeteksi tetapi tidak ada resep yang cocok.
// * `RecipeDetectionError`: Jika terjadi kesalahan pada tahap mana pun (pemilihan gambar, pemanggilan API, pencocokan resep), state ini membawa pesan error.