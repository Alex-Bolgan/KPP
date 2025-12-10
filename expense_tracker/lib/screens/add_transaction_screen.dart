import 'package:expense_tracker/services/categories_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../repositories/transactions_repository.dart';
import '../repositories/accounts_repository.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TransactionsRepository _transactionsRepository = FirestoreTransactionsRepository();
  final AccountsRepository _accountsRepository = FirestoreAccountsRepository();

  final List<Map<String, dynamic>> incomeCategories = CategoriesService.incomeCategories;
  final List<Map<String, dynamic>> expenseCategories = CategoriesService.expenseCategories;

  List<Account> accounts = [];
  late String selectedWallet;
  String transactionType = 'Expense'; // Default is Expense
  String selectedCategory = ''; // Will be dynamically set
  String description = '';
  String amount = '';
  String selectedDate = DateTime.now().toString().split(' ')[0];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAccounts();
    selectedCategory = expenseCategories.first['name']; // Default category for expense
  }

  Future<void> fetchAccounts() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      accounts = await _accountsRepository.getAccounts(user.uid);

      setState(() {
        selectedWallet = accounts.isNotEmpty ? accounts.first.name : 'No Wallet';
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching accounts: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load accounts: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addTransaction() async {
    try {
      final accountId = accounts.firstWhere((account) => account.name == selectedWallet).id;
      var uuid = Uuid();

      final transaction = Transaction(
        id: uuid.v1(),
        type: transactionType,
        amount: double.parse(amount),
        category: selectedCategory,
        description: description,
        accountId: accountId,
        accountName: selectedWallet,
        date: DateTime.parse(selectedDate),
        icon: selectedCategory,
        userId: FirebaseAuth.instance.currentUser!.uid,
      );

      await _transactionsRepository.addTransaction(transaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error adding transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add transaction: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final categories = transactionType == 'Income'
        ? incomeCategories.map((e) => e['name'] as String).toList()
        : expenseCategories.map((e) => e['name'] as String).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: transactionType,
              decoration: const InputDecoration(
                labelText: 'Transaction Type',
                border: OutlineInputBorder(),
              ),
              items: ['Income', 'Expense']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  transactionType = value!;
                  // Update categories and set default selected category
                  selectedCategory = transactionType == 'Income'
                      ? incomeCategories.first['name']
                      : expenseCategories.first['name'];
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = value;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                description = value;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedWallet,
              decoration: const InputDecoration(
                labelText: 'Wallet',
                border: OutlineInputBorder(),
              ),
              items: accounts.map((account) {
                return DropdownMenuItem(
                  value: account.name,
                  child: Text(account.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedWallet = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}