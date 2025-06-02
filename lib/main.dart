import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Impor BlocProvider
import 'package:myapp/presentation/navigation/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:myapp/di_container.dart' as di;
import 'package:myapp/presentation/bloc/auth/auth_cubit.dart'; // <-- Impor AuthCubit

import 'package:myapp/presentation/screens/login_screen.dart';
import 'package:myapp/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.initDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan warna tema utama aplikasi Anda di sini jika ingin konsisten
    final Color primaryColor = const Color(
      0xFFFF7043,
    ); // Warna aksen dari login
    final Color accentColor = const Color(0xFFFF7043);

    return BlocProvider<AuthCubit>(
      // <-- Sediakan AuthCubit di sini
      create:
          (context) =>
              di.sl<AuthCubit>(), // Mengambil instance AuthCubit dari GetIt
      child: MaterialApp(
        title: 'Snap Cook',
        theme: ThemeData(
          primaryColor: primaryColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: primaryColor,
            secondary: accentColor,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
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
            fillColor: const Color(0xFFFFF0E5), // Warna isian field input
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              // Border saat tidak fokus
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              // Border saat fokus
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            prefixIconColor: primaryColor.withOpacity(0.8),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 16.0,
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: primaryColor),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFFF5F7FA), // Latar belakang AppBar
            foregroundColor: const Color(
              0xFF212121,
            ), // Warna ikon dan teks di AppBar
            elevation: 0,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121), // Warna teks judul AppBar
            ),
          ),
          // Anda bisa menambahkan konfigurasi tema lainnya di sini
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        // Kita akan mengatur initialRoute berdasarkan state AuthCubit
        // Untuk sementara, biarkan seperti ini atau arahkan ke halaman "splash"
        // initialRoute: '/login', // Akan kita ubah
        home: AuthStateHandler(), // Widget baru untuk menangani state auth awal
      ),
    );
  }
}

// Widget baru untuk menangani navigasi berdasarkan state AuthCubit
class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Listener bisa digunakan untuk side effects seperti menampilkan SnackBar
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        print(
          "DEBUG: AuthStateHandler - Current State (Versi Sederhana): $state",
        );
        if (state is Authenticated) {
          print(
            "DEBUG: AuthStateHandler: State is Authenticated, returning HomeScreen.",
          );
          return const HomeScreen();
        } else if (state is Unauthenticated || state is AuthInitial) {
          print(
            "DEBUG: AuthStateHandler: State is Unauthenticated or Initial, returning LoginScreen.",
          );
          return const LoginScreen();
        } else if (state is AuthError) {
          print(
            "DEBUG: AuthStateHandler: State is AuthError, returning LoginScreen.",
          );
          return const LoginScreen();
        }
        print(
          "DEBUG: AuthStateHandler: State is Loading or unhandled, showing loading indicator.",
        );
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      // builder: (context, state) {
      //   if (state is Authenticated) {
      //     // Jika pengguna terautentikasi, arahkan ke HomeScreen
      //     // Kita gunakan Navigator.pushReplacementNamed agar pengguna tidak bisa kembali ke login
      //     // setelah berhasil login, kecuali jika ada tombol logout.
      //     // Namun, karena ini adalah 'home' dari MaterialApp, lebih baik langsung return HomeScreen.
      //     // Atau, jika Anda ingin menggunakan named routes, pastikan HomeScreen tidak bisa di-pop kembali ke LoginScreen.
      //     // Untuk kasus ini, karena ini adalah 'home' dari MaterialApp, kita bisa langsung return HomeScreen.
      //     // Atau, kita bisa membuat 'wrapper' yang mengembalikan HomeScreen dan memastikan rute /login tidak ada di stack.

      //     // Cara sederhana:
      //     // return const HomeScreen(); // Ini akan langsung menampilkan HomeScreen

      //     // Cara yang lebih baik untuk memastikan stack navigasi bersih:
      //     // Kita akan mengandalkan listener di LoginScreen atau stream di atas MaterialApp
      //     // Untuk saat ini, jika sudah authenticated, kita bisa langsung ke HomeScreen.
      //     // Navigasi yang lebih kompleks bisa diatur nanti.
      //     // Untuk memastikan navigasi yang bersih, kita bisa menggunakan Navigator di dalam builder ini
      //     // tapi itu bisa menyebabkan rebuild yang tidak perlu.
      //     // Solusi yang lebih umum adalah memiliki widget "AuthWrapper" atau "DecisionPage"
      //     // yang mendengarkan state dan mengembalikan halaman yang sesuai.

      //     // Untuk sekarang, mari kita buat sederhana:
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       if (ModalRoute.of(context)?.settings.name != '/home') {
      //         Navigator.of(
      //           context,
      //         ).pushNamedAndRemoveUntil('/home', (route) => false);
      //       }
      //     });
      //     return const Scaffold(
      //       body: Center(child: CircularProgressIndicator()),
      //     ); // Tampilan sementara saat navigasi
      //   } else if (state is Unauthenticated ||
      //       state is AuthInitial ||
      //       state is AuthError) {
      //     // Jika tidak terautentikasi atau state awal atau ada error, arahkan ke LoginScreen
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       if (ModalRoute.of(context)?.settings.name != '/login') {
      //         Navigator.of(
      //           context,
      //         ).pushNamedAndRemoveUntil('/login', (route) => false);
      //       }
      //     });
      //     return const Scaffold(
      //       body: Center(child: CircularProgressIndicator()),
      //     ); // Tampilan sementara saat navigasi
      //   }
      //   // State loading atau state lain yang belum ditangani
      //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
      // },
    );
  }
}

// ```
// **Perubahan di `main.dart`:**
// * `BlocProvider<AuthCubit>` ditambahkan untuk membungkus `MaterialApp`. `create: (context) => di.sl<AuthCubit>()` mengambil instance `AuthCubit` dari `get_it`.
// * `initialRoute` dihapus dari `MaterialApp` dan diganti dengan `home: AuthStateHandler()`.
// * **`AuthStateHandler`**: Widget baru ini menggunakan `BlocConsumer` untuk "mendengarkan" dan "membangun" UI berdasarkan `AuthState`.
//     * **`listener`**: Digunakan untuk *side effects* seperti menampilkan `SnackBar` saat ada `AuthError`.
//     * **`builder`**: Menentukan widget mana yang akan ditampilkan berdasarkan state:
//         * Jika `Authenticated`, ia akan mencoba menavigasi ke `/home`.
//         * Jika `Unauthenticated`, `AuthInitial`, atau `AuthError`, ia akan mencoba menavigasi ke `/login`.
//         * `WidgetsBinding.instance.addPostFrameCallback` digunakan untuk melakukan navigasi setelah frame pertama selesai dibangun untuk menghindari error. Ini adalah cara yang umum untuk menangani navigasi berdasarkan perubahan state di level atas.
//         * Tampilan `CircularProgressIndicator` sementara ditampilkan saat navigasi terjadi.
