// import 'package:myapp/data/datasources/recipe_local_datasource.dart'; // Impor datasource lokal kita
import 'package:myapp/data/datasources/recipe_remote_datasource.dart';
import 'package:myapp/domain/entities/recipe.dart'; // Impor model Recipe
import 'package:myapp/domain/repositories/recipe_repository.dart'; // Impor interface repository
// Mungkin perlu import 'package:dartz/dartz.dart'; dan Failure class jika menggunakan Either

// Implementasi konkret dari RecipeRepository
class RecipeRepositoryImpl implements RecipeRepository {
  // final RecipeLocalDatasource localDatasource;
  final RecipeRemoteDatasource remoteDatasource; // Gunakan remote datasource
  // Nantinya bisa ditambahkan remoteDatasource jika ada API
  // final RecipeRemoteDatasource remoteDatasource;
  // Dan juga NetworkInfo untuk mengecek koneksi internet
  // final NetworkInfo networkInfo;

  RecipeRepositoryImpl({
    // required this.localDatasource,
    required this.remoteDatasource,
    // required this.remoteDatasource,
    // required this.networkInfo,
  });

  @override
  Future<List<Recipe>> getAllRecipes() async {
    try {
      print("RecipeRepositoryImpl: Memanggil remoteDatasource.getAllRecipes()");
      // Sekarang mengambil dari remote datasource
      final recipes = await remoteDatasource.getAllRecipes();
      print(
        "RecipeRepositoryImpl: Menerima ${recipes.length} resep dari remoteDatasource",
      );
      return recipes;
    } catch (e) {
      print("RecipeRepositoryImpl: Error saat getAllRecipes - $e");
      throw Exception('Gagal mendapatkan semua resep dari repository: $e');
    }
  }
  // Future<List<Recipe>> getAllRecipes() async {
  //   // datasource lokal, atau remote API berdasarkan kondisi koneksi internet, dll.
  //   try {
  //     print("RecipeRepositoryImpl: Memanggil localDatasource.getAllRecipes()");
  //     final recipes = await localDatasource.getAllRecipes();
  //     print(
  //       "RecipeRepositoryImpl: Menerima ${recipes.length} resep dari localDatasource",
  //     );
  //     return recipes;
  //   } catch (e) {
  //     // Tangani error dari datasource atau lempar kembali sebagai tipe Failure yang lebih spesifik
  //     print("RecipeRepositoryImpl: Error saat getAllRecipes - $e");
  //     throw Exception(
  //       'Gagal mendapatkan semua resep: $e',
  //     ); // Contoh error handling sederhana
  //     // return Left(ServerFailure()); // Jika menggunakan Either
  //   }
  // }

  @override
  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      print(
        "RecipeRepositoryImpl: Memanggil remoteDatasource.getRecipeById() untuk ID: $id",
      );
      // Sekarang mengambil dari remote datasource
      final recipe = await remoteDatasource.getRecipeById(id);
      if (recipe != null) {
        print(
          "RecipeRepositoryImpl: Resep dengan ID '$id' ditemukan via remote.",
        );
      } else {
        print(
          "RecipeRepositoryImpl: Resep dengan ID '$id' TIDAK ditemukan oleh remoteDatasource.",
        );
      }
      return recipe;
    } catch (e) {
      print(
        "RecipeRepositoryImpl: Error saat getRecipeById untuk ID '$id' - $e",
      );
      throw Exception(
        'Gagal mendapatkan resep berdasarkan ID dari repository: $e',
      );
    }
  }
  // Future<Recipe?> getRecipeById(String id) async {
  //   try {
  //     print(
  //       "RecipeRepositoryImpl: Memanggil localDatasource.getRecipeById() untuk ID: $id",
  //     );
  //     final recipe = await localDatasource.getRecipeById(id);
  //     if (recipe != null) {
  //       print("RecipeRepositoryImpl: Resep dengan ID '$id' ditemukan.");
  //     } else {
  //       print(
  //         "RecipeRepositoryImpl: Resep dengan ID '$id' TIDAK ditemukan oleh localDatasource.",
  //       );
  //     }
  //     return recipe;
  //   } catch (e) {
  //     print(
  //       "RecipeRepositoryImpl: Error saat getRecipeById untuk ID '$id' - $e",
  //     );
  //     throw Exception('Gagal mendapatkan resep berdasarkan ID: $e');
  //     // return Left(ServerFailure()); // Jika menggunakan Either
  //   }
  // }

  // Implementasi fungsi lain dari RecipeRepository akan ada di sini
}
