    import 'package:myapp/domain/entities/recipe.dart'; // Sesuaikan 'snap_cook' dengan nama paket proyek Anda
    import 'package:myapp/domain/repositories/recipe_repository.dart';
    // Mungkin perlu import 'package:dartz/dartz.dart'; dan Failure class jika menggunakan Either

    // Use case untuk mendapatkan semua resep
    class GetAllRecipesUseCase {
      final RecipeRepository repository;

      GetAllRecipesUseCase(this.repository);

      // Method 'call' memungkinkan class ini dipanggil seolah-olah sebuah fungsi
      // Contoh: final recipes = await getAllRecipesUseCase();
      Future<List<Recipe>> call() async {
        // Memanggil method dari repository untuk mendapatkan semua resep
        print("GetAllRecipesUseCase: Memanggil repository.getAllRecipes()");
        return await repository.getAllRecipes();
        // Jika menggunakan Either:
        // return await repository.getAllRecipes(); --> akan mengembalikan Future<Either<Failure, List<Recipe>>>
      }
    }
    