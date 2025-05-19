class Expense {
    final String id;
    final String description;
    final double amount;
    final String payerId;
    final Map<String, double> participantShares;
    final String groupId;

    Expense({
        required this.id,
        required this.description,
        required this.amount,
        required this.payerId,
        required this.participantShares,
        required this.groupId,
    });

    Expense copyWith({
        String? id,
        String? description,
        double? amount,
        String? payerId,
        Map<String, double>? participantShares,
        String? groupId,
    }) {
        return Expense(
            id: id ?? this.id,
            description: description ?? this.description,
            amount: amount ?? this.amount,
            payerId: payerId ?? this.payerId,
            participantShares: participantShares ?? this.participantShares,
            groupId: groupId ?? this.groupId,
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'description': description,
            'amount': amount,
            'payerId': payerId,
            'participantShares': participantShares,
            'groupId': groupId,
        };
    }

    factory Expense.fromMap(String id, Map<String, dynamic> map) {
        return Expense(
            id: id,
            description: map['description'] ?? '',
            amount: (map['amount'] ?? 0).toDouble(),
            payerId: map['payerId'] ?? '',
            participantShares: Map<String, double>.from(
                (map['participantShares'] ?? {}).map((key, value) => MapEntry(key, (value as num).toDouble())),
            ),
            groupId: map['groupId'] ?? '',
        );
    }
}
