import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/account.dart';

abstract class AccountsRepository {
  Future<List<Account>> getAccounts(String userId);
  Future<void> addAccount(Account account);
  Future<void> updateAccount(Account account);
  Future<void> deleteAccount(String id);
}

class FirestoreAccountsRepository implements AccountsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Account>> getAccounts(String userId) async {
    final snapshot = await _firestore
        .collection('accounts')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => Account.fromFirestore(doc.data())).toList();
  }

  @override
  Future<void> addAccount(Account account) async {
    await _firestore.collection('accounts').doc(account.id).set(account.toFirestore());
  }

  @override
  Future<void> updateAccount(Account account) async {
    await _firestore.collection('accounts').doc(account.id).update(account.toFirestore());
  }

  @override
  Future<void> deleteAccount(String id) async {
    await _firestore.collection('accounts').doc(id).delete();
  }
}