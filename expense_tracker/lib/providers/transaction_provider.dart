import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to store transactions locally
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Fetch all transactions for a specific user from Firestore
  Future<void> fetchTransactions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId) // Filter transactions by userId
          .get();

      _transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return Transaction.fromFirestore(data);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  // Fetch a specific transaction by ID
  Future<Transaction?> getTransactionById(String transactionId) async {
    try {
      final doc = await _firestore.collection('transactions').doc(transactionId).get();
      if (doc.exists) {
        return Transaction.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching transaction by ID: $e');
      return null;
    }
  }

  // Add a new transaction to Firestore
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _firestore.collection('transactions').doc(transaction.id).set(transaction.toFirestore());
      _transactions.add(transaction);
      notifyListeners();
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  // Update an existing transaction in Firestore
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _firestore.collection('transactions').doc(transaction.id).update(transaction.toFirestore());
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  // Delete a transaction from Firestore
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
      _transactions.removeWhere((transaction) => transaction.id == transactionId);
      notifyListeners();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  // Fetch transactions for a specific account
  Future<void> fetchTransactionsForAccount(String accountId) async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('accountId', isEqualTo: accountId)
          .get();

      _transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return Transaction.fromFirestore(data);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
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
        final weekDay = now.weekday; // Monday = 1, Sunday = 7
        startDate = now.subtract(Duration(days: weekDay - 1)); // Start of the week (Monday)
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month);
        break;
      case 'Year':
        startDate = DateTime(now.year);
        break;
      default:
        startDate = DateTime(1970); // Default to fetch all transactions
    }

    // Filter transactions based on the startDate
    return _transactions.where((transaction) {
      return transaction.date.isAfter(startDate);
    }).toList();
  }
}