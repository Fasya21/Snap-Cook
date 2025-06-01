import 'package:flutter/material.dart';
import 'package:myapp/presentation/navigation/app_router.dart';
import 'package:myapp/di_container.dart'
    as di; // Import file DI kita dengan alias 'di'

Future<void> main() async {
  // Pastikan Flutter binding sudah diinisialisasi jika ada operasi async sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Panggil fungsi inisialisasi Dependency Injection
  await di.initDI();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan warna tema utama aplikasi Anda di sini jika ingin konsisten
    final Color primaryColor = const Color(
      0xFF4CAF50,
    ); // Hijau dari LoginScreen
    final Color accentColor = const Color(
      0xFFFF9800,
    ); // Oranye dari LoginScreen

    return MaterialApp(
      title: 'Snap Cook',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: accentColor, // Dulu disebut accentColor
        ),
        scaffoldBackgroundColor:
            Colors.grey[100], // Latar belakang umum scaffold
        fontFamily:
            'Poppins', // Contoh penggunaan font kustom (opsional, perlu di-setup)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white, // Warna teks pada ElevatedButton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: primaryColor.withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor, // Warna teks untuk TextButton
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white, // Warna ikon dan teks di AppBar
          elevation: 0, // AppBar modern biasanya flat
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600, // Sedikit tebal
          ),
        ),
        // Anda bisa menambahkan konfigurasi tema lainnya di sini
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      onGenerateRoute:
          AppRouter.generateRoute, // Menggunakan router kustom Anda
      initialRoute: '/login', // Mengatur halaman login sebagai halaman awal
    );
  }
}
