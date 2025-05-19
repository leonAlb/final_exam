import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finale_project/models/expense.dart';

class ExpenseService {
  final CollectionReference expenseCollection = FirebaseFirestore.instance.collection('expenses');

  Future<Expense> addExpense(Expense expense) async {
    final docRef = await expenseCollection.add(expense.toMap());
    return expense.copyWith(id: docRef.id);
  }

  Future<List<Expense>> getExpensesForGroup(String groupId) async {
    final snapshot = await expenseCollection
        .where('groupId', isEqualTo: groupId)
        .get();
    return snapshot.docs.map((doc) => Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateExpense(Expense expense) {
    return expenseCollection.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) {
    return expenseCollection.doc(id).delete();
  }
}
