import 'package:flutter/material.dart';
import '../models/account.dart';

class AccountProvider with ChangeNotifier {
  // Hardcoded list of accounts
  final List<Account> _accounts = [
    Account(
      name: 'Wallet',
      balance: '\$400',
      icon: 'assets/icons/wallet.png',
    ),
    Account(
      name: 'Card1',
      balance: '\$2000',
      icon: 'assets/icons/card.png',
    ),
  ];

  // Getter for accounts
  List<Account> get accounts => [..._accounts];

  // Selected account
  Account? _selectedAccount;

  Account? get selectedAccount => _selectedAccount;

  // Set the selected account
  void selectAccount(Account account) {
    _selectedAccount = account;
    notifyListeners();
  }
}