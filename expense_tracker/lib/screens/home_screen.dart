import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'transaction_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> filterOptions = ["Today", "Week", "Month", "Year"];
  int selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch transactions when screen initializes
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions; // Get transactions from provider

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              print('Notifications clicked');
            },
          ),
        ],
      ),
      body: transactions.isEmpty
          ? const Center(child: Text('No transactions available.'))
          : Column(
              children: [
                const SizedBox(height: 16),
                _buildFilterRow(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        title: Text(transaction.category),
                        subtitle: Text(transaction.description),
                        trailing: Text(
                          transaction.amount.toString(),
                          style: TextStyle(
                            color: transaction.type == 'Income' ? Colors.green : Colors.red,
                          ),
                        ),
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
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        filterOptions.length,
        (index) {
          final isSelected = index == selectedFilterIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilterIndex = index;
              });
              // Add filtering logic here
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filterOptions[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}