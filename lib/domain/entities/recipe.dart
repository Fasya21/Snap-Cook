class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final List<String> ingredients;
  final List<String> steps;
  final String category;
  final String cookTime;
  final String difficulty;
  final String? description; // Opsional, bisa null
  final String? servings; // Opsional, bisa null

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.cookTime,
    required this.difficulty,
    this.description,
    this.servings,
  });

  // Opsional: Factory constructor untuk membuat instance Recipe dari JSON
  // Ini akan berguna saat kita memuat data dari file JSON atau API
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(), // Konversi num ke double
      ingredients: List<String>.from(json['ingredients'] as List<dynamic>),
      steps: List<String>.from(json['steps'] as List<dynamic>),
      category: json['category'] as String,
      cookTime: json['cookTime'] as String,
      difficulty: json['difficulty'] as String,
      description: json['description'] as String?,
      servings: json['servings'] as String?,
    );
  }

  // Opsional: Method toJson untuk konversi instance Recipe ke JSON
  // Berguna jika Anda ingin mengirim data ini ke server atau menyimpannya
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'ingredients': ingredients,
      'steps': steps,
      'category': category,
      'cookTime': cookTime,
      'difficulty': difficulty,
      'description': description,
      'servings': servings,
    };
  }
}
