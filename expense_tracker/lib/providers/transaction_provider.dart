import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  // Hardcoded transactions
  final List<Transaction> _transactions = [
    Transaction(
      type: 'Expense',
      amount: '-\$120',
      category: 'Shopping',
      description: 'Buy some groceries',
      wallet: 'Wallet',
      date: '2025-10-16',
      icon: Icons.shopping_bag,
    ),
    Transaction(
      type: 'Expense',
      amount: '-\$32',
      category: 'Food',
      description: 'Dinner',
      wallet: 'Wallet',
      date: '2025-10-15',
      icon: Icons.fastfood,
    ),
    Transaction(
      type: 'Income',
      amount: '+\$2000',
      category: 'Salary',
      description: 'Monthly income',
      wallet: 'Bank Account',
      date: '2025-10-10',
      icon: Icons.attach_money,
    ),
  ];

  // Selected transaction
  Transaction? _selectedTransaction;

  Transaction? get selectedTransaction => _selectedTransaction;

  // Get all transactions
  List<Transaction> get transactions => [..._transactions];

  // Filter transactions based on time period
  List<Transaction> getFilteredTransactions(String filter) {
    DateTime now = DateTime.now();
    if (filter == 'Today') {
      return _transactions.where((transaction) {
        DateTime transactionDate = DateTime.parse(transaction.date);
        return transactionDate.day == now.day &&
            transactionDate.month == now.month &&
            transactionDate.year == now.year;
      }).toList();
    } else if (filter == 'Week') {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
      return _transactions.where((transaction) {
        DateTime transactionDate = DateTime.parse(transaction.date);
        return transactionDate.isAfter(startOfWeek) &&
            transactionDate.isBefore(endOfWeek);
      }).toList();
    } else if (filter == 'Month') {
      return _transactions.where((transaction) {
        DateTime transactionDate = DateTime.parse(transaction.date);
        return transactionDate.month == now.month &&
            transactionDate.year == now.year;
      }).toList();
    } else if (filter == 'Year') {
      return _transactions.where((transaction) {
        DateTime transactionDate = DateTime.parse(transaction.date);
        return transactionDate.year == now.year;
      }).toList();
    }
    return _transactions; // Default case
  }

  // Select a transaction
  void selectTransaction(Transaction transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }
}