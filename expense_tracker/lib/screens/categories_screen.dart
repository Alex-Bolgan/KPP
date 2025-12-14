import 'package:expense_tracker/services/categories_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ExpenseCategoriesTab(),
            IncomeCategoriesTab(),
          ],
        ),
      ),
    );
  }
}

class ExpenseCategoriesTab extends StatelessWidget {
  ExpenseCategoriesTab({super.key});

    final List<Map<String, dynamic>> expenseCategories = CategoriesService.expenseCategories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8, // Adjust this to give more vertical space
        ),
        itemCount: expenseCategories.length,
        itemBuilder: (context, index) {
          final category = expenseCategories[index];
          return _buildCategoryItem(
            category['name'],
            category['icon'],
            category['color'],
          );
        },
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
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class IncomeCategoriesTab extends StatelessWidget {
  IncomeCategoriesTab({super.key});

  final List<Map<String, dynamic>> incomeCategories = CategoriesService.incomeCategories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8, // Adjust this to give more vertical space
        ),
        itemCount: incomeCategories.length,
        itemBuilder: (context, index) {
          final category = incomeCategories[index];
          return _buildCategoryItem(
            category['name'],
            category['icon'],
            category['color'],
          );
        },
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
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}