import 'package:finale_project/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/balance_calc_utils.dart';
import '../utils/email_utils.dart';
import '../services/expense_service.dart';
import 'friends_provider.dart';

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

    Future<void> sendDebtEmails(String groupId, FriendsProvider friendsProvider, SettingsProvider settingsProvider) async {
        await loadExpensesForGroup(groupId);
        final result = await calculateBalance(_expenses);
        await sendMailsToDebtors(settingsProvider, result, friendsProvider);
    }
}