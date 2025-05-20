import '../models/expense.dart';

Future<Map<String, Map<String, double>>> calculateBalance(List<Expense> expenses) async {
  final Map<String, double> netBalances = {};

  // Every expense builds up either "Credit" or "Debt" for each member in the group
  for (final expense in expenses) {
    final payer = expense.payerId;
    netBalances[payer] = (netBalances[payer] ?? 0) + expense.amount;
    expense.participantShares.forEach((participantId, shareAmount) {
      netBalances[participantId] = (netBalances[participantId] ?? 0) - shareAmount;
    });
  }
  final debtors = netBalances.entries.where((e) => e.value < 0).toList();
  final creditors = netBalances.entries.where((e) => e.value > 0).toList();
  final Map<String, Map<String, double>> debts = {};

  // Persons with "Debt" pay ANY person with "Credit" all the money they owe until that credit is satisfied
  int i = 0, j = 0;
  while (i < debtors.length && j < creditors.length) {
    final debtorId = debtors[i].key;
    var debtorAmount = -debtors[i].value;
    final creditorId = creditors[j].key;
    var creditorAmount = creditors[j].value;

    // Determine how much the debtor can pay to the creditor. Either the Credit is completely paid
    // or the person with debt pays all he owes, not necessarily paying the creditor in full
    final payment = debtorAmount < creditorAmount ? debtorAmount : creditorAmount;
    debts.putIfAbsent(debtorId, () => {})[creditorId] = payment;

    // Pays off/Receives the payment that was possible
    debtorAmount -= payment;
    creditorAmount -= payment;

    // If no more debt is left, the next debitor starts paying his debt
    if (debtorAmount == 0) i++;
    else debtors[i] = MapEntry(debtorId, -debtorAmount);

    // If no more credit is left, the next creditor starts receiving
    if (creditorAmount == 0) j++;
    else creditors[j] = MapEntry(creditorId, creditorAmount);
  }

  return debts;
}
