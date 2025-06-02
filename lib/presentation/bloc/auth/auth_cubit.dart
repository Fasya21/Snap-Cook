import 'dart:async'; // Untuk StreamSubscription
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk tipe data User
import 'package:myapp/data/services/auth_service.dart'; // Sesuaikan 'myapp' dengan nama paket Anda

part 'auth_state.dart'; // Menghubungkan dengan file state yang sudah kita buat

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit(this._authService) : super(AuthInitial()) {
    print("DEBUG: AuthCubit CONSTRUCTOR CALLED"); // <-- PRINT 1
    print(
      "DEBUG: AuthCubit: Menginisialisasi listener untuk authStateChanges...",
    ); // <-- PRINT 2

    _authStateSubscription = _authService.authStateChanges.listen((user) {
      print(
        "DEBUG: AuthCubit: Listener authStateChanges menerima event user: ${user?.uid}",
      ); // <-- PRINT 3 (INI YANG TIDAK MUNCUL)
      if (user != null) {
        // print("AuthCubit: Pengguna terautentikasi UID: ${user.uid}"); // Sudah ada
        emit(Authenticated(user));
      } else {
        // print("AuthCubit: Tidak ada pengguna terautentikasi."); // Sudah ada
        emit(Unauthenticated());
      }
    });
    print(
      "DEBUG: AuthCubit: Listener authStateChanges SELESAI diinisialisasi.",
    ); // <-- PRINT 4
  }

  // Method untuk mencoba sign up
  Future<void> signUp({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      UserCredential? userCredential = await _authService
          .signUpWithEmailAndPassword(email: email, password: password);
      if (userCredential?.user != null) {
        // State Authenticated akan di-emit oleh listener authStateChanges secara otomatis
        // Jadi tidak perlu emit Authenticated(userCredential.user!) di sini.
        print(
          "AuthCubit: Sign up berhasil, menunggu listener untuk emit Authenticated state.",
        );
      } else {
        // Ini seharusnya tidak terjadi jika signUpWithEmailAndPassword berhasil tanpa error
        emit(const AuthError("Pendaftaran gagal, pengguna tidak dibuat."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Terjadi error saat pendaftaran."));
    } catch (e) {
      emit(AuthError("Terjadi error tidak diketahui: ${e.toString()}"));
    }
  }

  // Method untuk mencoba sign in
  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      UserCredential? userCredential = await _authService
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential?.user != null) {
        // State Authenticated akan di-emit oleh listener authStateChanges
        print(
          "AuthCubit: Sign in berhasil, menunggu listener untuk emit Authenticated state.",
        );
      } else {
        // Ini seharusnya tidak terjadi jika signInWithEmailAndPassword berhasil tanpa error
        emit(const AuthError("Login gagal, pengguna tidak ditemukan."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Terjadi error saat login."));
    } catch (e) {
      emit(AuthError("Terjadi error tidak diketahui: ${e.toString()}"));
    }
  }

  // Method untuk sign out
  Future<void> signOut() async {
    emit(
      AuthLoading(),
    ); // Opsional, bisa langsung ke Unauthenticated jika proses cepat
    try {
      await _authService.signOut();
      // State Unauthenticated akan di-emit oleh listener authStateChanges
      print(
        "AuthCubit: Sign out berhasil, menunggu listener untuk emit Unauthenticated state.",
      );
    } catch (e) {
      emit(AuthError("Gagal melakukan logout: ${e.toString()}"));
    }
  }

  // Penting untuk membatalkan subscription saat Cubit tidak lagi digunakan
  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}

// **Penjelasan:**
// * **`AuthCubit(this._authService) : super(AuthInitial())`**: Konstruktor menerima `AuthService` (yang akan kita inject dari `get_it`) dan state awalnya adalah `AuthInitial`.
// * **`_authStateSubscription`**: Ini akan "mendengarkan" `_authService.authStateChanges`. Setiap kali ada perubahan status login (pengguna login atau logout), listener ini akan aktif:
//     * Jika `user` tidak `null`, berarti ada pengguna yang login, maka Cubit akan `emit(Authenticated(user))`.
//     * Jika `user` adalah `null`, berarti tidak ada pengguna yang login (atau baru saja logout), maka Cubit akan `emit(Unauthenticated())`.
// * **`signUp(...)`, `signIn(...)`, `signOut(...)`**: Method-method ini memanggil fungsi yang sesuai di `_authService`. Mereka pertama-tama `emit(AuthLoading())` untuk memberitahu UI bahwa proses sedang berjalan. Jika berhasil, kita mengandalkan `_authStateSubscription` untuk meng-update state ke `Authenticated` atau `Unauthenticated`. Jika gagal, mereka akan `emit(AuthError(...))` dengan pesan error.
// * **`close()`**: Method ini sangat penting. Saat `AuthCubit` tidak lagi digunakan (misalnya, saat halaman ditutup), kita perlu membatalkan `_authStateSubscription` untuk mencegah *memory leaks*.
