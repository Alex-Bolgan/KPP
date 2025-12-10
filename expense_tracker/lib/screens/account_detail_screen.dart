import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_to_icon/string_to_icon.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../providers/account_provider.dart';
import '../screens/transaction_details_screen.dart';

class AccountDetailsScreen extends StatefulWidget {
  final Account account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  List<Transaction> _transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      final transactions = await transactionProvider.getTransactionsForAccount(widget.account.id);
      setState(() {
        _transactions = transactions;
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

  Future<void> _updateAccount() async {
    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);

      // Show a dialog to edit account details
      final editedName = await _showEditAccountDialog();
      if (editedName == null || editedName.isEmpty) return;

      // Create updated account
      final updatedAccount = Account(
        id: widget.account.id,
        name: editedName,
        balance: widget.account.balance, // Keeping balance unchanged
        icon: widget.account.icon,
        userId: widget.account.userId,
      );

      // Update the account
      await accountProvider.updateAccount(updatedAccount);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(); // Go back after updating
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update account: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _showEditAccountDialog() async {
    String? newAccountName = widget.account.name;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Account'),
          content: TextFormField(
            initialValue: widget.account.name,
            decoration: const InputDecoration(
              labelText: 'Account Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              newAccountName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(newAccountName),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);

      // Delete the account
      await accountProvider.deleteAccount(widget.account.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(); // Go back after deleting
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account: $e'),
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
            onPressed: _updateAccount,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _deleteAccount,
            icon: const Icon(Icons.delete),
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
                    '\$${widget.account.balance.toStringAsFixed(2)}',
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