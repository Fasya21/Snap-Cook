import 'package:myapp/data/datasources/recipe_local_datasource.dart'; // Impor datasource lokal kita
import 'package:myapp/domain/entities/recipe.dart'; // Impor model Recipe
import 'package:myapp/domain/repositories/recipe_repository.dart'; // Impor interface repository
// Mungkin perlu import 'package:dartz/dartz.dart'; dan Failure class jika menggunakan Either

// Implementasi konkret dari RecipeRepository
class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeLocalDatasource localDatasource;
  // Nantinya bisa ditambahkan remoteDatasource jika ada API
  // final RecipeRemoteDatasource remoteDatasource;
  // Dan juga NetworkInfo untuk mengecek koneksi internet
  // final NetworkInfo networkInfo;

  RecipeRepositoryImpl({
    required this.localDatasource,
    // required this.remoteDatasource,
    // required this.networkInfo,
  });

  @override
  Future<List<Recipe>> getAllRecipes() async {
    // Untuk saat ini, kita hanya mengambil dari datasource lokal
    // Nantinya, di sini bisa ada logika untuk menentukan apakah mengambil dari cache,
    // datasource lokal, atau remote API berdasarkan kondisi koneksi internet, dll.
    try {
      print("RecipeRepositoryImpl: Memanggil localDatasource.getAllRecipes()");
      final recipes = await localDatasource.getAllRecipes();
      print(
        "RecipeRepositoryImpl: Menerima ${recipes.length} resep dari localDatasource",
      );
      return recipes;
    } catch (e) {
      // Tangani error dari datasource atau lempar kembali sebagai tipe Failure yang lebih spesifik
      print("RecipeRepositoryImpl: Error saat getAllRecipes - $e");
      throw Exception(
        'Gagal mendapatkan semua resep: $e',
      ); // Contoh error handling sederhana
      // return Left(ServerFailure()); // Jika menggunakan Either
    }
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      print(
        "RecipeRepositoryImpl: Memanggil localDatasource.getRecipeById() untuk ID: $id",
      );
      final recipe = await localDatasource.getRecipeById(id);
      if (recipe != null) {
        print("RecipeRepositoryImpl: Resep dengan ID '$id' ditemukan.");
      } else {
        print(
          "RecipeRepositoryImpl: Resep dengan ID '$id' TIDAK ditemukan oleh localDatasource.",
        );
      }
      return recipe;
    } catch (e) {
      print(
        "RecipeRepositoryImpl: Error saat getRecipeById untuk ID '$id' - $e",
      );
      throw Exception('Gagal mendapatkan resep berdasarkan ID: $e');
      // return Left(ServerFailure()); // Jika menggunakan Either
    }
  }

  // Implementasi fungsi lain dari RecipeRepository akan ada di sini
}
