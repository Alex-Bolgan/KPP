import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../repositories/transactions_repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionsRepository _transactionsRepository;

  TransactionProvider(this._transactionsRepository);

  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Fetch all transactions for a specific user
  Future<void> fetchTransactions(String userId) async {
    try {
      _transactions = await _transactionsRepository.getTransactions(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  // Fetch a specific transaction by ID
  Future<Transaction?> getTransactionById(String transactionId) async {
    try {
      return await _transactionsRepository.getTransactionById(transactionId);
    } catch (e) {
      print('Error fetching transaction by ID: $e');
      return null;
    }
  }

  // Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _transactionsRepository.addTransaction(transaction);
      _transactions.add(transaction);
      notifyListeners();
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

   Future<List<Transaction>> getTransactionsForAccount(String accountId) async {
    try {
      return await _transactionsRepository.getTransactionsForAccount(accountId);
    } catch (e) {
      print('Error adding transaction: $e');
      return List.empty();
    }
  }

  // Update an existing transaction
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _transactionsRepository.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  // Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _transactionsRepository.deleteTransaction(transactionId);
      _transactions.removeWhere((transaction) => transaction.id == transactionId);
      notifyListeners();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  // Fetch transactions for a specific account
  Future<void> fetchTransactionsForAccount(String accountId) async {
    try {
      _transactions = await _transactionsRepository.getTransactionsForAccount(accountId);
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions for account: $e');
    }
  }

  // Get filtered transactions based on the selected filter option
  List<Transaction> getFilteredTransactions(String filterOption) {
    final now = DateTime.now();
    DateTime startDate;

    switch (filterOption) {
      case 'Today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Week':
        final weekDay = now.weekday;
        startDate = now.subtract(Duration(days: weekDay - 1));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month);
        break;
      case 'Year':
        startDate = DateTime(now.year);
        break;
      default:
        startDate = DateTime(1970);
    }

    return _transactions.where((transaction) {
      return transaction.date.isAfter(startDate);
    }).toList();
  }
}