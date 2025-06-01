import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Opsi untuk grid yang lebih dinamis
// Impor DetectionScreen di bagian atas home_screen.dart
import 'package:myapp/presentation/screens/detection_screen.dart';
import 'package:myapp/presentation/screens/collection_screen.dart';
import 'package:myapp/presentation/screens/profile_screen.dart';
import 'package:myapp/domain/entities/recipe.dart';

// // Model sederhana untuk data resep dummy
// class Recipe {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final double rating;

//   Recipe({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.rating,
//   });
// }

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
      id: "R001",
      name: "Nasi Goreng Spesial Keluarga",
      imageUrl:
          "https://3.bp.blogspot.com/-7kB8B19vfTc/VaXgOMn7kFI/AAAAAAAAAEI/Hlt1HxsaA2k/s1600/resep-nasi-goreng-kampung.jpg",
      rating: 4.5,
      ingredients: [
        "2 piring nasi putih dingin",
        "2 butir telur, kocok lepas",
        "100g ayam fillet, potong dadu",
        "50g udang, kupas",
        "2 siung bawang putih, cincang halus",
        "3 buah bawang merah, iris tipis",
        "2 buah cabai merah, iris serong (opsional)",
        "1 batang daun bawang, iris",
        "2 sdm kecap manis",
        "1 sdm saus tiram",
        "1/2 sdt merica bubuk",
        "Garam secukupnya",
        "Minyak untuk menumis",
      ],
      steps: [
        "Panaskan sedikit minyak, buat orak-arik telur, angkat dan sisihkan.",
        "Tambahkan minyak lagi, tumis bawang putih dan bawang merah hingga harum.",
        "Masukkan ayam dan udang, masak hingga berubah warna.",
        "Masukkan nasi, aduk rata. Tambahkan kecap manis, saus tiram, merica, dan garam. Aduk hingga semua tercampur rata.",
        "Masukkan telur orak-arik dan daun bawang. Aduk sebentar.",
        "Sajikan Nasi Goreng Spesial selagi hangat dengan taburan bawang goreng dan kerupuk jika suka.",
      ],
      category: "Makan Malam",
      cookTime: "25 menit",
      difficulty: "Mudah",
      description:
          "Nasi goreng klasik dengan tambahan ayam dan udang yang pasti disukai seluruh keluarga.",
      servings: "2 porsi",
    ),
    Recipe(
      id: "R002",
      name: "Telur Dadar Padang Tebal",
      imageUrl:
          "https://d12man5gwydfvl.cloudfront.net/wp-content/uploads/2022/07/HappyFresh_Resep_Telur-Dadar-Padang_Blog-Header-GIF_2280x1373px.jpg",
      rating: 4.2,
      ingredients: [
        "3 butir telur ayam",
        "1 batang daun bawang, iris halus",
        "2 buah cabai merah keriting, iris halus (opsional)",
        "1/4 sdt kunyit bubuk (opsional, untuk warna)",
        "1/2 sdt garam",
        "1/4 sdt merica bubuk",
        "2 sdm tepung beras (opsional, untuk tekstur lebih padat)",
        "Minyak goreng secukupnya",
      ],
      steps: [
        "Dalam mangkuk, kocok telur bersama daun bawang, cabai (jika pakai), kunyit bubuk, garam, dan merica.",
        "Jika menggunakan tepung beras, larutkan dengan sedikit air lalu campurkan ke dalam adonan telur.",
        "Panaskan minyak dalam wajan teflon dengan api sedang-kecil.",
        "Tuang adonan telur ke dalam wajan. Masak dengan api kecil dan tutup wajan agar matang merata dan mengembang.",
        "Balik telur dadar jika satu sisi sudah matang dan berwarna kecoklatan. Masak hingga kedua sisi matang.",
        "Angkat dan sajikan selagi hangat.",
      ],
      category: "Sarapan",
      cookTime: "15 menit",
      difficulty: "Mudah",
      description:
          "Telur dadar khas Padang yang tebal, gurih, dan sedikit pedas. Cocok untuk lauk sarapan atau makan siang.",
      servings: "1-2 porsi",
    ),
    Recipe(
      id: "R003",
      name: "Ayam Bakar Madu Teflon",
      imageUrl:
          "https://img-global.cpcdn.com/recipes/be876cf60f2a6fcd/680x482cq70/ayam-bakar-madu-teflon-foto-resep-utama.jpg",
      rating: 4.8,
      ingredients: [
        "1/2 ekor ayam, potong menjadi 4 bagian",
        "1 buah jeruk nipis, ambil airnya",
        "3 siung bawang putih, haluskan",
        "2 cm jahe, haluskan",
        "3 sdm madu",
        "2 sdm kecap manis",
        "1 sdm saus sambal (opsional)",
        "1/2 sdt merica bubuk",
        "Garam secukupnya",
        "Sedikit minyak atau margarin untuk memanggang",
      ],
      steps: [
        "Lumuri potongan ayam dengan air jeruk nipis dan garam. Diamkan selama 15 menit.",
        "Campurkan bawang putih halus, jahe halus, madu, kecap manis, saus sambal (jika pakai), dan merica bubuk. Aduk rata.",
        "Balurkan bumbu ke seluruh permukaan ayam. Diamkan minimal 30 menit di dalam kulkas agar bumbu meresap.",
        "Panaskan teflon dengan sedikit minyak atau margarin.",
        "Panggang ayam di atas teflon dengan api kecil hingga sedang. Bolak-balik ayam dan olesi sisa bumbu sesekali.",
        "Masak hingga ayam matang sempurna dan berwarna kecoklatan karamel. Angkat dan sajikan.",
      ],
      category: "Makan Siang",
      cookTime: "45 menit (plus waktu marinasi)",
      difficulty: "Sedang",
      description:
          "Ayam bakar dengan bumbu madu yang manis gurih, mudah dibuat menggunakan teflon.",
      servings: "2 porsi",
    ),
    Recipe(
      id: "R004",
      name: "Smoothie Pisang Bayam Sehat",
      imageUrl:
          "https://statik.tempo.co/data/2024/06/26/id_1313802/1313802_720.jpg",
      rating: 4.0,
      ingredients: [
        "1 buah pisang matang, bekukan",
        "1 genggam daun bayam segar, cuci bersih",
        "1/2 cangkir susu cair (susu sapi, almond, atau kedelai)",
        "1 sdm madu atau sirup maple (opsional, sesuai selera)",
        "1 sdm selai kacang (opsional, untuk tambahan protein dan rasa)",
        "Es batu secukupnya (jika pisang tidak dibekukan)",
      ],
      steps: [
        "Masukkan semua bahan ke dalam blender: pisang beku, bayam, susu cair, madu/maple (jika pakai), dan selai kacang (jika pakai).",
        "Jika pisang tidak dibekukan, tambahkan beberapa buah es batu.",
        "Blender semua bahan hingga halus dan tercampur rata.",
        "Tuang smoothie ke dalam gelas dan segera sajikan.",
      ],
      category: "Minuman Sehat",
      cookTime: "5 menit",
      difficulty: "Mudah",
      description:
          "Smoothie hijau yang menyegarkan dan kaya nutrisi, cocok untuk sarapan atau camilan sehat.",
      servings: "1 porsi",
    ),
    Recipe(
      id: "R005",
      name: "Soto Ayam Lamongan Kuah Bening",
      imageUrl:
          "https://thumb.viva.id/vivabanyuwangi/665x374/2024/11/06/672b77409bf95-soto-ayam-lamongan_banyuwangi.jpg",
      rating: 4.6,
      ingredients: [
        "1/2 ekor ayam kampung, potong-potong",
        "2 liter air",
        "2 batang serai, memarkan",
        "3 lembar daun jeruk",
        "2 cm lengkuas, memarkan",
        "Garam dan gula secukupnya",
        "Bumbu Halus:",
        "6 siung bawang merah",
        "4 siung bawang putih",
        "2 cm kunyit, bakar",
        "1 cm jahe",
        "1/2 sdt merica butiran",
        "Pelengkap:",
        "Soun, seduh air panas",
        "Tauge pendek, seduh air panas",
        "Kol, iris tipis",
        "Daun bawang dan seledri, iris halus",
        "Bawang goreng",
        "Jeruk nipis",
        "Sambal rawit",
      ],
      steps: [
        "Rebus ayam hingga empuk. Angkat ayam, suwir-suwir dagingnya. Saring kaldu ayam, sisihkan.",
        "Tumis bumbu halus bersama serai, daun jeruk, dan lengkuas hingga harum.",
        "Masukkan tumisan bumbu ke dalam kaldu ayam. Masak hingga mendidih.",
        "Tambahkan garam dan gula secukupnya. Koreksi rasa.",
        "Tata soun, tauge, kol, dan suwiran ayam dalam mangkuk.",
        "Siram dengan kuah soto panas. Taburi dengan daun bawang, seledri, dan bawang goreng.",
        "Sajikan dengan jeruk nipis dan sambal rawit.",
      ],
      category: "Makanan Utama",
      cookTime: "60 menit",
      difficulty: "Sedang",
      description:
          "Soto ayam khas Lamongan dengan kuah bening yang segar dan kaya rempah.",
      servings: "4 porsi",
    ),
    Recipe(
      id: "R006",
      name: "Capcay Goreng Sayuran Komplit",
      imageUrl:
          "https://d12man5gwydfvl.cloudfront.net/wp-content/uploads/2022/02/HappyFresh-Capcay-Goreng-Recipe-1-e1645780523998.jpg",
      rating: 4.3,
      ingredients: [
        "100g udang, kupas",
        "5 buah bakso sapi, iris",
        "1 buah wortel, iris serong",
        "1 bonggol kembang kol, potong per kuntum",
        "5 lembar sawi putih, potong-potong",
        "1 batang daun bawang, iris serong",
        "3 siung bawang putih, cincang",
        "1/2 buah bawang bombay, iris",
        "1 sdm saus tiram",
        "1 sdt kecap ikan",
        "1/2 sdt minyak wijen",
        "Garam, gula, merica secukupnya",
        "100 ml air kaldu atau air biasa",
        "1 sdt tepung maizena, larutkan dengan sedikit air",
        "Minyak untuk menumis",
      ],
      steps: [
        "Panaskan minyak, tumis bawang putih dan bawang bombay hingga harum.",
        "Masukkan udang dan bakso, masak hingga udang berubah warna.",
        "Masukkan wortel dan kembang kol, aduk rata. Tuang sedikit air, masak hingga sayuran setengah matang.",
        "Masukkan sawi putih dan daun bawang. Aduk cepat.",
        "Tambahkan saus tiram, kecap ikan, minyak wijen, garam, gula, dan merica. Aduk rata.",
        "Tuang larutan maizena, masak hingga kuah mengental.",
        "Angkat dan sajikan Capcay Goreng selagi hangat.",
      ],
      category: "Sayuran",
      cookTime: "30 menit",
      difficulty: "Mudah",
      description:
          "Tumisan aneka sayuran dengan udang dan bakso yang lezat dan bergizi.",
      servings: "3-4 porsi",
    ),
    // Tambahkan lebih banyak resep dummy di sini jika mau,
    // pastikan semua field yang 'required' di konstruktor Recipe terisi.
  ];
  // final List<Recipe> _dummyRecipes = [
  //   Recipe(
  //     id: '1',
  //     name: 'Nasi Goreng Spesial',
  //     imageUrl:
  //         'https://2.bp.blogspot.com/-yxfcYmaDA5c/V91cVySXiBI/AAAAAAAAAwM/7o5rGp9dCYUbKAa0hpAmgbDSpByXYyKSQCLcB/s1600/Resep-Nasi-Goreng-Spesial.jpg',
  //     rating: 4.5,
  //   ),
  //   Recipe(
  //     id: '2',
  //     name: 'Telur Dadar Sayur',
  //     imageUrl: 'https://i.ytimg.com/vi/N584C9vlBGU/maxresdefault.jpg',
  //     rating: 4.2,
  //   ),
  //   Recipe(
  //     id: '3',
  //     name: 'Ayam Bakar Madu',
  //     imageUrl:
  //         'https://rinaresep.com/wp-content/uploads/2023/05/Ayam-Bakar.jpeg',
  //     rating: 4.8,
  //   ),
  //   Recipe(
  //     id: '4',
  //     name: 'Soto Ayam Lamongan',
  //     imageUrl:
  //         'https://images.slurrp.com/prod/recipe_images/transcribe/nan/Soto-Ayam.webp',
  //     rating: 4.6,
  //   ),
  //   Recipe(
  //     id: '5',
  //     name: 'Gado-Gado Siram',
  //     imageUrl:
  //         'https://img-global.cpcdn.com/recipes/cac9ac6bef83cb4e/680x482cq70/gado-gado-surabaya-gado-gado-siram-foto-resep-utama.jpg',
  //     rating: 4.3,
  //   ),
  //   Recipe(
  //     id: '6',
  //     name: 'Rendang Daging',
  //     imageUrl:
  //         'https://cdn0-production-images-kly.akamaized.net/jAhRHll_RQBlFGXC18vg2VpRWZ0=/0x120:3000x1811/1200x675/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/3282059/original/075075700_1604028408-shutterstock_1788721670.jpg',
  //     rating: 4.9,
  //   ),
  // ];

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
      child: InkWell(
        // Tambahkan InkWell untuk efek tap
        onTap: () {
          Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
        },
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
