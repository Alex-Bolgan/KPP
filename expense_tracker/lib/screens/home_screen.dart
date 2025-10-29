import 'package:flutter/material.dart';
import 'package:expense_tracker/utilities/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[50],
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          AppStrings.homeTitle,
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
        color: Colors.amber[50], // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.accountBalance,
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.recentTransactions,
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
                    AppStrings.seeAll,
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
              child: ListView(
                children: [
                  _buildTransactionTile(
                    title: 'Shopping',
                    subtitle: 'Buy some groceries',
                    amount: '-\$120',
                    color: Colors.red,
                    icon: Icons.shopping_cart,
                  ),
                  _buildTransactionTile(
                    title: 'Food',
                    subtitle: 'Dinner',
                    amount: '-\$32',
                    color: Colors.orange,
                    icon: Icons.fastfood,
                  ),
                  _buildTransactionTile(
                    title: 'Salary',
                    subtitle: 'Monthly income',
                    amount: '+\$2000',
                    color: Colors.green,
                    icon: Icons.attach_money,
                  ),
                ],
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
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                title == 'Income' ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color: color, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
      {required String title,
      required String subtitle,
      required String amount,
      required Color color,
      required IconData icon}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          amount,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}