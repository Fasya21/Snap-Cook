import 'package:myapp/domain/entities/recipe.dart'; // Sesuaikan 'snap_cook' dengan nama paket proyek Anda
// Mungkin perlu import 'package:dartz/dartz.dart'; untuk Either jika ingin error handling yang lebih advanced

// Mendefinisikan kontrak (interface) untuk RecipeRepository
abstract class RecipeRepository {
  // Mengembalikan Future yang berisi List<Recipe>
  // Nantinya bisa diubah menjadi Future<Either<Failure, List<Recipe>>> untuk error handling
  Future<List<Recipe>> getAllRecipes();

  // Mengembalikan Future yang berisi Recipe tunggal (bisa null jika tidak ditemukan)
  // Nantinya bisa diubah menjadi Future<Either<Failure, Recipe?>>
  Future<Recipe?> getRecipeById(String id);

  // Nantinya bisa ditambahkan fungsi lain seperti:
  // Future<List<Recipe>> searchRecipes(String query);
  // Future<List<Recipe>> getRecipesByIngredients(List<String> ingredients);
  // Future<void> saveRecipe(Recipe recipe); // Jika ada fitur koleksi atau tambah resep
}
