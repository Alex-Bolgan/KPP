import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String type;
  final double amount;
  final String category;
  final String description;
  final String accountId;
  final DateTime date;
  final String icon;
  final String userId; // User ID to associate the transaction with a specific user

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.accountId,
    required this.date,
    required this.icon,
    required this.userId,
  });

  factory Transaction.fromFirestore(Map<String, dynamic> data) {
    return Transaction(
      id: data['id'],
      type: data['type'],
      amount: data['amount'],
      category: data['category'],
      description: data['description'],
      accountId: data['accountId'],
      date: (data['date'] as Timestamp).toDate(),
      icon: data['icon'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'accountId': accountId,
      'date': date,
      'icon': icon,
      'userId': userId,
    };
  }
}