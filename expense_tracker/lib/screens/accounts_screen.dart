import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Account Balance',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              '\$9400',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Wallet'),
              trailing: Text('\$400'),
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Card1'),
              trailing: Text('\$2000'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('+ Add new wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
