import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:string_to_icon/string_to_icon.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../screens/transaction_details_screen.dart';

class AccountDetailsScreen extends StatefulWidget {
  final Account account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late final FirebaseFirestore _firestore;
  List<Transaction> _transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('accountId', isEqualTo: widget.account.id)
          .get();

      setState(() {
        _transactions = snapshot.docs.map((doc) {
          final data = doc.data();
          return Transaction.fromFirestore(data);
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching transactions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load transactions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account.name),
        actions: [
          IconButton(
            onPressed: () {
              print('Edit account details');
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.withAlpha(20),
                    radius: 50,
                    child: Icon(IconMapper.getIconData(widget.account.icon), size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.account.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.account.balance.toString(),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _transactions.isEmpty
                        ? const Center(
                            child: Text(
                              'No transactions available for this account.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = _transactions[index];
                              return _buildTransactionTile(transaction, context);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              transactionId: transaction.id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: transaction.type == 'Income'
                ? Colors.green.withAlpha(20)
                : Colors.red.withAlpha(20),
            child: Icon(IconMapper.getIconData(transaction.icon), color: transaction.type == 'Income' ? Colors.green : Colors.red),
          ),
          title: Text(transaction.category),
          subtitle: Text(transaction.description),
          trailing: Text(
            transaction.amount.toString(),
            style: TextStyle(
              color: transaction.type == 'Income' ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}