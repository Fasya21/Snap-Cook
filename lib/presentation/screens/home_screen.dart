import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Impor Bloc
import 'package:myapp/domain/entities/recipe.dart'; // Impor model Recipe terpusat
import 'package:myapp/presentation/bloc/recipe_home/recipe_home_cubit.dart'; // Impor Cubit
import 'package:myapp/presentation/screens/detection_screen.dart';
import 'package:myapp/presentation/screens/collection_screen.dart';
import 'package:myapp/presentation/screens/profile_screen.dart';
import 'package:myapp/di_container.dart' as di; // Impor GetIt instance

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFFFF7043);
  final Color textColor = const Color(0xFF212121);
  final Color hintTextColor = Colors.grey.shade500;
  final Color iconColor = const Color(0xFFFF7043);

  // Hapus _dummyRecipes dari sini, karena akan diambil dari Cubit
  // final List<Recipe> _dummyRecipes = [ ... ];

  Widget _buildPageContent() {
    if (_selectedIndex == 0) {
      // Home
      return BlocProvider<RecipeHomeCubit>(
        // Sediakan Cubit untuk _buildHomePage
        create:
            (context) =>
                di.sl<RecipeHomeCubit>()
                  ..loadRecipes(), // Buat dan langsung panggil loadRecipes
        child:
            _buildHomePageContent(), // Widget baru yang akan menggunakan BlocBuilder
      );
    } else if (_selectedIndex == 1) {
      // Deteksi
      return const DetectionScreen();
    } else if (_selectedIndex == 2) {
      // Koleksi
      // Nantinya CollectionScreen juga akan butuh Cubit sendiri
      return const CollectionScreen();
    } else if (_selectedIndex == 3) {
      // Profil
      return const ProfileScreen();
    }
    return Container();
  }

  // Widget ini sekarang akan mendengarkan RecipeHomeCubit
  Widget _buildHomePageContent() {
    return BlocBuilder<RecipeHomeCubit, RecipeHomeState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 24.0,
                left: 16.0,
                right: 16.0,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Snap Cook',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
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
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 20.0,
                    ),
                  ),
                  onChanged: (value) {
                    // TODO: Implementasi logika pencarian dengan Cubit
                  },
                ),
              ),
            ),
            // Bagian untuk menampilkan resep berdasarkan state Cubit
            if (state is RecipeHomeLoading) ...[
              const SliverFillRemaining(
                // Mengisi sisa ruang dengan loading indicator
                child: Center(child: CircularProgressIndicator()),
              ),
            ] else if (state is RecipeHomeLoaded) ...[
              if (state.recipes.isEmpty) ...[
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Tidak ada resep ditemukan.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              ] else ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final recipe =
                            state
                                .recipes[index]; // Ambil resep dari state.recipes
                        return _buildRecipeCard(
                          recipe,
                        ); // Gunakan _buildRecipeCard yang sudah ada
                      },
                      childCount:
                          state
                              .recipes
                              .length, // Jumlah resep dari state.recipes
                    ),
                  ),
                ),
              ],
            ] else if (state is RecipeHomeError) ...[
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Gagal memuat resep: ${state.message}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // State Initial atau state lain yang belum ditangani
              const SliverFillRemaining(
                child: Center(child: Text('Memuat resep...')),
              ),
            ],
            const SliverPadding(padding: EdgeInsets.only(bottom: 16.0)),
          ],
        );
      },
    );
  }

  // _buildRecipeCard tetap sama, menerima objek Recipe
  Widget _buildRecipeCard(Recipe recipe) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
      },
      splashColor: accentColor.withOpacity(0.1),
      highlightColor: accentColor.withOpacity(0.05),
      child: Card(
        color: cardColor, // Menggunakan cardColor yang sudah didefinisikan
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAlias,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _buildPageContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_enhance_outlined),
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
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        backgroundColor: cardColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        showUnselectedLabels: true,
      ),
    );
  }
}
