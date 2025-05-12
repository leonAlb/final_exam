import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final CollectionReference expensesCollection = FirebaseFirestore.instance.collection('expenses');

  Future<Expense> addExpense(Expense expense) async {
    final docRef = await expensesCollection.add(expense.toMap());
    return expense.copyWith(id: docRef.id);
  }

  Future<List<Expense>> getExpensesForGroup(String groupId) async {
    final snapshot = await expensesCollection
        .where('groupId', isEqualTo: groupId)
        .get();
    return snapshot.docs.map((doc) => Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateExpense(Expense expense) {
    return expensesCollection.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) {
    return expensesCollection.doc(id).delete();
  }
}
