import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/account_detail_screen.dart';

class AccountsScreen extends StatelessWidget {
  AccountsScreen({super.key});

  // Hardcoded account data
  final List<Map<String, dynamic>> accounts = [
    {'name': 'Wallet', 'balance': '\$400', 'icon': Icons.account_balance_wallet},
    {'name': 'Card1', 'balance': '\$2000', 'icon': Icons.credit_card},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.purple.withOpacity(0.1),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Account Balance',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  '\$2400',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return _buildAccountTile(
                  name: account['name'],
                  balance: account['balance'],
                  icon: account['icon'],
                  context: context,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('Add new wallet button pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                '+ Add new wallet',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile({
    required String name,
    required String balance,
    required IconData icon,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to account details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountDetailScreen(
              accountName: name,
              accountBalance: balance,
              accountIcon: icon,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple.withOpacity(0.1),
            child: Icon(icon, color: Colors.purple),
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            balance,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}