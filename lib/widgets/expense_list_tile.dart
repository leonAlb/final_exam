
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../providers/friends_provider.dart';
import '../providers/settings_provider.dart';
import '../screens/create_edit_expense.dart';
import '../utils/static_data.dart';
import 'box_decoration.dart';

class ExpenseTile extends StatelessWidget {
    final Expense expense;
    final String groupId;
    final SettingsProvider settingsProvider;
    final FriendsProvider friendsProvider;
    final ExpenseProvider expensesProvider;

    const ExpenseTile({
        super.key,
        required this.expense,
        required this.groupId,
        required this.settingsProvider,
        required this.friendsProvider,
        required this.expensesProvider
    });

    @override
    Widget build(BuildContext context) {
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
                            CircleAvatar(radius: 20, backgroundImage: AssetImage(avatarPath)),
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
                                            style: const TextStyle(color: Colors.grey, fontSize: 12)
                                        )
                                    ]
                                )
                            ),
                            Column(
                                children: [
                                    Text(
                                        '${expense.participantShares.length} '
                                        '${expense.participantShares.length == 1 ? "Participant" : "Participants"}',
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
                                                                groupId: groupId
                                                            )
                                                        )
                                                    );
                                                }
                                            ),
                                            IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                    expensesProvider.deleteExpense(expense.id);
                                                }
                                            )
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
}