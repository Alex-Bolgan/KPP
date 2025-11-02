import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  // Hardcoded categories
  final List<Map<String, dynamic>> categories = [
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.orange},
    {'name': 'Food', 'icon': Icons.fastfood, 'color': Colors.red},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'name': 'Bills', 'icon': Icons.receipt, 'color': Colors.purple},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.green},
    {'name': 'Health', 'icon': Icons.health_and_safety, 'color': Colors.teal},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.cyan},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of items per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust this to give more vertical space
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryItem(
              category['name'],
              category['icon'],
              category['color'],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 12), // Adjust font size if needed
          overflow: TextOverflow.visible, // Ensure text is visible
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}