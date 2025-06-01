import 'package:flutter/material.dart';
import 'package:myapp/domain/entities/recipe.dart';

// // Model sederhana untuk data resep di koleksi (bisa diperluas)
// class CollectedRecipe {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final String category; // Contoh: Sarapan, Makan Malam
//   final String cookTime; // Contoh: 15 menit
//   final String difficulty; // Contoh: Mudah, Sedang, Sulit

//   CollectedRecipe({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.category,
//     required this.cookTime,
//     required this.difficulty,
//   });
// }

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  // Warna dari palet yang telah kita sepakati
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFFFF7043);
  final Color textFieldFillColor = const Color(0xFFFFF0E5);
  final Color textColor = const Color(0xFF212121);
  final Color hintTextColor = Colors.grey.shade500;
  final Color iconColor = const Color(0xFFFF7043);
  final Color borderColor = Colors.grey.shade300;

  // State untuk filter (contoh)
  String? _selectedCategory;
  String? _selectedCookTime;
  String? _selectedDifficulty;

  // Data resep koleksi dummy
  // final List<CollectedRecipe> _dummyCollectedRecipes = [
  //   CollectedRecipe(
  //     id: 'c1',
  //     name: 'Telur Dadar Spesial',
  //     imageUrl: 'https://i.ytimg.com/vi/N584C9vlBGU/maxresdefault.jpg',
  //     category: 'Sarapan',
  //     cookTime: '15 menit',
  //     difficulty: 'Mudah',
  //   ),
  //   CollectedRecipe(
  //     id: 'c2',
  //     name: 'Nasi Goreng Seafood',
  //     imageUrl:
  //         'https://2.bp.blogspot.com/-yxfcYmaDA5c/V91cVySXiBI/AAAAAAAAAwM/7o5rGp9dCYUbKAa0hpAmgbDSpByXYyKSQCLcB/s1600/Resep-Nasi-Goreng-Spesial.jpg',
  //     category: 'Makan Malam',
  //     cookTime: '25 menit',
  //     difficulty: 'Mudah',
  //   ),
  //   CollectedRecipe(
  //     id: 'c3',
  //     name: 'Ayam Geprek Sambal Bawang',
  //     imageUrl:
  //         'https://rinaresep.com/wp-content/uploads/2023/05/Ayam-Bakar.jpeg',
  //     category: 'Makan Siang',
  //     cookTime: '45 menit',
  //     difficulty: 'Sedang',
  //   ),
  //   CollectedRecipe(
  //     id: 'c4',
  //     name: 'Salad Buah Segar',
  //     imageUrl:
  //         'https://storage.googleapis.com/bakingworld-web-production/uploads/media/content_banner/shutterstock_1955049547-1681812472912.jpg',
  //     category: 'Dessert',
  //     cookTime: '10 menit',
  //     difficulty: 'Mudah',
  //   ),
  // ];

  // List<CollectedRecipe> _filteredRecipes = [];

  final List<Recipe> _dummyCollectedRecipes = [
    Recipe(
      id: "C001",
      name: "Salad Buah Yoghurt Keju",
      imageUrl:
          "https://tse2.mm.bing.net/th/id/OIP.7VxaeQj-x8YIhr3-s8aASgHaE7?rs=1&pid=ImgDetMain",
      rating: 4.7,
      ingredients: [
        "1 buah apel, potong dadu",
        "1 buah pir, potong dadu",
        "100g anggur, belah dua buang biji",
        "100g melon, potong dadu",
        "1 buah naga, potong dadu",
        "Nata de coco secukupnya (opsional)",
        "Saus Salad:",
        "200g mayones",
        "100g yoghurt plain kental",
        "3 sdm susu kental manis putih",
        "1 sdm air jeruk lemon/nipis (opsional)",
        "Topping:",
        "Keju cheddar parut secukupnya",
      ],
      steps: [
        "Siapkan semua buah-buahan, cuci bersih dan potong-potong. Simpan dalam kulkas agar dingin.",
        "Campurkan semua bahan saus salad: mayones, yoghurt, susu kental manis, dan air jeruk lemon (jika pakai). Aduk hingga rata.",
        "Tata potongan buah-buahan dan nata de coco dalam mangkuk saji atau wadah.",
        "Siram dengan saus salad secara merata.",
        "Taburi dengan keju cheddar parut.",
        "Sajikan salad buah dingin untuk rasa yang lebih segar.",
      ],
      category: "Dessert",
      cookTime: "20 menit",
      difficulty: "Mudah",
      description:
          "Salad buah segar dengan saus yoghurt mayones yang creamy dan taburan keju yang gurih.",
      servings: "4-5 porsi",
    ),
    Recipe(
      id: "C00",
      name: "Mie Goreng Jawa Tek-Tek",
      imageUrl:
          "https://tse3.mm.bing.net/th/id/OIP.bOXC2JVFUV0dzsho5H9XzAAAAA?rs=1&pid=ImgDetMain",
      rating: 4.4,
      ingredients: [
        "200g mie telur kering, rebus hingga matang, tiriskan",
        "100g daging ayam, potong dadu",
        "5 buah bakso, iris",
        "2 butir telur, kocok lepas",
        "Sayuran (kol, sawi hijau), potong-potong",
        "Bumbu Halus:",
        "4 siung bawang putih",
        "3 buah kemiri, sangrai",
        "1/2 sdt merica butiran",
        "Ebi secukupnya, rendam air panas (opsional)",
        "Bumbu Lain:",
        "3 sdm kecap manis",
        "1 sdm saus sambal",
        "Garam dan kaldu bubuk secukupnya",
        "Minyak untuk menumis",
        "Bawang goreng untuk taburan",
      ],
      steps: [
        "Panaskan minyak, tumis bumbu halus hingga harum.",
        "Masukkan ayam dan bakso, masak hingga ayam berubah warna.",
        "Pinggirkan tumisan, masukkan telur kocok, buat orak-arik.",
        "Masukkan sayuran, masak hingga sedikit layu.",
        "Masukkan mie yang sudah direbus, kecap manis, saus sambal, garam, dan kaldu bubuk. Aduk rata hingga semua bumbu meresap.",
        "Koreksi rasa. Masak sebentar hingga semua matang.",
        "Sajikan Mie Goreng Jawa dengan taburan bawang goreng.",
      ],
      category: "Makan Malam",
      cookTime: "35 menit",
      difficulty: "Sedang",
      description:
          "Mie goreng ala pedagang tek-tek dengan bumbu khas Jawa yang medok dan lezat.",
      servings: "2-3 porsi",
    ),
    // ... resep lainnya ...
  ];
  List<Recipe> _filteredRecipes = []; // Tipe juga diubah menjadi List<Recipe>

  @override
  void initState() {
    super.initState();
    _filteredRecipes = _dummyCollectedRecipes; // Awalnya tampilkan semua
  }

  // Fungsi untuk filter (simulasi sederhana)
  void _applyFilters() {
    setState(() {
      _filteredRecipes =
          _dummyCollectedRecipes.where((recipe) {
            final categoryMatch =
                _selectedCategory == null ||
                recipe.category == _selectedCategory;
            final cookTimeMatch =
                _selectedCookTime == null ||
                recipe.cookTime.contains(_selectedCookTime!); // Contoh contains
            final difficultyMatch =
                _selectedDifficulty == null ||
                recipe.difficulty == _selectedDifficulty;
            return categoryMatch && cookTimeMatch && difficultyMatch;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Contoh item untuk dropdown
    final List<String> categories = [
      'Sarapan',
      'Makan Siang',
      'Makan Malam',
      'Cemilan',
      'Dessert',
    ];
    final List<String> cookTimes = [
      '< 15 menit',
      '15-30 menit',
      '30-60 menit',
      '> 60 menit',
    ];
    final List<String> difficulties = ['Mudah', 'Sedang', 'Sulit'];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Koleksi',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false, // Judul di kiri seperti desain
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                _buildDropdownFilter(
                  'Kategori',
                  categories,
                  _selectedCategory,
                  (val) {
                    setState(() => _selectedCategory = val);
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 10),
                _buildDropdownFilter(
                  'Waktu Memasak',
                  cookTimes,
                  _selectedCookTime,
                  (val) {
                    setState(() => _selectedCookTime = val);
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 10),
                _buildDropdownFilter(
                  'Tingkat Kesulitan',
                  difficulties,
                  _selectedDifficulty,
                  (val) {
                    setState(() => _selectedDifficulty = val);
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari dalam koleksi...',
                    hintStyle: TextStyle(color: hintTextColor),
                    prefixIcon: Icon(
                      Icons.search,
                      color: iconColor.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: accentColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onChanged: (value) {
                    // TODO: Implementasi logika pencarian
                    setState(() {
                      _filteredRecipes =
                          _dummyCollectedRecipes
                              .where(
                                (recipe) =>
                                    recipe.name.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ) &&
                                    (_selectedCategory == null ||
                                        recipe.category == _selectedCategory) &&
                                    (_selectedCookTime == null ||
                                        recipe.cookTime.contains(
                                          _selectedCookTime!,
                                        )) &&
                                    (_selectedDifficulty == null ||
                                        recipe.difficulty ==
                                            _selectedDifficulty),
                              )
                              .toList();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _filteredRecipes.isEmpty
                    ? Center(
                      child: Text(
                        'Tidak ada resep di koleksi yang cocok.',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      itemCount: _filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _filteredRecipes[index];
                        return _buildCollectedRecipeCard(recipe);
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text('Tambah Resep Baru'),
                onPressed: () {
                  // TODO: Navigasi ke halaman tambah resep baru
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Fitur "Tambah Resep Baru" belum diimplementasikan.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(
    String hint,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: hintTextColor)),
          value: selectedValue,
          icon: Icon(Icons.arrow_drop_down, color: iconColor.withOpacity(0.7)),
          style: TextStyle(color: textColor, fontSize: 15),
          dropdownColor: cardColor,
          items:
              items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCollectedRecipeCard(Recipe recipe) {
    return InkWell(
      // Dibungkus dengan InkWell agar bisa diklik
      onTap: () {
        // Aksi ketika kartu diklik, misalnya navigasi ke detail resep
        Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
        print("Kartu koleksi diklik: ${recipe.name}"); // Untuk debugging
      },
      splashColor: accentColor.withOpacity(0.1), // Warna efek saat disentuh
      highlightColor: accentColor.withOpacity(0.05),
      child: Card(
        color: textFieldFillColor, // Warna latar kartu seperti di desain Anda
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  recipe.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.restaurant_menu,
                        color: Colors.grey[500],
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${recipe.category} • ${recipe.cookTime} • ${recipe.difficulty}',
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Opsional: Tombol aksi seperti delete atau edit
              // IconButton(
              //   icon: Icon(Icons.more_vert, color: textColor.withOpacity(0.6)),
              //   onPressed: () {
              //     // Aksi untuk kartu resep
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
