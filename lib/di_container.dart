import 'package:get_it/get_it.dart';
// import 'package:myapp/data/datasources/recipe_local_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/datasources/recipe_remote_datasource.dart';
import 'package:myapp/data/repositories/recipe_repository_impl.dart';
import 'package:myapp/data/services/auth_service.dart';
// import 'package:myapp/domain/entities/recipe.dart';
import 'package:myapp/domain/repositories/recipe_repository.dart';
import 'package:myapp/domain/usecases/get_all_recipes_usecase.dart';
import 'package:myapp/domain/usecases/get_recipe_by_id_usecase.dart';
import 'package:myapp/presentation/bloc/auth/auth_cubit.dart';
import 'package:myapp/presentation/bloc/recipe_home/recipe_home_cubit.dart';
import 'package:myapp/domain/repositories/ingredient_detection_repository.dart';
import 'package:myapp/data/repositories/ingredient_detection_repository_impl.dart';
import 'package:myapp/data/datasources/ingredient_detection_remote_datasource.dart';
import 'package:myapp/domain/usecases/detect_ingredients_usecase.dart';
import 'package:myapp/presentation/bloc/recipe_detection/recipe_detection_cubit.dart';

// Membuat instance global dari GetIt (Service Locator)
final sl = GetIt.instance; // sl adalah singkatan dari Service Locator

Future<void> initDI() async {
  // Fungsi ini akan mendaftarkan semua dependensi kita

  // Blocs / Cubits (Akan ditambahkan nanti)
  // sl.registerFactory(() => RecipeCubit(getAllRecipesUseCase: sl(), getRecipeByIdUseCase: sl()));
  // 'registerFactory' berarti setiap kali kita meminta RecipeCubit, instance baru akan dibuat.
  // Jika ingin singleton (satu instance saja), gunakan 'registerSingleton' atau 'registerLazySingleton'.

  // Blocs / Cubits (Akan ditambahkan nanti)
  // Ini umum untuk Cubit/Bloc yang terkait dengan UI tertentu.
  sl.registerFactory(
    () => AuthCubit(sl()),
  ); // sl() akan otomatis me-resolve AuthService
  sl.registerFactory(() => RecipeHomeCubit(getAllRecipesUseCase: sl()));
  sl.registerFactory(
    () => RecipeDetectionCubit(
      // <-- DAFTARKAN RECIPE DETECTION CUBIT
      detectIngredientsUseCase: sl(),
      recipeRepository: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(
    () => AuthService(sl()),
  ); // sl() akan resolve FirebaseAuth

  // Use Cases
  sl.registerLazySingleton(() => GetAllRecipesUseCase(sl()));
  sl.registerLazySingleton(() => GetRecipeByIdUseCase(sl()));
  sl.registerLazySingleton(() => DetectIngredientsUseCase(sl()));

  // Repositories
  // Kita mendaftarkan implementasi (RecipeRepositoryImpl) untuk interface (RecipeRepository).
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(remoteDatasource: sl()),
    // () => RecipeRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton<IngredientDetectionRepository>(
    // <-- PASTIKAN INI ADA DAN BENAR
    () => IngredientDetectionRepositoryImpl(
      remoteDatasource: sl(),
    ), // sl() akan me-resolve IngredientDetectionRemoteDatasource
  );

  // Data Sources
  sl.registerLazySingleton<RecipeRemoteDatasource>(
    // <-- DAFTARKAN REMOTE DATASOURCE
    () => RecipeRemoteDatasourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IngredientDetectionRemoteDatasource>(
    // Pastikan ini sudah terdaftar sebelumnya
    () => IngredientDetectionRemoteDatasourceImpl(),
  );
  // sl.registerLazySingleton<RecipeLocalDatasource>(
  //   () => RecipeLocalDatasourceImpl(),
  // );

  // External / Core Firebase
  // Mendaftarkan instance FirebaseAuth sebagai singleton
  // agar bisa di-inject ke AuthService atau service lain jika perlu.
  // External / Core Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  ); // <-- DAFTARKAN INSTANCE FIRESTORE

  // print("Dependency Injection Initialized with IngredientDetectionRepository");
  // print("Dependency Injection Initialized with DetectIngredientsUseCase");
  print("Dependency Injection Initialized with RecipeDetectionCubit");
}
