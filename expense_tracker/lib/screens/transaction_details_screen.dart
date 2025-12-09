import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/repositories/accounts_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../repositories/transactions_repository.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final TransactionsRepository _repository = FirestoreTransactionsRepository();
  final AccountsRepository accountsRepository = FirestoreAccountsRepository();

  late String transactionType;
  late String amount;
  late String category;
  late String description;
  late String wallet;
  late String selectedDate;

  final List<String> categories = ['Shopping', 'Food', 'Transport', 'Bills', 'Other'];
  List<Account> accounts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails();
  }

  Future<void> fetchTransactionDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Fetch accounts for the user
      accounts = await accountsRepository.getAccounts(user.uid);
        final transaction = await _repository.getTransactions('').then((transactions) {
        return transactions.firstWhere((t) => t.id == widget.transactionId);
      });

      setState(() {
        transactionType = transaction.type;
        amount = transaction.amount.toString();
        category = categories.contains(transaction.category) ? transaction.category : categories.first;
        wallet = transaction.accountName;
        description = transaction.description;
        selectedDate = transaction.date.toString().split(' ')[0];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load transaction details: $e'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateTransaction() async {
    try {
      final accountId = await accountsRepository.getAccounts('').then((accounts) {
        return accounts.firstWhere((a) => a.name == wallet).id;
      });

        final transaction = Transaction(
        id: widget.transactionId,
        type: transactionType,
        amount: double.parse(amount),
        category: category,
        description: description,
        accountName: wallet,
        date: DateTime.parse(selectedDate),
        icon: category, accountId: accountId, userId: FirebaseAuth.instance.currentUser!.uid,
      );

      await _repository.updateTransaction(transaction);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update transaction: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteTransaction() async {
    try {
      await _repository.deleteTransaction(widget.transactionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete transaction: $e'),
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
    
    return Scaffold(
      appBar: AppBar(
        title: Text(transactionType),
        backgroundColor: transactionType == 'Income' ? Colors.green : Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _deleteTransaction();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              initialValue: amount,
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
              value: category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: description,
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
              value: wallet,
              decoration: const InputDecoration(
                labelText: 'Wallet',
                border: OutlineInputBorder(),
              ),
              items: accounts.map((e) => DropdownMenuItem(value: e.name, child: Text(e.name))).toList(),
              onChanged: (value) {
                setState(() {
                  wallet = value!;
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
              onPressed: _updateTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Update',
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