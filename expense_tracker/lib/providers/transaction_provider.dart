import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to store transactions locally after fetching from Firestore
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Fetch all transactions from Firestore
  Future<void> fetchTransactions() async {
    try {
      final snapshot = await _firestore.collection('transactions').get();
      _transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return Transaction.fromFirestore(data);
      }).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
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
}