import 'package:flutter/material.dart';
import '../models/account.dart';

class AccountDetailsScreen extends StatelessWidget {
  final Account account;

  AccountDetailsScreen({super.key, required this.account});

  // Hardcoded transaction data for the account
  final List<Map<String, dynamic>> transactions = [
    {
      'title': 'Shopping',
      'subtitle': 'Buy some groceries',
      'amount': '-\$120',
      'time': '10:00 AM',
      'color': Colors.red,
      'icon': Icons.shopping_bag,
    },
    {
      'title': 'Food',
      'subtitle': 'Buy a ramen',
      'amount': '-\$32',
      'time': '07:30 PM',
      'color': Colors.orange,
      'icon': Icons.fastfood,
    },
    {
      'title': 'Transportation',
      'subtitle': 'Charging Tesla',
      'amount': '-\$18',
      'time': '02:30 PM',
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Colors.blue.withOpacity(0.1),
              radius: 50,
              child: Image.asset(account.icon, width: 40),
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
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: transaction['color'].withOpacity(0.1),
                        child: Icon(transaction['icon'], color: transaction['color']),
                      ),
                      title: Text(transaction['title']),
                      subtitle: Text(transaction['subtitle']),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            transaction['amount'],
                            style: TextStyle(
                              color: transaction['color'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            transaction['time'],
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}