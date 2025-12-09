import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CateogoriesService {
    final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.orange},
    {'name': 'Food', 'icon': Icons.fastfood, 'color': Colors.red},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'name': 'Bills', 'icon': Icons.receipt, 'color': Colors.purple},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.green},
    {'name': 'Health', 'icon': Icons.health_and_safety, 'color': Colors.teal},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.cyan},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.orange},
  ];

  final List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Salary', 'icon': Icons.attach_money, 'color': Colors.green},
    {'name': 'Bonus', 'icon': Icons.card_giftcard, 'color': Colors.blue},
    {'name': 'Investments', 'icon': Icons.trending_up, 'color': Colors.teal},
    {'name': 'Freelance', 'icon': Icons.work, 'color': Colors.orange},
  ];
}