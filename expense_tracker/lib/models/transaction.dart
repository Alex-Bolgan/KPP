import 'package:flutter/material.dart';

class Transaction {
  final String type; // Income or Expense
  final String amount;
  final String category;
  final String description;
  final String wallet;
  final String date;
  final IconData icon;

  Transaction({
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.wallet,
    required this.date,
    required this.icon,
  });
}
