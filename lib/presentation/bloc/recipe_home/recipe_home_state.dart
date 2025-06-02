part of 'recipe_home_cubit.dart'; // Akan kita buat file recipe_home_cubit.dart selanjutnya

abstract class RecipeHomeState extends Equatable {
  const RecipeHomeState();

  @override
  List<Object?> get props => [];
}

// State awal, sebelum resep dimuat
class RecipeHomeInitial extends RecipeHomeState {}

// State ketika resep sedang dimuat dari sumber data
class RecipeHomeLoading extends RecipeHomeState {}

// State ketika resep berhasil dimuat
class RecipeHomeLoaded extends RecipeHomeState {
  final List<Recipe> recipes; // Menyimpan daftar resep yang berhasil dimuat

  const RecipeHomeLoaded(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

// State ketika terjadi error saat memuat resep
class RecipeHomeError extends RecipeHomeState {
  final String message;

  const RecipeHomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// **Penjelasan:**
// * `part of 'recipe_home_cubit.dart';`: Menghubungkan file state ini dengan file Cubit.
// * `RecipeHomeState`: Class dasar abstrak.
// * `RecipeHomeInitial`: State awal.
// * `RecipeHomeLoading`: Saat sedang mengambil data.
// * `RecipeHomeLoaded`: Saat data berhasil diambil, membawa `List<Recipe>`.
// * `RecipeHomeError`: Jika terjadi kesalahan, membawa pesan error.