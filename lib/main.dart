import 'package:flutter/material.dart';

void main() => runApp(const RecipeFinderApp());

class RecipeFinderApp extends StatelessWidget {
  const RecipeFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Finder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const HomePage(),
    );
  }
}

class Recipe {
  final String name, category, image, ingredients, instructions;
  const Recipe({required this.name, required this.category, required this.image, required this.ingredients, required this.instructions});
}

const recipes = <Recipe>[
  Recipe(name: 'Chicken Biryani', category: 'Dinner', image: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=900', ingredients: 'Chicken, basmati rice, onions, tomatoes, yogurt, ginger, garlic and biryani spices.', instructions: 'Cook the rice until partly done. Prepare spiced chicken gravy, layer it with rice, then steam on low heat until fully cooked.'),
  Recipe(name: 'Chicken Pasta', category: 'Lunch', image: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=900', ingredients: 'Pasta, chicken, cream, garlic, onion, parmesan and black pepper.', instructions: 'Boil pasta. Cook chicken with garlic and onion, add cream and parmesan, then toss with pasta and serve hot.'),
  Recipe(name: 'Vegetable Salad', category: 'Healthy', image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900', ingredients: 'Lettuce, cucumber, tomato, carrot, sweet corn, lemon juice and olive oil.', instructions: 'Chop all vegetables, combine in a bowl and finish with lemon juice, olive oil, salt and pepper.'),
  Recipe(name: 'Pancakes', category: 'Breakfast', image: 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=900', ingredients: 'Flour, milk, egg, sugar, baking powder and butter.', instructions: 'Mix the ingredients into a smooth batter. Cook small portions on a hot pan until golden on both sides.'),
  Recipe(name: 'Beef Burger', category: 'Fast Food', image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900', ingredients: 'Burger buns, beef patty, lettuce, tomato, cheese, onion and burger sauce.', instructions: 'Grill the beef patty, toast the buns and assemble with cheese, vegetables and sauce.'),
  Recipe(name: 'Chocolate Cake', category: 'Dessert', image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=900', ingredients: 'Flour, cocoa powder, sugar, eggs, milk, butter and baking powder.', instructions: 'Mix the batter, pour into a greased pan and bake until a toothpick comes out clean. Cool before serving.'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';
  String category = 'All';
  final favorites = <String>{};

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...recipes.map((r) => r.category).toSet()];
    final filtered = recipes.where((r) {
      final matchesSearch = r.name.toLowerCase().contains(search.toLowerCase());
      final matchesCategory = category == 'All' || r.category == category;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Finder', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu_book_outlined))],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Find your next favorite meal', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('Search simple recipes and start cooking.', style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          TextField(
            onChanged: (v) => setState(() => search = v),
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.deepOrange.withValues(alpha: .06),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(categories[i]),
                selected: category == categories[i],
                onSelected: (_) => setState(() => category = categories[i]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No recipes found. Try another search.'))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .68),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final recipe = filtered[index];
                      final liked = favorites.contains(recipe.name);
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        child: InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe))),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: Stack(children: [
                                Positioned.fill(child: Image.network(recipe.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.restaurant, size: 48)))),
                                Positioned(top: 8, right: 8, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(padding: EdgeInsets.zero, onPressed: () => setState(() => liked ? favorites.remove(recipe.name) : favorites.add(recipe.name)), icon: Icon(liked ? Icons.favorite : Icons.favorite_border, color: liked ? Colors.red : Colors.black54)))),
                              ]),
                            ),
                            Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(recipe.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(recipe.category, style: TextStyle(color: Colors.deepOrange.shade700)),
                            ])),
                          ]),
                        ),
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(recipe.name)),
    body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Image.network(recipe.image, width: double.infinity, height: 260, fit: BoxFit.cover),
      Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(recipe.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(recipe.category, style: TextStyle(color: Colors.deepOrange.shade700, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        const Text('Ingredients', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(recipe.ingredients, style: const TextStyle(fontSize: 16, height: 1.55)),
        const SizedBox(height: 24),
        const Text('Instructions', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(recipe.instructions, style: const TextStyle(fontSize: 16, height: 1.55)),
      ])),
    ])),
  );
}
