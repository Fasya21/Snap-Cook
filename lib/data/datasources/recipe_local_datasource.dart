import 'dart:convert'; // Diperlukan untuk json.decode
import 'package:flutter/services.dart'
    show rootBundle; // Diperlukan untuk memuat aset
import 'package:myapp/domain/entities/recipe.dart'; // Sesuaikan 'snap_cook' dengan nama paket proyek Anda

// Mendefinisikan kontrak (interface) untuk datasource resep lokal
abstract class RecipeLocalDatasource {
  Future<List<Recipe>> getAllRecipes();
  Future<Recipe?> getRecipeById(
    String id,
  ); // Opsional: fungsi untuk mendapatkan resep berdasarkan ID
}

// Implementasi konkret dari RecipeLocalDatasource
class RecipeLocalDatasourceImpl implements RecipeLocalDatasource {
  final String _assetPath =
      "assets/recipes.json"; // Path ke file JSON aset kita

  // Cache sederhana untuk menyimpan resep setelah dimuat pertama kali
  // agar tidak perlu membaca file berulang kali.
  List<Recipe>? _cachedRecipes;

  // Fungsi internal untuk memuat dan mem-parsing resep dari file JSON
  Future<List<Recipe>> _loadRecipes() async {
    // Jika resep sudah ada di cache, langsung kembalikan
    if (_cachedRecipes != null) {
      print("Mengambil resep dari cache.");
      return _cachedRecipes!;
    }

    try {
      print("Memuat resep dari file aset: $_assetPath");
      // Membaca konten string dari file aset
      final String jsonString = await rootBundle.loadString(_assetPath);

      // Mengubah string JSON menjadi List<dynamic> (karena JSON kita adalah array objek)
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      // Mengubah setiap item JSON dalam list menjadi objek Recipe menggunakan factory constructor Recipe.fromJson
      final List<Recipe> recipes =
          jsonList
              .map(
                (jsonItem) => Recipe.fromJson(jsonItem as Map<String, dynamic>),
              )
              .toList();

      _cachedRecipes = recipes; // Simpan ke cache
      print(
        "Resep berhasil dimuat dan di-cache. Jumlah resep: ${recipes.length}",
      );
      return recipes;
    } catch (e) {
      // Tangani error jika file tidak ditemukan, format JSON salah, dll.
      print("Error saat memuat resep dari aset: $e");
      throw Exception(
        'Gagal memuat resep dari aset: $e',
      ); // Lempar exception agar bisa ditangani di lapisan atas
    }
  }

  @override
  Future<List<Recipe>> getAllRecipes() async {
    // Panggil fungsi internal untuk memuat resep
    return await _loadRecipes();
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    // Panggil fungsi internal untuk memuat resep jika belum ada di cache
    final recipes = await _loadRecipes();
    try {
      // Cari resep berdasarkan ID
      return recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      // Jika tidak ditemukan, firstWhere akan melempar error, jadi kita tangkap dan kembalikan null
      print("Resep dengan ID '$id' tidak ditemukan.");
      return null;
    }
  }
}
