
class Account {
  final String id;
  final String name;
  final double balance;
  final String icon;
  final String userId; // User ID to associate the account with a specific user

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.icon,
    required this.userId,
  });

  factory Account.fromFirestore(Map<String, dynamic> data) {
    return Account(
      id: data['id'],
      name: data['name'],
      balance: data['balance'],
      icon: data['icon'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'icon': icon,
      'userId': userId,
    };
  }
}