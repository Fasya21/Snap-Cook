import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:myapp/domain/entities/recipe.dart'; // Pastikan path ini benar & myapp adalah nama paket Anda
import 'package:myapp/presentation/bloc/recipe_detection/recipe_detection_cubit.dart'; // Pastikan path ini benar

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final TextEditingController _ingredientController = TextEditingController();

  // Warna dari palet yang telah kita sepakati
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color accentColor = const Color(0xFFFF7043);
  final Color textFieldFillColor = const Color(0xFFFFF0E5);
  final Color textColor = const Color(0xFF212121);
  final Color hintTextColor = Colors.grey.shade500;
  final Color iconColor = const Color(0xFFFF7043); // Dibuat solid
  final Color borderColor = Colors.grey.shade300;

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _onPickImage(ImageSource source) {
    // Panggil method pickImage dari Cubit
    context.read<RecipeDetectionCubit>().pickImage(source);
  }

  void _onDetectRecipesPressed() {
    // Dapatkan state saat ini untuk mengetahui apakah ada gambar yang sudah dipilih
    final currentState = context.read<RecipeDetectionCubit>().state;
    File? imageToProcess;
    List<String>? manualIngredients;

    if (currentState is RecipeDetectionImagePicked) {
      imageToProcess = currentState.imageFile;
    } else if (currentState is RecipeDetectionIngredientsDetected) { // Jika bahan sudah ada dari deteksi sebelumnya
      imageToProcess = currentState.imageFile; // Gunakan gambar yang sama jika ada
    } else if (currentState is RecipeDetectionSuccess) {
      imageToProcess = currentState.imageFile;
    } else if (currentState is RecipeDetectionNoMatch) {
      imageToProcess = currentState.imageFile;
    } else if (currentState is RecipeDetectionError) {
      imageToProcess = currentState.imageFile;
    }


    if (_ingredientController.text.trim().isNotEmpty) {
      manualIngredients = _ingredientController.text.trim().split(',').map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList();
      manualIngredients = manualIngredients.toSet().toList(); // Hapus duplikat
      // Jika ada input manual, kita prioritaskan ini dan hapus gambar yang mungkin sudah dipilih
      // agar tidak ada kebingungan input mana yang dipakai.
      if (manualIngredients.isNotEmpty && imageToProcess != null) {
         context.read<RecipeDetectionCubit>().resetDetection(); // Reset state gambar jika ada input manual
         imageToProcess = null; // Abaikan gambar jika ada input manual
         // Beri feedback ke user jika perlu
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menggunakan input bahan manual, gambar diabaikan.'), duration: Duration(seconds: 2)),
          );
      }
    }

    if (imageToProcess == null && (manualIngredients == null || manualIngredients.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar atau masukkan bahan terlebih dahulu.'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }
    
    // Panggil method processInput dari Cubit
    context.read<RecipeDetectionCubit>().processInput(imageFile: imageToProcess, manualIngredients: manualIngredients);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Deteksi Resep',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: iconColor),
            onPressed: () {
              _ingredientController.clear();
              context.read<RecipeDetectionCubit>().resetDetection();
            },
            tooltip: 'Reset Deteksi',
          )
        ],
      ),
      body: BlocConsumer<RecipeDetectionCubit, RecipeDetectionState>(
        listener: (context, state) {
          // Kita bisa menangani SnackBar untuk error di sini jika mau,
          // tapi AuthStateHandler di main.dart sudah menangani AuthError global.
          // Jika ada pesan error spesifik dari RecipeDetectionError yang ingin ditampilkan:
          if (state is RecipeDetectionError) {
             ScaffoldMessenger.of(context).removeCurrentSnackBar(); // Hapus snackbar sebelumnya jika ada
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 4)),
             );
          }
        },
        builder: (context, state) {
          File? currentImageFile;
          // Ambil imageFile dari state jika ada untuk ditampilkan di pratinjau
          if (state is RecipeDetectionImagePicked) currentImageFile = state.imageFile;
          if (state is RecipeDetectionIngredientsDetected) currentImageFile = state.imageFile;
          if (state is RecipeDetectionSuccess) currentImageFile = state.imageFile;
          if (state is RecipeDetectionNoMatch) currentImageFile = state.imageFile;
          if (state is RecipeDetectionError) currentImageFile = state.imageFile;


          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ambil foto bahan makanan, atau ketik bahan secara manual untuk menemukan resep.',
                  style: TextStyle(fontSize: 15, color: textColor.withOpacity(0.7)),
                ),
                const SizedBox(height: 24),

                // Area Input Gambar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.5),
                     boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4), ),]
                  ),
                  child: Column(
                    children: [
                      if (currentImageFile != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file( currentImageFile, height: 200, width: double.infinity, fit: BoxFit.cover,),
                          ),
                        )
                      else if (state is RecipeDetectionImageLoading)
                        Container( height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12),),
                          child: Center(child: CircularProgressIndicator(color: accentColor)),)
                      else
                        Container( height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12),),
                          child: Center( child: Text( 'Pratinjau gambar akan muncul di sini', style: TextStyle(color: Colors.grey[500]), ),),),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildImageInputAction( icon: Icons.camera_alt_outlined, label: 'Ambil\nKamera', onTap: () => _onPickImage(ImageSource.camera), isLoading: state is RecipeDetectionImageLoading,),
                          _buildImageInputAction( icon: Icons.photo_library_outlined, label: 'Pilih dari\nGaleri', onTap: () => _onPickImage(ImageSource.gallery), isLoading: state is RecipeDetectionImageLoading,),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Atau tulis daftar bahan :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),),
                const SizedBox(height: 12),
                TextField(
                  controller: _ingredientController,
                  decoration: InputDecoration( hintText: 'Contoh : Telur, Tomat, Bayam (pisahkan koma)', hintStyle: TextStyle(color: hintTextColor), /* ... (styling lain) ... */),
                  minLines: 2, maxLines: 4, style: TextStyle(color: textColor, fontSize: 15),
                  onTap: (){
                    if (currentImageFile != null || state is RecipeDetectionImagePicked) {
                      context.read<RecipeDetectionCubit>().resetDetection();
                      _ingredientController.clear(); // Bersihkan juga teks jika ada gambar
                    }
                  },
                  onChanged: (text) { // Jika pengguna mulai mengetik, reset state gambar
                     if (text.isNotEmpty && (currentImageFile != null || state is RecipeDetectionImagePicked)) {
                        context.read<RecipeDetectionCubit>().resetDetection();
                     }
                  },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (state is RecipeDetectionProcessing || state is RecipeDetectionImageLoading) 
                                ? null 
                                : _onDetectRecipesPressed,
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor, padding: const EdgeInsets.symmetric(vertical: 16),),
                    child: (state is RecipeDetectionProcessing)
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : Text('DETEKSI RESEP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),

                Text('Informasi & Hasil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),),
                const SizedBox(height: 12),
                _buildResultsArea(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageInputAction({required IconData icon, required String label, required VoidCallback onTap, bool isLoading = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.2)),
          onPressed: isLoading ? null : onTap, // Nonaktifkan saat loading gambar
          style: ElevatedButton.styleFrom(
            backgroundColor: iconColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10),),
            minimumSize: const Size(0, 50),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsArea(RecipeDetectionState state) {
    String messageToShow = "Pilih gambar atau masukkan bahan untuk memulai.";
    List<Recipe> recipesToShow = [];

    if (state is RecipeDetectionImageLoading) messageToShow = "Memuat gambar...";
    if (state is RecipeDetectionImagePicked) messageToShow = "Gambar dipilih. Tekan 'DETEKSI RESEP'.";
    if (state is RecipeDetectionProcessing) messageToShow = state.message;
    if (state is RecipeDetectionIngredientsDetected) messageToShow = "Bahan terdeteksi: ${state.ingredients.join(', ')}\nSedang mencari resep...";
    if (state is RecipeDetectionSuccess) {
      messageToShow = "Resep ditemukan (${state.matchedRecipes.length} resep) berdasarkan bahan: ${state.detectedIngredients.join(', ')}";
      recipesToShow = state.matchedRecipes;
    }
    if (state is RecipeDetectionNoMatch) messageToShow = "Tidak ada resep yang cocok ditemukan untuk bahan: ${state.detectedIngredients.join(', ')}";
    if (state is RecipeDetectionError) messageToShow = "Error: ${state.message}";
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration( color: textFieldFillColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor.withOpacity(0.7)),),
          child: Text( messageToShow, style: TextStyle(fontSize: 15, color: textColor.withOpacity(0.9)), textAlign: TextAlign.center,),
        ),
        if (recipesToShow.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text("Resep yang Cocok:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipesToShow.length,
            itemBuilder: (context, index) {
              final recipe = recipesToShow[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10), color: cardColor, elevation: 1,
                child: ListTile(
                  leading: recipe.imageUrl.isNotEmpty
                      ? ClipRRect( borderRadius: BorderRadius.circular(6),
                          child: Image.network( recipe.imageUrl, width: 60, height: 60, fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => Container(width:60, height:60, color:Colors.grey[200], child: Icon(Icons.restaurant, color: Colors.grey[400])),),)
                      : Container(width:60, height:60, color:Colors.grey[200], child: Icon(Icons.restaurant, color: Colors.grey[400])),
                  title: Text(recipe.name, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text('${recipe.category} • ${recipe.cookTime} • ${recipe.difficulty}', style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7))),
                  onTap: () {
                    Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
                  },
                ),
              );
            },
          )
        ]
      ],
    );
  }
}
