import 'package:flutter/material.dart';
import 'package:myapp/domain/entities/recipe.dart'; // <-- PENTING: Impor model Recipe terpusat
import 'package:myapp/presentation/screens/home_screen.dart';
import 'package:myapp/presentation/screens/login_screen.dart';
import 'package:myapp/presentation/screens/recipe_detail_screen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myapp/presentation/bloc/recipe_home/recipe_home_cubit.dart';
// import 'package:myapp/di_container.dart' as di;
// Import halaman lain jika sudah ada (DetectionScreen, CollectionScreen, ProfileScreen)
// import 'package:myapp/presentation/screens/detection_screen.dart';
// import 'package:myapp/presentation/screens/collection_screen.dart';
// import 'package:myapp/presentation/screens/profile_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      // case '/home':
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => BlocProvider<RecipeHomeCubit>(
      //           create:
      //               (context) =>
      //                   di.sl<RecipeHomeCubit>()
      //                     ..loadRecipes(), // Buat dan langsung panggil loadRecipes
      //           child: const HomeScreen(),
      //         ),
      //   );
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/recipe-detail':
        // Sekarang 'Recipe' akan merujuk ke definisi dari domain/entities/recipe.dart
        final recipe = settings.arguments as Recipe;
        return MaterialPageRoute(
          builder: (_) => RecipeDetailScreen(recipe: recipe),
        );
      // case '/detection':
      //   return MaterialPageRoute(builder: (_) => const DetectionScreen());
      // case '/collection':
      //   return MaterialPageRoute(builder: (_) => const CollectionScreen());
      // case '/profile':
      //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text(
                    'Halaman tidak ditemukan untuk: ${settings.name}',
                  ),
                ),
              ),
        );
    }
  }
}
