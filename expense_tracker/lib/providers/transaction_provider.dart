import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  // Hardcoded transactions
  final List<Transaction> _transactions = [
    Transaction(
      type: 'Expense',
      amount: '-\$120',
      category: 'Shopping',
      description: 'Buy some groceries',
      wallet: 'Wallet',
      date: 'Apr 1, 2025',
      icon: Icons.shopping_bag,
    ),
    Transaction(
      type: 'Expense',
      amount: '-\$32',
      category: 'Food',
      description: 'Dinner',
      wallet: 'Wallet',
      date: 'Apr 2, 2025',
      icon: Icons.fastfood,
    ),
    Transaction(
      type: 'Income',
      amount: '+\$2000',
      category: 'Salary',
      description: 'Monthly income',
      wallet: 'Bank Account',
      date: 'Apr 3, 2025',
      icon: Icons.money,
    ),
  ];

  // Getter for transactions
  List<Transaction> get transactions => [..._transactions];

  // Selected transaction
  Transaction? _selectedTransaction;

  Transaction? get selectedTransaction => _selectedTransaction;

  // Update the selected transaction
  void selectTransaction(Transaction transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }

  // Update a specific transaction (placeholder for saving edits)
  void updateTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexOf(_selectedTransaction!);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      _selectedTransaction = updatedTransaction;
      notifyListeners();
    }
  }
}