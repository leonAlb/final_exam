import 'package:finale_project/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../models/friend.dart';
import '../models/group.dart';
import '../providers/expense_provider.dart';
import '../providers/friends_provider.dart';
import '../providers/groups_provider.dart';
import '../providers/settings_provider.dart';

class CreateEditExpenseScreen extends StatefulWidget {
    final Expense? expenseToEdit;
    final String groupId;

    const CreateEditExpenseScreen({
        super.key,
        this.expenseToEdit,
        required this.groupId
    });

    @override
    State<CreateEditExpenseScreen> createState() => _CreateEditExpenseScreenState();
}

enum InputMode { slider, text }

class _CreateEditExpenseScreenState extends State<CreateEditExpenseScreen> {
    InputMode _inputMode = InputMode.slider;

    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();

    List<TextEditingController> _participantControllers = [];

    List<double> participantPercentages = [];
    List<Friend> groupMembers = [];
    bool isLoading = true;
    Group? group;

    int? _payerIndex;

    bool _isAdjusting = false;

    @override
    void initState() {
        super.initState();
        _loadGroupMembers();
    }

    @override
    void dispose() {
        _descriptionController.dispose();
        _amountController.dispose();

        for (final controller in _participantControllers) {
            controller.dispose();
        }

        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final settingsProvider = Provider.of<SettingsProvider>(context);
        final isDark = settingsProvider.isDarkMode;
        final theme = settingsProvider.colorTheme;
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.expenseToEdit == null ? 'Create Expense' : 'Edit Expense')
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        children: [
                            // Beschreibung & Betrag
                            TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                    labelText: 'Expense Description',
                                    border: OutlineInputBorder()
                                )
                            ),
                            const SizedBox(height: 10),
                            TextField(
                                controller: _amountController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                    labelText: 'Amount Paid',
                                    prefixText: settingsProvider.currency,
                                    border: const OutlineInputBorder()
                                )
                            ),
                            const SizedBox(height: 10),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    ElevatedButton(
                                        onPressed: () => setState(() => _inputMode = InputMode.slider),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: _inputMode == InputMode.slider ? getColor(theme, isDark) : Colors.grey
                                        ),
                                        child: const Text('Slider Mode')
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () => setState(() => _inputMode = InputMode.text),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: _inputMode == InputMode.text ? getColor(theme, isDark) : Colors.grey
                                        ),
                                        child: const Text('Text Mode')
                                    )
                                ]
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                                child: Column(
                                    children: [
                                        Expanded(
                                            child: ListView.builder(
                                                itemCount: groupMembers.length,
                                                itemBuilder: (context, index) {
                                                    final member = groupMembers[index];
                                                    if (_inputMode == InputMode.slider) {
                                                        double percent = participantPercentages[index];
                                                        double sliderValue = percent * 100;
                                                        return _buildSliderItem(member, index, sliderValue);
                                                    } else {
                                                        return _buildTextItem(member, index);
                                                    }
                                                }
                                            )
                                        ),
                                        if (_inputMode == InputMode.text)ElevatedButton(
                                            onPressed: _applyTextModeValues,
                                            child: const Text("Apply")
                                        ),
                                        SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                                onPressed: _saveExpense,
                                                icon: const Icon(Icons.save),
                                                label: const Text("Save Expense")
                                            )
                                        ),
                                        SizedBox(height: 15)
                                    ]
                                )
                            )
                        ]
                    )
                )
        );
    }

    Future<void> _loadGroupMembers() async {
        final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
        final friendsProvider = Provider.of<FriendsProvider>(context, listen: false);

        if (groupsProvider.groups.isEmpty) {
            await groupsProvider.loadGroups();
        }
        final loadGroup = groupsProvider.getGroupById(widget.groupId);

        if (friendsProvider.friends.isEmpty) {
            await friendsProvider.loadFriends();
        }
        final members = friendsProvider.friends.where((friend) => loadGroup!.memberIds.contains(friend.id)).toList();

        List<double> percentages = [];

        if (widget.expenseToEdit != null) {
            final shares = widget.expenseToEdit!.participantShares;
            final totalAmount = widget.expenseToEdit!.amount;
            for (final member in members) {
                final shareAmount = shares[member.id] ?? 0.0;
                final percent = totalAmount > 0 ? shareAmount / totalAmount : 0.0;
                percentages.add(percent);
            }
        } else {
            int count = members.length;
            if (count == 0) {
                percentages = [];
            } else {
                List<double> rawPercentages = [];
                double total = 0;

                for (int i = 0; i < count - 1; i++) {
                    double raw = 100.0 / count;
                    double rounded = double.parse(raw.toStringAsFixed(1));
                    rawPercentages.add(rounded);
                    total += rounded;
                }

                double last = double.parse((100.0 - total).toStringAsFixed(1));
                rawPercentages.add(last);

                percentages = rawPercentages.map((p) => p / 100.0).toList();

            }
        }

        setState(() {
                group = loadGroup;
                groupMembers = members;
                participantPercentages = percentages;
                isLoading = false;

                _descriptionController.text = widget.expenseToEdit?.description ?? '';
                _amountController.text = widget.expenseToEdit?.amount.toString() ?? '';

                _participantControllers = groupMembers.map((_) => TextEditingController()).toList();

                for (int i = 0; i < groupMembers.length; i++) {
                    _participantControllers[i].text = (participantPercentages[i] * 100).toStringAsFixed(1);
                }

                _payerIndex = groupMembers.indexWhere((member) => member.id == widget.expenseToEdit?.payerId);
                if (_payerIndex == -1) {
                  _payerIndex = 0;
                }
            });
    }

    // Enables the determination of who is paying
    Widget _buildAvatar(Friend member, int index) {
        bool isSelected = _payerIndex == index;

        return GestureDetector(
            onTap: () {
                setState(() {
                        _payerIndex = index;
                    });
            },
            child: Stack(
                alignment: Alignment.center,
                children: [
                    CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(member.avatar)
                    ),
                    if (isSelected)
                    Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            shape: BoxShape.circle
                        ),
                        child: Center(
                            child: Icon(
                                Icons.attach_money,
                                color: Color.fromRGBO(0, 0, 0, 0.8),
                                size: 24
                            )

                        )
                    )
                ]
            )
        );
    }

    Widget _buildSliderItem(Friend member, int index, double sliderValue) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
                children: [
                    _buildAvatar(member, index),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                    children: [
                                        Expanded(child:
                                            Slider(
                                                value: sliderValue,
                                                min: 0,
                                                max: 100,
                                                divisions: 100,
                                                label: '${sliderValue.toStringAsFixed(1)}%',
                                                onChanged: (newValue) {
                                                    _adjustPercentages(index, newValue / 100);
                                                }
                                            )
                                        )
                                        ,
                                        Text('${sliderValue.toStringAsFixed(1)}%')
                                    ]
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

    Widget _buildTextItem(Friend member, int index) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    _buildAvatar(member, index),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text(
                                    member.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold)
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                    height: 48,
                                    child: TextField(
                                        textAlign: TextAlign.center,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(
                                            suffixText: '%',
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)
                                        ),
                                        controller: _participantControllers[index],
                                        onChanged: (value) {
                                            final parsed = double.tryParse(value);
                                            if (parsed != null) {
                                                double newValue = parsed.clamp(0, 100);
                                                _adjustPercentages(index, newValue / 100);
                                            }
                                        },
                                        onEditingComplete: () {
                                            final value = _participantControllers[index].text;
                                            final parsed = double.tryParse(value);
                                            if (parsed != null) {
                                                double rounded = double.parse(parsed.clamp(0, 100).toStringAsFixed(1));
                                                _participantControllers[index].text = rounded.toStringAsFixed(1);
                                                _participantControllers[index].selection = TextSelection.fromPosition(
                                                    TextPosition(offset: _participantControllers[index].text.length)
                                                );
                                            }
                                        }
                                    )
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

    void _adjustPercentages(int changedIndex, double newPercent) {
        if (_isAdjusting) return;
        _isAdjusting = true;

        newPercent = newPercent.clamp(0.0, 1.0);

        participantPercentages[changedIndex] = newPercent;

        double sumOthers = 0;
        for (int i = 0; i < participantPercentages.length; i++) {
            if (i != changedIndex) sumOthers += participantPercentages[i];
        }

        double remainder = 1.0 - newPercent;

        if (sumOthers == 0) {
            for (int i = 0; i < participantPercentages.length; i++) {
                if (i != changedIndex) participantPercentages[i] = 0;
            }
        } else {
            for (int i = 0; i < participantPercentages.length; i++) {
                if (i != changedIndex) {
                    participantPercentages[i] = participantPercentages[i] / sumOthers * remainder;
                }
            }
        }

        double total = participantPercentages.reduce((a, b) => a + b);
        double diff = 1.0 - total;

        if (diff.abs() > 0.0001) {
            int lastIndex = participantPercentages.length - 1;
            if (lastIndex == changedIndex) lastIndex--;
            participantPercentages[lastIndex] = (participantPercentages[lastIndex] + diff).clamp(0.0, 1.0);
        }

        setState(() {});
        _isAdjusting = false;
    }

    void _applyTextModeValues() {
        double sum = 0.0;
        List<double> newPercentages = [];

        for (final controller in _participantControllers) {
            final val = double.tryParse(controller.text);
            if (val == null || val < 0 || val > 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid percentages between 0 and 100."))
                );
                return;
            }
            newPercentages.add(val / 100);
            sum += val;
        }

        if ((sum - 100).abs() > 0.01) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Sum of percentages must be 100%. Current sum: ${sum.toStringAsFixed(1)}%"))
            );
            return;
        }

        setState(() {
                participantPercentages = newPercentages;
            });
    }

    Future<void> _saveExpense() async {
        final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
        final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);

        final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
        if (amount == null || amount <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a valid amount."))
            );
            return;
        }

        final description = _descriptionController.text.trim();
        if (description.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a description."))
            );
            return;
        }

        final Map<String, double> participantShares = {};
        for (int i = 0; i < groupMembers.length; i++) {
            final member = groupMembers[i];
            final share = double.parse((participantPercentages[i] * amount).toStringAsFixed(2));
            if (share > 0) {
                participantShares[member.id] = share;
            }
        }

        final payerIndex = _payerIndex;
        if (payerIndex == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a payer."))
            );
            return;
        }

        final payerId = groupMembers[payerIndex].id;

        final newExpense = Expense(
            id: widget.expenseToEdit?.id ?? '',
            description: description,
            amount: amount,
            payerId: payerId,
            participantShares: participantShares,
            groupId: widget.groupId
        );

        if (widget.expenseToEdit == null) {
            await expenseProvider.addExpense(newExpense);
        } else {
            await expenseProvider.updateExpense(newExpense);
        }

        if (!group!.expenseIds.contains(newExpense.id)) {
            final updatedExpenseIds = List<String>.from(group!.expenseIds)..add(newExpense.id);
            final updatedGroup = group!.copyWith(expenseIds: updatedExpenseIds);
            await groupsProvider.updateGroup(updatedGroup);
        }

        Navigator.of(context).pop();
    }

}
