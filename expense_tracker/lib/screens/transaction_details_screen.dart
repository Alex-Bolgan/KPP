import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../providers/transaction_provider.dart';
import '../providers/account_provider.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
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
      // Get current user ID from Firebase Authentication
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Use AccountProvider to fetch accounts
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      accounts = await accountProvider.fetchAccounts(user.uid);

      // Use TransactionProvider to fetch specific transaction
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      final transaction = await transactionProvider.getTransactionById(widget.transactionId);

      if (transaction != null) {
        setState(() {
          transactionType = transaction.type;
          amount = transaction.amount.toString();
          category = categories.contains(transaction.category) ? transaction.category : categories.first;
          wallet = accounts.firstWhere((account) => account.id == transaction.accountId).name;
          description = transaction.description;
          selectedDate = transaction.date.toString().split(' ')[0];
          isLoading = false;
        });
      } else {
        throw Exception('Transaction not found');
      }
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
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      // Get account ID based on selected wallet name
      final accountId = accounts.firstWhere((account) => account.name == wallet).id;

      // Create updated transaction
      final transaction = Transaction(
        id: widget.transactionId,
        type: transactionType,
        amount: double.parse(amount),
        category: category,
        description: description,
        accountId: accountId,
        accountName: wallet,
        date: DateTime.parse(selectedDate),
        icon: category,
        userId: FirebaseAuth.instance.currentUser!.uid,
      );

      // Use TransactionProvider to update the transaction
      await transactionProvider.updateTransaction(transaction);

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
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      // Use TransactionProvider to delete the transaction
      await transactionProvider.deleteTransaction(widget.transactionId);

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
              items: accounts.map((e) {
                return DropdownMenuItem(
                  value: e.name,
                  child: Text(e.name),
                );
              }).toList(),
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
                'Update Transaction',
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