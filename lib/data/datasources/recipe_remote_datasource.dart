import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/domain/entities/recipe.dart'; // Sesuaikan 'myapp' dengan nama paket proyek Anda

// Mendefinisikan kontrak (interface) untuk datasource resep remote
abstract class RecipeRemoteDatasource {
  Future<List<Recipe>> getAllRecipes();
  Future<Recipe?> getRecipeById(String id);
}

// Implementasi konkret dari RecipeRemoteDatasource menggunakan Firebase Firestore
class RecipeRemoteDatasourceImpl implements RecipeRemoteDatasource {
  final FirebaseFirestore firestore;
  final String _collectionName = 'Recipe'; // Nama koleksi di Firestore

  RecipeRemoteDatasourceImpl({required this.firestore});

  @override
  Future<List<Recipe>> getAllRecipes() async {
    try {
      print(
        "RecipeRemoteDatasourceImpl: Mengambil semua resep dari Firestore...",
      );
      QuerySnapshot querySnapshot =
          await firestore.collection(_collectionName).get();

      List<Recipe> recipes =
          querySnapshot.docs.map((doc) {
            // Mengambil data dari dokumen dan menambahkan ID dokumen ke dalamnya
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            // Jika ID resep Anda disimpan sebagai field di dalam dokumen (misal 'id'), gunakan itu.
            // Jika ID dokumen Firestore adalah ID resep Anda, gunakan doc.id.
            // Untuk konsistensi dengan model Recipe.fromJson yang mungkin mengharapkan 'id' di dalam data:
            // Jika Anda tidak menyimpan field 'id' di dalam dokumen Firestore dan ingin menggunakan ID dokumen Firestore:
            // data['id'] = doc.id; // Tambahkan ini jika 'id' tidak ada di data map

            // Jika ID resep Anda adalah field bernama 'id' di dalam dokumen Firestore
            // dan Anda sudah memasukannya saat membuat data di console, maka tidak perlu baris di atas.
            // Pastikan field 'id' di Firestore sesuai dengan yang diharapkan Recipe.fromJson

            return Recipe.fromJson(data);
          }).toList();

      print(
        "RecipeRemoteDatasourceImpl: Berhasil mengambil ${recipes.length} resep dari Firestore.",
      );
      return recipes;
    } on FirebaseException catch (e) {
      print(
        "RecipeRemoteDatasourceImpl: Error Firebase saat getAllRecipes - ${e.code}: ${e.message}",
      );
      // Anda bisa melempar custom exception di sini
      throw Exception('Gagal mengambil resep dari Firestore: ${e.message}');
    } catch (e) {
      print("RecipeRemoteDatasourceImpl: Error umum saat getAllRecipes: $e");
      throw Exception('Terjadi error tidak diketahui saat mengambil resep.');
    }
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      print(
        "RecipeRemoteDatasourceImpl: Mengambil resep dengan ID '$id' dari Firestore...",
      );
      DocumentSnapshot documentSnapshot =
          await firestore.collection(_collectionName).doc(id).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        // Sama seperti di atas, pastikan field 'id' tersedia untuk Recipe.fromJson
        // Jika Anda menggunakan ID dokumen Firestore sebagai ID resep dan tidak ada field 'id' di data:
        // data['id'] = documentSnapshot.id; // Tambahkan ini jika perlu

        Recipe recipe = Recipe.fromJson(data);
        print("RecipeRemoteDatasourceImpl: Resep dengan ID '$id' ditemukan.");
        return recipe;
      } else {
        print(
          "RecipeRemoteDatasourceImpl: Resep dengan ID '$id' tidak ditemukan di Firestore.",
        );
        return null;
      }
    } on FirebaseException catch (e) {
      print(
        "RecipeRemoteDatasourceImpl: Error Firebase saat getRecipeById '$id' - ${e.code}: ${e.message}",
      );
      throw Exception(
        'Gagal mengambil resep berdasarkan ID dari Firestore: ${e.message}',
      );
    } catch (e) {
      print(
        "RecipeRemoteDatasourceImpl: Error umum saat getRecipeById '$id': $e",
      );
      throw Exception(
        'Terjadi error tidak diketahui saat mengambil resep berdasarkan ID.',
      );
    }
  }
}

// **Penjelasan Kode:**
// * **`import 'package:cloud_firestore/cloud_firestore.dart';`**: Mengimpor paket Firestore.
// * **`RecipeRemoteDatasource` (Abstract Class):** Interface yang sama seperti `RecipeLocalDatasource` untuk konsistensi, mendefinisikan method `getAllRecipes()` dan `getRecipeById()`.
// * **`RecipeRemoteDatasourceImpl`:**
//     * **`final FirebaseFirestore firestore;`**: Dependensi ke instance `FirebaseFirestore`.
//     * **`_collectionName = 'recipes'`**: Nama koleksi di Firestore tempat Anda menyimpan data resep. Pastikan ini sama dengan nama koleksi yang Anda buat di Firebase Console.
//     * **`getAllRecipes()`**:
//         * Menggunakan `firestore.collection(_collectionName).get()` untuk mengambil semua dokumen dari koleksi `recipes`.
//         * `querySnapshot.docs` berisi daftar dokumen. Kita melakukan `map` pada setiap dokumen (`doc`).
//         * `doc.data()` mengambil data dari dokumen sebagai `Map<String, dynamic>`.
//         * **PENTING untuk ID Resep:** `Recipe.fromJson` mengharapkan field `id` ada di dalam map data.
//             * Jika Anda menyimpan ID resep Anda (misalnya "R001") sebagai field bernama `id` di dalam setiap dokumen Firestore, maka ini akan bekerja langsung.
//             * Jika Anda menggunakan ID Dokumen yang digenerate otomatis oleh Firestore sebagai ID resep Anda, dan *tidak* memiliki field `id` di dalam data dokumen, Anda perlu menambahkan ID dokumen ke dalam map `data` sebelum memanggil `Recipe.fromJson`. Contohnya ada di komentar: `data['id'] = doc.id;`. **Pilih salah satu cara yang sesuai dengan bagaimana Anda menyimpan ID di Firestore.** Untuk data dummy yang kita sepakati sebelumnya, kita memiliki field `id` di dalamnya, jadi seharusnya aman.
//         * `Recipe.fromJson(data)` mengubah map data menjadi objek `Recipe`.
//         * Error handling untuk `FirebaseException` dan error umum lainnya.
//     * **`getRecipeById(String id)`**:
//         * Menggunakan `firestore.collection(_collectionName).doc(id).get()` untuk mengambil satu dokumen spesifik berdasarkan ID-nya.
//         * Mengecek `documentSnapshot.exists` untuk memastikan dokumen ditemukan.
//         * Logika untuk `id` dan `Recipe.fromJson` sama seperti di `getAllRecipes()`.
