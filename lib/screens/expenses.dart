import 'package:finale_project/providers/expense_provider.dart';
import 'package:finale_project/providers/friends_provider.dart';
import 'package:finale_project/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/static_data.dart';
import '../widgets/box_decoration.dart';
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
        final transactions = allExpenses.take(expensesToLoad).toList();

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
                            child: transactions.isEmpty
                                ? const Center(
                                    child: Text(
                                        'No expenses yet',
                                        style: TextStyle(fontSize: 16, color: Colors.grey)
                                    ))
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: transactions.length,
                                    itemBuilder: (context, index) {
                                        final expense = transactions[index];
                                        final friend = friendsProvider.getFriendById(expense.payerId);
                                        final payerName = friend?.name ?? 'N/A';
                                        final avatarPath = friend?.avatar ?? AvatarFilenames.avatars.first;

                                        return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            child: Container(
                                                decoration: getBoxDecoration(settingsProvider.isDarkMode),
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage: AssetImage(avatarPath)
                                                            ),
                                                            const SizedBox(width: 15),
                                                            Expanded(
                                                                child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Text(
                                                                            payerName,
                                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1
                                                                        ),
                                                                        Text(
                                                                            'Paid: ${expense.amount.toStringAsFixed(2)} ${settingsProvider.currency}',
                                                                            style: const TextStyle(color: Colors.grey, fontSize: 14)
                                                                        ),
                                                                        Text(
                                                                            expense.description,
                                                                            style: TextStyle(color: Colors.grey, fontSize: 12)
                                                                        )
                                                                    ]
                                                                )
                                                            ),
                                                            Column(
                                                                children: [
                                                                    Text(
                                                                        '${expense.participantShares.length} Participants',
                                                                        style: const TextStyle(fontSize: 13)
                                                                    ),
                                                                    Row(
                                                                        children: [
                                                                            IconButton(
                                                                                icon: const Icon(Icons.edit),
                                                                                onPressed: () {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (_) => CreateEditExpenseScreen(
                                                                                                expenseToEdit: expense,
                                                                                                groupId: widget.groupId
                                                                                            )
                                                                                        )
                                                                                    );
                                                                                }),
                                                                            IconButton(
                                                                                icon: const Icon(Icons.delete),
                                                                                onPressed: () {
                                                                                    expensesProvider.deleteExpense(expense.id);
                                                                                })
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        );
                                    }
                                )
                        ),
                        LoadButtonBar(
                            loadMoreLabel: "Load More Expenses",
                            canLoadMore: transactions.length < allExpenses.length,
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
                                    MaterialPageRoute(builder: (_) => CreateEditExpenseScreen(groupId: widget.groupId))
                                );
                            }
                        ),
                        const SizedBox(height: 15)
                    ]
                )
        );
    }
}

