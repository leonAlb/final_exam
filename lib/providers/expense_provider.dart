import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpensesProvider with ChangeNotifier {
  final List<Expense> _expenses = [];
  final ExpenseService _expenseService = ExpenseService();

  List<Expense> get expenses => _expenses;

  Future<void> loadExpensesForGroup(String groupId) async {
    final loadedExpenses = await _expenseService.getExpensesForGroup(groupId);
    _expenses.clear();
    _expenses.addAll(loadedExpenses);
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    final saved = await _expenseService.addExpense(expense);
    _expenses.add(saved);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await _expenseService.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    await _expenseService.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}