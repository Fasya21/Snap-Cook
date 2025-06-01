import 'package:myapp/domain/entities/recipe.dart'; // Sesuaikan 'snap_cook' dengan nama paket proyek Anda
import 'package:myapp/domain/repositories/recipe_repository.dart';
// Mungkin perlu import 'package:dartz/dartz.dart'; dan Failure class jika menggunakan Either

// Use case untuk mendapatkan satu resep berdasarkan ID
class GetRecipeByIdUseCase {
  final RecipeRepository repository;

  GetRecipeByIdUseCase(this.repository);

  // Method 'call' menerima parameter ID resep yang dicari
  Future<Recipe?> call(String id) async {
    // Memanggil method dari repository untuk mendapatkan resep berdasarkan ID
    print(
      "GetRecipeByIdUseCase: Memanggil repository.getRecipeById() untuk ID: $id",
    );
    return await repository.getRecipeById(id);
    // Jika menggunakan Either:
    // return await repository.getRecipeById(id); --> akan mengembalikan Future<Either<Failure, Recipe?>>
  }
}
