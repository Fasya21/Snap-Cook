import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/domain/entities/recipe.dart'; // Sesuaikan 'myapp' dengan nama paket Anda
import 'package:myapp/domain/usecases/get_all_recipes_usecase.dart'; // Sesuaikan 'myapp'

part 'recipe_home_state.dart'; // Menghubungkan dengan file state

class RecipeHomeCubit extends Cubit<RecipeHomeState> {
  final GetAllRecipesUseCase _getAllRecipesUseCase;

  RecipeHomeCubit({required GetAllRecipesUseCase getAllRecipesUseCase})
    : _getAllRecipesUseCase = getAllRecipesUseCase,
      super(RecipeHomeInitial());

  // Method untuk memuat semua resep
  Future<void> loadRecipes() async {
    emit(RecipeHomeLoading());
    try {
      print("RecipeHomeCubit: Memanggil _getAllRecipesUseCase...");
      final List<Recipe> recipes = await _getAllRecipesUseCase.call();
      // Atau bisa juga: final List<Recipe> recipes = await _getAllRecipesUseCase();

      print(
        "RecipeHomeCubit: Resep berhasil dimuat, jumlah: ${recipes.length}",
      );
      if (recipes.isEmpty) {
        print("RecipeHomeCubit: Tidak ada resep yang ditemukan.");
        // Anda bisa membuat state khusus untuk 'RecipeHomeEmpty' jika mau
        emit(
          const RecipeHomeLoaded([]),
        ); // Atau emit RecipeHomeError("Tidak ada resep ditemukan.")
      } else {
        emit(RecipeHomeLoaded(recipes));
      }
    } catch (e) {
      print("RecipeHomeCubit: Error saat memuat resep - ${e.toString()}");
      emit(RecipeHomeError("Gagal memuat resep: ${e.toString()}"));
    }
  }
}
