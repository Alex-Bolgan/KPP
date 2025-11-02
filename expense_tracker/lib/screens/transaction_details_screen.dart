import 'package:flutter/material.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String transactionType;
  final String amount;
  final String category;
  final String description;
  final String wallet;
  final String date;

  const TransactionDetailsScreen({
    super.key,
    required this.transactionType,
    required this.amount,
    required this.category,
    required this.description,
    required this.wallet,
    required this.date,
  });

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late String selectedDate;
  late String selectedCategory;
  late String selectedWallet;
  late String description;

  @override
  void initState() {
    super.initState();
    // Initialize fields with values passed from the transaction
    selectedDate = widget.date;
    selectedCategory = widget.category;
    selectedWallet = widget.wallet;
    description = widget.description;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.transactionType == 'Income'
            ? Colors.green
            : Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.transactionType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: widget.transactionType == 'Income'
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'How much?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.amount,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Shopping', 'Food', 'Transport', 'Bills', 'Other']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Description Field
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Wallet Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedWallet,
                    decoration: const InputDecoration(
                      labelText: 'Wallet',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Wallet', 'Card1', 'Bank Account']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedWallet = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                print('Continue button pressed');
                print('Category: $selectedCategory');
                print('Description: $description');
                print('Wallet: $selectedWallet');
                print('Date: $selectedDate');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}