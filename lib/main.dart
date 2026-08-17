import 'package:flutter/material.dart';

void main() {
  runApp(const RecipeFinderApp());
}

class RecipeFinderApp extends StatelessWidget {
  const RecipeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Recipe {
  final String name;
  final String category;
  final String image;
  final String ingredients;
  final String instructions;

  const Recipe({
    required this.name,
    required this.category,
    required this.image,
    required this.ingredients,
    required this.instructions,
  });
}

const recipes = [
  Recipe(
    name: 'Chicken Biryani',
    category: 'Dinner',
    image: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=800',
    ingredients: 'Chicken, basmati rice, onions, tomatoes, yogurt, ginger, garlic and biryani spices.',
    instructions: 'Cook the rice until partly done. Prepare spiced chicken gravy, layer it with rice, then steam on low heat until fully cooked.',
  ),
  Recipe(
    name: 'Chicken Pasta',
    category: 'Lunch',
    image: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=800',
    ingredients: 'Pasta, chicken, cream, garlic, onion, parmesan and black pepper.',
    instructions: 'Boil pasta. Cook chicken with garlic and onion, add cream and parmesan, then toss with pasta and serve hot.',
  ),
  Recipe(
    name: 'Vegetable Salad',
    category: 'Healthy',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    ingredients: 'Lettuce, cucumber, tomato, carrot, sweet corn, lemon juice and olive oil.',
    instructions: 'Chop all vegetables, combine in a bowl and finish with lemon juice, olive oil, salt and pepper.',
  ),
  Recipe(
    name: 'Pancakes',
    category: 'Breakfast',
    image: 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800',
    ingredients: 'Flour, milk, egg, sugar, baking powder and butter.',
    instructions: 'Mix the ingredients into a smooth batter. Cook small portions on a hot pan until golden on both sides.',
  ),
  Recipe(
    name: 'Beef Burger',
    category: 'Fast Food',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    ingredients: 'Burger buns, beef patty, lettuce, tomato, cheese, onion and burger sauce.',
    instructions: 'Grill the beef patty, toast the buns and assemble with cheese, vegetables and sauce.',
  ),
  Recipe(
    name: 'Chocolate Cake',
    category: 'Dessert',
    image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
    ingredients: 'Flour, cocoa powder, sugar, eggs, milk, butter and baking powder.',
    instructions: 'Mix the batter, pour into a greased pan and bake until a toothpick comes out clean. Cool before serving.',
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = recipes
        .where((r) => r.name.toLowerCase().contains(search.toLowerCase()) ||
            r.category.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Finder', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Find your next favorite meal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => search = value),
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .72,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final recipe = filtered[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              recipe.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.restaurant, size: 48)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(recipe.category, style: TextStyle(color: Colors.deepOrange.shade700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.image, width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(recipe.category, style: TextStyle(color: Colors.deepOrange.shade700, fontSize: 16)),
                  const SizedBox(height: 24),
                  const Text('Ingredients', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(recipe.ingredients, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 24),
                  const Text('Instructions', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(recipe.instructions, style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
