import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/transaction.dart';

abstract class TransactionsRepository {
  Future<List<Transaction>> getTransactions(String userId);
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}

class FirestoreTransactionsRepository implements TransactionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Transaction>> getTransactions(String userId) async {
    try {
      final transactionSnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .get();

      if (transactionSnapshot.docs.isEmpty) return [];

      // Fetch wallet names for each transaction
      List<Transaction> transactions = [];

      for (var doc in transactionSnapshot.docs) {
        final data = doc.data();
        final accountId = data['accountId'];

        // Fetch wallet (account) name from the accounts collection
        final accountDoc = await _firestore.collection('accounts').doc(accountId).get();
        final walletName = accountDoc.exists ? accountDoc.data()!['name'] : 'Unknown Wallet';

        // Create transaction with wallet name
        transactions.add(Transaction.fromFirestore(data, walletName: walletName));
      }

      return transactions;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.id)
          .set(transaction.toFirestore());
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toFirestore());
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}