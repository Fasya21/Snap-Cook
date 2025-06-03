import 'dart:io'; // Untuk tipe data File
import 'package:myapp/data/datasources/ingredient_detection_remote_datasource.dart'; // Impor datasource kita
import 'package:myapp/domain/repositories/ingredient_detection_repository.dart'; // Impor interface repository
// import 'package:dartz/dartz.dart'; // Opsional untuk error handling
// import 'package:myapp/core/errors/failure.dart'; // Opsional untuk custom Failure class
// import 'package:myapp/core/network/network_info.dart'; // Opsional, untuk cek koneksi internet

// Implementasi konkret dari IngredientDetectionRepository
class IngredientDetectionRepositoryImpl
    implements IngredientDetectionRepository {
  final IngredientDetectionRemoteDatasource remoteDatasource;
  // final NetworkInfo? networkInfo; // Opsional

  IngredientDetectionRepositoryImpl({
    required this.remoteDatasource,
    // this.networkInfo, // Opsional
  });

  @override
  Future<List<String>> detectIngredients(File imageFile) async {
    // Opsional: Cek koneksi internet sebelum memanggil API
    // if (networkInfo != null && await networkInfo!.isConnected) {
    try {
      print(
        "IngredientDetectionRepositoryImpl: Memanggil remoteDatasource.detectIngredientsFromImage()",
      );
      final List<String> detectedIngredients = await remoteDatasource
          .detectIngredientsFromImage(imageFile);
      print(
        "IngredientDetectionRepositoryImpl: Bahan terdeteksi dari remote: $detectedIngredients",
      );
      return detectedIngredients;
      // return Right(detectedIngredients); // Jika menggunakan Either
    } catch (e) {
      print(
        "IngredientDetectionRepositoryImpl: Error saat detectIngredients - $e",
      );
      // Anda bisa melempar custom exception di sini atau mengembalikan Failure
      // return Left(ServerFailure(message: e.toString())); // Jika menggunakan Either
      // Untuk sekarang, kita lempar exception agar bisa ditangkap oleh UseCase/Cubit
      throw Exception('Gagal mendeteksi bahan di repository: ${e.toString()}');
    }
    // } else {
    //   // Tidak ada koneksi internet
    //   print("IngredientDetectionRepositoryImpl: Tidak ada koneksi internet.");
    //   // return Left(NetworkFailure()); // Jika menggunakan Either
    //   throw Exception('Tidak ada koneksi internet.');
    // }
  }
}
