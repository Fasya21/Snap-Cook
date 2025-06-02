part of 'auth_cubit.dart'; // Akan kita buat file auth_cubit.dart selanjutnya

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// State awal, sebelum ada interaksi autentikasi
class AuthInitial extends AuthState {}

// State ketika proses autentikasi sedang berjalan (loading)
class AuthLoading extends AuthState {}

// State ketika pengguna berhasil diautentikasi
class Authenticated extends AuthState {
  final User user; // Menyimpan objek User dari Firebase Auth

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// State ketika pengguna tidak terautentikasi (belum login atau sudah logout)
class Unauthenticated extends AuthState {}

// State ketika terjadi error saat proses autentikasi
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
    
// **Penjelasan:**
// * `part of 'auth_cubit.dart';`: Ini adalah direktif yang akan menghubungkan file state ini dengan file Cubit yang akan kita buat.
// * `AuthState`: Class abstrak dasar untuk semua state autentikasi. Menggunakan `Equatable` agar kita bisa membandingkan objek state.
// * `AuthInitial`: State awal.
// * `AuthLoading`: Saat proses login atau sign up sedang berlangsung.
// * `Authenticated`: Saat pengguna berhasil login. State ini membawa objek `User` dari Firebase.
// * `Unauthenticated`: Saat tidak ada pengguna yang login atau setelah logout.
// * `AuthError`: Jika terjadi kesalahan saat login atau sign up, state ini akan membawa pesan error.