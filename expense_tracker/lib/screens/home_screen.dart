import 'package:expense_tracker/screens/transaction_details_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> filterOptions = ['Today', 'Week', 'Month', 'Year'];
  int selectedFilter = 0; // Selected filter index

  // Hardcoded transaction data
  final Map<String, List<Map<String, dynamic>>> transactions = {
    'Today': [
      {
        'title': 'Shopping',
        'subtitle': 'Buy some groceries',
        'amount': '-\$120',
        'color': Colors.orange,
        'icon': Icons.shopping_bag,
      },
      {
        'title': 'Food',
        'subtitle': 'Dinner',
        'amount': '-\$32',
        'color': Colors.red,
        'icon': Icons.fastfood,
      },
    ],
    'Week': [
      {
        'title': 'Salary',
        'subtitle': 'Monthly income',
        'amount': '+\$2000',
        'color': Colors.green,
        'icon': Icons.attach_money,
      },
      {
        'title': 'Shopping',
        'subtitle': 'Buy new shoes',
        'amount': '-\$150',
        'color': Colors.orange,
        'icon': Icons.shopping_bag,
      },
    ],
    'Month': [
      {
        'title': 'Groceries',
        'subtitle': 'Supermarket shopping',
        'amount': '-\$300',
        'color': Colors.orange,
        'icon': Icons.shopping_cart,
      },
      {
        'title': 'Rent',
        'subtitle': 'Monthly house rent',
        'amount': '-\$800',
        'color': Colors.red,
        'icon': Icons.house,
      },
    ],
    'Year': [
      {
        'title': 'Bonus',
        'subtitle': 'Year-end bonus',
        'amount': '+\$5000',
        'color': Colors.green,
        'icon': Icons.money,
      },
      {
        'title': 'Vacation',
        'subtitle': 'Trip to Hawaii',
        'amount': '-\$2000',
        'color': Colors.purple,
        'icon': Icons.beach_access,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
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
        color: Colors.amber[50], // Background color
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
            _buildTransactionFilter(),
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
                itemCount: transactions[filterOptions[selectedFilter]]!.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[filterOptions[selectedFilter]]![index];
                  return _buildTransactionTile(
                    title: transaction['title'],
                    subtitle: transaction['subtitle'],
                    amount: transaction['amount'],
                    color: transaction['color'],
                    icon: transaction['icon'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        filterOptions.length,
        (index) {
          final isSelected = index == selectedFilter;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = index;
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
                color: const Color.fromARGB(255, 255, 223, 186),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(color:const Color.fromARGB(255, 255, 223, 186), fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 223, 186),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile({
  required String title,
  required String subtitle,
  required String amount,
  required Color color,
  required IconData icon,
}) {
  return GestureDetector(
    onTap: () {
      // Navigate to TransactionDetailsScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionDetailsScreen(
            transactionType: title.contains('Salary') || title.contains('Bonus')
                ? 'Income'
                : 'Expense',
            amount: amount,
            category: title,
            description: subtitle,
            wallet: 'Wallet', // Hardcoded wallet for now
            date: 'Apr 1, 2025', // Hardcoded date for now
          ),
        ),
      );
    },
    child: Card(
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
    ),
  );
}
}