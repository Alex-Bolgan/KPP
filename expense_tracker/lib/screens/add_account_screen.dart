import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_to_icon/string_to_icon.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  // Get all icon names from Material Icons using StringToIcon package
  final List<String> availableIconNames = IconMapper.getSupportedIconNames();
  String? selectedIconName; // To store the name of the selected icon

  @override
  void initState() {
    super.initState();
    selectedIconName = availableIconNames.first; // Default to the first available icon name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.purple.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '\$0.00',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Account Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _accountNameController,
              decoration: InputDecoration(
                hintText: 'Enter account name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Icons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: availableIconNames.length,
                itemBuilder: (context, index) {
                  final iconName = availableIconNames[index];
                  final iconData = IconMapper.getIconData(iconName);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIconName = iconName;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIconName == iconName
                            ? Colors.purple.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        iconData,
                        color: selectedIconName == iconName
                            ? Colors.purple
                            : Colors.grey,
                        size: 36,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_accountNameController.text.isEmpty ||
                    _balanceController.text.isEmpty ||
                    selectedIconName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all the fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Save the account details
                final accountName = _accountNameController.text.trim();
                final balance =
                    double.tryParse(_balanceController.text.trim()) ?? 0.0;
                  
                if (FirebaseAuth.instance.currentUser == null) {
  print('Error: User is not authenticated.');
  return;
}
                // Create an Account instance
                final newAccount = Account(
                  id: DateTime.now().toString(), // Generate unique ID
                  name: accountName,
                  balance: balance,
                  icon: selectedIconName!, userId: FirebaseAuth.instance.currentUser!.uid, // Save the icon name
                );

                // Add the account using the Provider
                Provider.of<AccountProvider>(context, listen: false)
                    .addAccount(newAccount);

                // Show success message and navigate back
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}