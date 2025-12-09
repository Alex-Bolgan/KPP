import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  final List<String> wallets = ['Wallet', 'Card1', 'Bank Account'];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails();
  }

  Future<void> fetchTransactionDetails() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('transactions').doc(widget.transactionId).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          transactionType = data['type'];
          amount = data['amount'].toString();
          category = categories.contains(data['category']) ? data['category'] : categories.first;
          wallet = wallets.contains(data['wallet']) ? data['wallet'] : wallets.first;
          description = data['description'];
          selectedDate = (data['date'] as Timestamp).toDate().toString().split(' ')[0];
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
      await FirebaseFirestore.instance.collection('transactions').doc(widget.transactionId).update({
        'type': transactionType,
        'amount': double.parse(amount),
        'category': category,
        'description': description,
        'wallet': wallet,
        'date': Timestamp.fromDate(DateTime.parse(selectedDate)),
      });
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
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          TextFormField(
            initialValue: amount,
            onChanged: (value) {
              amount = value;
            },
          ),
          // Add dropdowns and other fields similarly...
          ElevatedButton(
            onPressed: _updateTransaction,
            child: const Text('Update Transaction'),
          ),
        ],
      ),
    );
  }
}