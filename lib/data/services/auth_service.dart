import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  // Konstruktor, menerima instance FirebaseAuth
  // Ini memungkinkan kita untuk melakukan testing dengan mock FirebaseAuth jika diperlukan.
  AuthService(this._firebaseAuth);

  // Mendapatkan stream perubahan status autentikasi pengguna
  // Stream ini akan memberitahu kita setiap kali pengguna login atau logout.
  Stream<User?> get authStateChanges {
    print(
      "DEBUG: AuthService: Getter authStateChanges DIAKSES.",
    ); // <-- PRINT 5
    return _firebaseAuth.authStateChanges();
  }

  // Mendapatkan pengguna yang sedang login saat ini (jika ada)
  User? get currentUser => _firebaseAuth.currentUser;

  // Fungsi untuk Sign Up dengan Email dan Password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print("AuthService: Mencoba mendaftar dengan email: $email");
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(), // .trim() untuk menghapus spasi di awal/akhir
            password: password,
          );
      print(
        "AuthService: Pendaftaran berhasil untuk UID: ${userCredential.user?.uid}",
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Tangani error spesifik dari Firebase Auth
      print(
        "AuthService: Error saat pendaftaran - Kode: ${e.code}, Pesan: ${e.message}",
      );
      // Anda bisa melempar custom exception di sini atau mengembalikan null/pesan error
      // Contoh: throw SignUpFailure.fromCode(e.code);
      rethrow; // Melempar kembali error Firebase agar bisa ditangani di lapisan atas (Cubit)
    } catch (e) {
      print("AuthService: Error umum saat pendaftaran: $e");
      rethrow; // Melempar kembali error umum
    }
  }

  // Fungsi untuk Sign In dengan Email dan Password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print("AuthService: Mencoba login dengan email: $email");
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      print(
        "AuthService: Login berhasil untuk UID: ${userCredential.user?.uid}",
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(
        "AuthService: Error saat login - Kode: ${e.code}, Pesan: ${e.message}",
      );
      // Contoh: throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
      rethrow;
    } catch (e) {
      print("AuthService: Error umum saat login: $e");
      rethrow;
    }
  }

  // Fungsi untuk Sign Out
  Future<void> signOut() async {
    try {
      print("AuthService: Mencoba logout pengguna UID: ${currentUser?.uid}");
      await _firebaseAuth.signOut();
      print("AuthService: Logout berhasil.");
    } catch (e) {
      print("AuthService: Error saat logout: $e");
      // Anda bisa menangani error ini atau melemparnya jika perlu
      rethrow;
    }
  }

  // Nantinya bisa ditambahkan fungsi lain, seperti:
  // - Sign in with Google
  // - Reset password
  // - Update email/password pengguna
}
