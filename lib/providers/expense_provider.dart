import 'package:finale_project/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../models/expense.dart';
import '../services/email_utils.dart';
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

        final Map<String, double> netBalances = {};

        for (final expense in _expenses) {
            final payer = expense.payerId;
            netBalances[payer] = (netBalances[payer] ?? 0) + expense.amount;
            expense.participantShares.forEach((participantId, shareAmount) {
                    netBalances[participantId] = (netBalances[participantId] ?? 0) - shareAmount;
                });
        }

        final debtors = netBalances.entries.where((e) => e.value < 0).toList();
        final creditors = netBalances.entries.where((e) => e.value > 0).toList();
        final Map<String, Map<String, double>> debts = {};

        int i = 0, j = 0;
        while (i < debtors.length && j < creditors.length) {
            final debtorId = debtors[i].key;
            var debtorAmount = -debtors[i].value;
            final creditorId = creditors[j].key;
            var creditorAmount = creditors[j].value;

            final payment = debtorAmount < creditorAmount ? debtorAmount : creditorAmount;
            debts.putIfAbsent(debtorId, () => {})[creditorId] = payment;

            debtorAmount -= payment;
            creditorAmount -= payment;

            if (debtorAmount == 0) i++;
            else debtors[i] = MapEntry(debtorId, -debtorAmount);

            if (creditorAmount == 0) j++;
            else creditors[j] = MapEntry(creditorId, creditorAmount);
        }

        await sendMailsToDebtors(settingsProvider, debts, friendsProvider);
    }
}