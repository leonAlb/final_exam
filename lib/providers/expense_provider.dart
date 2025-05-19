import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];
  final ExpenseService _expensesService = ExpenseService();

  List<Expense> get expenses => _expenses;

  Future<void> loadExpensesForGroup(String groupId) async {
    final loadedExpenses = await _expensesService.getExpensesForGroup(groupId);
    _expenses.clear();
    _expenses.addAll(loadedExpenses);
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    final saved = await _expensesService.addExpense(expense);
    _expenses.add(saved);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await _expensesService.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    await _expensesService.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}