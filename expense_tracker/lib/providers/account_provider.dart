import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/account.dart';

class AccountProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to store accounts locally
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  // Fetch all accounts for a specific user from Firestore
  Future<List<Account>> fetchAccounts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('accounts')
          .where('userId', isEqualTo: userId) // Filter accounts by userId
          .get();

      _accounts = snapshot.docs.map((doc) {
        final data = doc.data();
        return Account.fromFirestore(data);
      }).toList();
      notifyListeners();
      return _accounts;
    } catch (e) {
      print('Error fetching accounts: $e');
      return [];
    }
  }

  // Fetch a specific account by ID
  Future<Account?> getAccountById(String accountId) async {
    try {
      final doc = await _firestore.collection('accounts').doc(accountId).get();
      if (doc.exists) {
        return Account.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching account by ID: $e');
      return null;
    }
  }

  // Add a new account to Firestore
  Future<void> addAccount(Account account) async {
    try {
      await _firestore.collection('accounts').doc(account.id).set(account.toFirestore());
      _accounts.add(account);
      notifyListeners();
    } catch (e) {
      print('Error adding account: $e');
    }
  }

  // Update an existing account in Firestore
  Future<void> updateAccount(Account account) async {
    try {
      await _firestore.collection('accounts').doc(account.id).update(account.toFirestore());
      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _accounts[index] = account;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating account: $e');
    }
  }

  // Delete an account from Firestore
  Future<void> deleteAccount(String accountId) async {
    try {
      await _firestore.collection('accounts').doc(accountId).delete();
      _accounts.removeWhere((account) => account.id == accountId);
      notifyListeners();
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}