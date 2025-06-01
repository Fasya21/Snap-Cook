import 'package:flutter/material.dart';
import 'package:myapp/presentation/screens/home_screen.dart';
import 'package:myapp/presentation/screens/login_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home': // <-- Tambahkan case ini
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // Tambahkan rute lain di sini nanti, misalnya:
      // case '/home':
      //   return MaterialPageRoute(builder: (_) => const HomeScreen());
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
