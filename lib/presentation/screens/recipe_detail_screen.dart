import 'package:flutter/material.dart';

// Asumsi Anda memiliki model Recipe yang serupa atau bisa diimpor
// Jika belum, Anda bisa mendefinisikannya di sini atau di domain/entities
class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final List<String> ingredients;
  final List<String> steps;
  // Tambahkan field lain jika perlu, misal: deskripsi, waktu masak, porsi, dll.

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.ingredients,
    required this.steps,
  });
}

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  // Warna dari palet yang telah kita sepakati
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(
    0xFFFFFFFF,
  ); // Untuk kartu bahan & langkah
  final Color accentColor = const Color(0xFFFF7043);
  final Color textColor = const Color(0xFF212121);
  final Color sectionTitleColor = const Color(
    0xFFFF7043,
  ); // Warna aksen untuk judul bagian
  final Color listIconColor = const Color(0xFFFF7043);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          recipe.name, // Judul AppBar bisa nama resepnya
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 24.0,
        ), // Padding di bawah agar tidak terpotong
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rekomendasi Resep', // Sesuai desain
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Detail Resep', // Sesuai desain
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Gambar Utama Resep
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  recipe.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 60,
                        color: Colors.grey[500],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nama Resep dan Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        recipe.rating.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor.withOpacity(0.9),
                        ),
                      ),
                      // Tambahan info seperti waktu masak atau porsi bisa di sini
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bagian Bahan-bahan
            _buildSectionCard(
              title: 'Bahan-bahan :',
              icon: Icons.checklist_rtl_rounded,
              children:
                  recipe.ingredients.map((ingredient) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 2.0,
                              right: 10.0,
                            ),
                            // Checkbox bisa diaktifkan jika ada fitur shopping list
                            // child: Icon(Icons.check_box_outline_blank, size: 20, color: listIconColor.withOpacity(0.7)),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: listIconColor.withOpacity(0.6),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor.withOpacity(0.9),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),

            // Bagian Langkah Memasak
            _buildSectionCard(
              title: 'Langkah memasak :',
              icon: Icons.soup_kitchen_outlined,
              children: List.generate(recipe.steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "${index + 1}.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: listIconColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          recipe.steps[index],
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor, // Warna kartu seperti desain
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.orange.shade100,
            width: 1.5,
          ), // Border tipis
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: sectionTitleColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: sectionTitleColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.8),
            ...children,
          ],
        ),
      ),
    );
  }
}
