import 'package:finale_project/providers/expense_provider.dart';
import 'package:finale_project/providers/friends_provider.dart';
import 'package:finale_project/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/expense_list_tile.dart';
import '../widgets/load_button_bar.dart';
import 'create_edit_expense.dart';

class GroupExpensesScreen extends StatefulWidget {
    final String groupId;
    const GroupExpensesScreen({super.key, required this.groupId});

    @override
    State<GroupExpensesScreen> createState() => _GroupExpensesScreenState();
}

class _GroupExpensesScreenState extends State<GroupExpensesScreen> {
    bool isLoading = true;
    int expensesToLoad = 7;

    @override
    void initState() {
        super.initState();
        _loadData();
    }

    Future<void> _loadData() async {
        await Provider.of<FriendsProvider>(context, listen: false).loadFriends();
        await Provider.of<ExpenseProvider>(context, listen: false).loadExpensesForGroup(widget.groupId);
        setState(() {
                isLoading = false;
            });
    }

    @override
    Widget build(BuildContext context) {
        final settingsProvider = Provider.of<SettingsProvider>(context);
        final friendsProvider = Provider.of<FriendsProvider>(context);
        final expensesProvider = Provider.of<ExpenseProvider>(context);

        final allExpenses = expensesProvider.expenses;
        final visibleExpenses = allExpenses.take(expensesToLoad).toList();

        return Scaffold(
            appBar: AppBar(
                title: const Text('Group Expenses'),
                centerTitle: true
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                        Expanded(
                            child: visibleExpenses.isEmpty
                                ? const Center(
                                    child: Text('No expenses yet', style: TextStyle(fontSize: 16, color: Colors.grey))
                                )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: visibleExpenses.length,
                                    itemBuilder: (context, index) {
                                        final expense = visibleExpenses[index];
                                        return ExpenseTile(
                                            expense: expense,
                                            groupId: widget.groupId,
                                            settingsProvider: settingsProvider,
                                            friendsProvider: friendsProvider,
                                            expensesProvider: expensesProvider
                                        );
                                    }
                                )
                        ),
                        LoadButtonBar(
                            loadMoreLabel: "Load More Expenses",
                            canLoadMore: visibleExpenses.length < allExpenses.length,
                            onLoadMore: () {
                                setState(() {
                                        expensesToLoad += expensesToLoad;
                                    });
                            },
                            createLabel: "Create Expense",
                            createIcon: Icons.euro_symbol_sharp,
                            onCreate: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CreateEditExpenseScreen(groupId: widget.groupId)
                                    )
                                );
                            }
                        ),
                        const SizedBox(height: 15)
                    ]
                )
        );
    }
}

