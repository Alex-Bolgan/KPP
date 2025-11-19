import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import 'transaction_details_screen.dart';

class AccountDetailsScreen extends StatelessWidget {
  final Account account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Filter transactions that belong to the account
    final transactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton(
            onPressed: () {
              print('Edit account details');
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withAlpha(20),
              radius: 50,
              child: Icon(account.icon, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              account.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              account.balance,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
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
        // Access the provider safely and navigate to TransactionDetailsScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                transactionType: transaction.type,
                amount: transaction.amount,
                category: transaction.category,
                description: transaction.description,
                wallet: transaction.wallet,
                date: transaction.date,
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
            child: Icon(transaction.icon, color: transaction.type == 'Income' ? Colors.green : Colors.red),
          ),
          title: Text(transaction.category),
          subtitle: Text(transaction.description),
          trailing: Text(
            transaction.amount,
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