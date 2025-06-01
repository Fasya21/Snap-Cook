import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Opsi untuk grid yang lebih dinamis
// Impor DetectionScreen di bagian atas home_screen.dart
import 'package:myapp/presentation/screens/detection_screen.dart';
import 'package:myapp/presentation/screens/collection_screen.dart';
import 'package:myapp/presentation/screens/profile_screen.dart';

// Model sederhana untuk data resep dummy
class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Indeks untuk BottomNavigationBar, 0 untuk Home

  // Warna dari palet yang Anda berikan
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFFFF7043);
  // final Color textFieldFillColor = const Color(0xFFFFF0E5); // Mungkin digunakan untuk search bar
  final Color textColor = const Color(0xFF212121);
  final Color hintTextColor = Colors.grey.shade500;
  final Color iconColor = const Color(
    0xFFFF7043,
  ); //.withOpacity(0.8); // Dibuat solid untuk bottom nav aktif

  // Data resep dummy
  final List<Recipe> _dummyRecipes = [
    Recipe(
      id: '1',
      name: 'Nasi Goreng Spesial',
      imageUrl:
          'https://2.bp.blogspot.com/-yxfcYmaDA5c/V91cVySXiBI/AAAAAAAAAwM/7o5rGp9dCYUbKAa0hpAmgbDSpByXYyKSQCLcB/s1600/Resep-Nasi-Goreng-Spesial.jpg',
      rating: 4.5,
    ),
    Recipe(
      id: '2',
      name: 'Telur Dadar Sayur',
      imageUrl: 'https://i.ytimg.com/vi/N584C9vlBGU/maxresdefault.jpg',
      rating: 4.2,
    ),
    Recipe(
      id: '3',
      name: 'Ayam Bakar Madu',
      imageUrl:
          'https://rinaresep.com/wp-content/uploads/2023/05/Ayam-Bakar.jpeg',
      rating: 4.8,
    ),
    Recipe(
      id: '4',
      name: 'Soto Ayam Lamongan',
      imageUrl:
          'https://images.slurrp.com/prod/recipe_images/transcribe/nan/Soto-Ayam.webp',
      rating: 4.6,
    ),
    Recipe(
      id: '5',
      name: 'Gado-Gado Siram',
      imageUrl:
          'https://img-global.cpcdn.com/recipes/cac9ac6bef83cb4e/680x482cq70/gado-gado-surabaya-gado-gado-siram-foto-resep-utama.jpg',
      rating: 4.3,
    ),
    Recipe(
      id: '6',
      name: 'Rendang Daging',
      imageUrl:
          'https://cdn0-production-images-kly.akamaized.net/jAhRHll_RQBlFGXC18vg2VpRWZ0=/0x120:3000x1811/1200x675/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/3282059/original/075075700_1604028408-shutterstock_1788721670.jpg',
      rating: 4.9,
    ),
  ];

  // Fungsi untuk membangun konten halaman berdasarkan item navigasi yang dipilih
  Widget _buildPageContent() {
    if (_selectedIndex == 0) {
      // Home
      return _buildHomePage();
    } else if (_selectedIndex == 1) {
      // Deteksi
      return const DetectionScreen(); // <-- TAMPILKAN DETECTION SCREEN DI SINI
    } else if (_selectedIndex == 2) {
      // Koleksi
      return const CollectionScreen();
    } else if (_selectedIndex == 3) {
      // Profil
      return const ProfileScreen();
    }
    return Container();
  }
  // Widget _buildPageContent() {
  //   // Untuk saat ini, semua tab akan menampilkan konten Home.
  //   // Nantinya, Anda bisa membuat widget terpisah untuk setiap tab.
  //   if (_selectedIndex == 0) {
  //     // Home
  //     return _buildHomePage();
  //   } else if (_selectedIndex == 1) {
  //     // Deteksi
  //     // Ini bisa menjadi tempat untuk halaman dengan tombol "Ambil Foto" / "Unggah Foto"
  //     return Center(
  //       child: Text(
  //         'Halaman Deteksi Bahan (Segera Hadir)',
  //         style: TextStyle(fontSize: 18, color: textColor),
  //       ),
  //     );
  //   } else if (_selectedIndex == 2) {
  //     // Koleksi
  //     return Center(
  //       child: Text(
  //         'Halaman Koleksi Resep (Segera Hadir)',
  //         style: TextStyle(fontSize: 18, color: textColor),
  //       ),
  //     );
  //   } else if (_selectedIndex == 3) {
  //     // Profil
  //     return Center(
  //       child: Text(
  //         'Halaman Profil Pengguna (Segera Hadir)',
  //         style: TextStyle(fontSize: 18, color: textColor),
  //       ),
  //     );
  //   }
  //   return Container(); // Default
  // }

  Widget _buildHomePage() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Snap Cook',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: accentColor, // Menggunakan warna aksen untuk judul utama
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          sliver: SliverToBoxAdapter(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                hintStyle: TextStyle(color: hintTextColor),
                prefixIcon: Icon(
                  Icons.search,
                  color: iconColor.withOpacity(0.7),
                ),
                suffixIcon: Container(
                  // Lingkaran oranye seperti di desain
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                filled: true,
                fillColor: cardColor, // Atau textFieldFillColor jika ingin beda
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ), // Membuatnya lebih rounded
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14.0,
                  horizontal: 20.0,
                ),
              ),
              onChanged: (value) {
                // TODO: Implementasi logika pencarian
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kartu per baris
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.75, // Sesuaikan rasio aspek kartu
            ),
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final recipe = _dummyRecipes[index];
              return _buildRecipeCard(recipe);
            }, childCount: _dummyRecipes.length),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: 16.0),
        ), // Padding di akhir list
      ],
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Card(
      color: cardColor,
      elevation: 2.0, // Sedikit bayangan
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior:
          Clip.antiAlias, // Untuk memastikan gambar terpotong sesuai border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Image.network(
              recipe.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              recipe.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 12.0,
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  recipe.rating.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Di sini Anda bisa menambahkan logika navigasi jika diperlukan
    // Misalnya, jika Deteksi diklik, navigasi ke halaman khusus deteksi
    // if (index == 1) {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => DetectionScreen()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body:
          _buildPageContent(), // Memanggil fungsi untuk membangun konten halaman
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Icon berbeda saat aktif
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_enhance_outlined), // Mengganti ikon deteksi
            activeIcon: Icon(Icons.camera_enhance),
            label: 'Deteksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark_outlined),
            activeIcon: Icon(Icons.collections_bookmark),
            label: 'Koleksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            accentColor, // Warna item yang dipilih (ikon dan teks)
        unselectedItemColor: Colors.grey[600], // Warna item yang tidak dipilih
        onTap: _onItemTapped,
        backgroundColor: cardColor, // Warna latar belakang BottomNavigationBar
        type: BottomNavigationBarType.fixed, // Agar label selalu terlihat
        elevation: 8.0, // Sedikit bayangan untuk BottomNavigationBar
        showUnselectedLabels: true, // Selalu tampilkan label
      ),
    );
  }
}
