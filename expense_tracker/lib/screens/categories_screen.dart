import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: List.generate(8, (index) {
          return _buildCategoryCard(index % 2 == 0 ? 'Shopping' : 'Food', index % 2 == 0 ? Colors.orange : Colors.red);
        }),
      ),
    );
  }

  Widget _buildCategoryCard(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag, size: 40, color: color),
          SizedBox(height: 8),
          Text(title, style: TextStyle(color: color, fontSize: 16)),
        ],
      ),
    );
  }
}
