import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import 'transaction_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> filterOptions = ["Today", "Week", "Month", "Year"];
  int selectedFilterIndex = 0; // Default to "Today"

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Filter transactions based on the selected filter option
    final transactions = transactionProvider.getFilteredTransactions(
      filterOptions[selectedFilterIndex],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[50],
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Container(
        color: Colors.amber[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Balance',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Text(
              '\$9400',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard('Income', '\$5000', const Color.fromARGB(255, 26, 99, 28)),
                _buildCard('Expenses', '\$1200', const Color.fromARGB(255, 159, 13, 3)),
              ],
            ),
            const SizedBox(height: 24),
            _buildFilterRow(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('See all pressed');
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return _buildTransactionTile(
                    transaction,
                    context,
                    transaction.icon,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String amount, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                title == 'Income' ? Icons.arrow_downward : Icons.arrow_upward,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 22,
              fontWeight: FontWeight.bold,
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
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 255, 223, 186)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filterOptions[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.orange : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction, BuildContext context, IconData icon) {
    return GestureDetector(
      onTap: () { try {
        // Use Provider to set the selected transaction and navigate
        Provider.of<TransactionProvider>(context, listen: false)
            .selectTransaction(transaction);
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
      } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to open transaction details: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: transaction.type == 'Income'
                ? Colors.green.withAlpha(30)
                : Colors.red.withAlpha(30),
            child: Icon(icon),
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