import 'package:get_it/get_it.dart';
import 'package:myapp/data/datasources/recipe_local_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/repositories/recipe_repository_impl.dart';
import 'package:myapp/data/services/auth_service.dart';
import 'package:myapp/domain/repositories/recipe_repository.dart';
import 'package:myapp/domain/usecases/get_all_recipes_usecase.dart';
import 'package:myapp/domain/usecases/get_recipe_by_id_usecase.dart';
import 'package:myapp/presentation/bloc/auth/auth_cubit.dart';
// Import Cubit akan ditambahkan di sini nanti
// import 'package:snap_cook/presentation/bloc/recipe_cubit.dart'; // Contoh path

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

  // Services
  sl.registerLazySingleton(
    () => AuthService(sl()),
  ); // sl() akan resolve FirebaseAuth

  // Use Cases
  sl.registerLazySingleton(() => GetAllRecipesUseCase(sl()));
  sl.registerLazySingleton(() => GetRecipeByIdUseCase(sl()));

  // Repositories
  // Kita mendaftarkan implementasi (RecipeRepositoryImpl) untuk interface (RecipeRepository).
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(localDatasource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<RecipeLocalDatasource>(
    () => RecipeLocalDatasourceImpl(),
  );

  // External / Core Firebase
  // Mendaftarkan instance FirebaseAuth sebagai singleton
  // agar bisa di-inject ke AuthService atau service lain jika perlu.
  // External / Core Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  print("Dependency Injection Initialized with AuthCubit and Auth Service");

  // External (Contoh jika ada dependensi eksternal seperti HTTP client, SharedPreferences, dll.)
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());

  print("Dependency Injection Initialized");
}
