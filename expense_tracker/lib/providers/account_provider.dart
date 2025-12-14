import 'package:flutter/material.dart';
import '../models/account.dart';
import '../repositories/accounts_repository.dart';

class AccountProvider with ChangeNotifier {
  final AccountsRepository _accountsRepository;

  AccountProvider(this._accountsRepository);

  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  // Fetch all accounts for a specific user
  Future<void> fetchAccounts(String userId) async {
    try {
      _accounts = await _accountsRepository.getAccounts(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching accounts: $e');
    }
  }

  // Fetch a specific account by ID
  Future<Account?> getAccountById(String accountId) async {
    try {
      return await _accountsRepository.getAccountById(accountId);
    } catch (e) {
      print('Error fetching account by ID: $e');
      return null;
    }
  }

  // Add a new account
  Future<void> addAccount(Account account) async {
    try {
      await _accountsRepository.addAccount(account);
      _accounts.add(account);
      notifyListeners();
    } catch (e) {
      print('Error adding account: $e');
    }
  }

  // Update an existing account
  Future<void> updateAccount(Account account) async {
    try {
      await _accountsRepository.updateAccount(account);
      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _accounts[index] = account;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating account: $e');
    }
  }

  // Delete an account
  Future<void> deleteAccount(String accountId) async {
    try {
      await _accountsRepository.deleteAccount(accountId);
      _accounts.removeWhere((account) => account.id == accountId);
      notifyListeners();
    } catch (e) {
      print('Error deleting account: $e');
    }
  }
}