class Expense {
    final String id;
    final String description;
    final double amount;
    final String payerId;
    final List<String> participantIds;
    final String groupId;

    Expense({
        required this.id,
        required this.description,
        required this.amount,
        required this.payerId,
        required this.participantIds,
        required this.groupId
    });

    Expense copyWith({String? id,
        String? description,
        double? amount,
        String? payerId,
        List<String>? participantIds,
        String? groupId
    }) {
        return Expense(
            id: id ?? this.id,
            description: description ?? this.description,
            amount: amount ?? this.amount,
            payerId: payerId ?? this.payerId,
            participantIds: participantIds ?? List.from(this.participantIds),
            groupId: groupId ?? this.groupId
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'description': description,
            'amount': amount,
            'payerId': payerId,
            'participantIds': participantIds,
            'groupId': groupId
        };
    }

    factory Expense.fromMap(String id, Map<String, dynamic> map) {
        return Expense(
            id: id,
            description: map['description'] ?? '',
            amount: (map['amount'] ?? 0).toDouble(),
            payerId: map['payerId'] ?? '',
            participantIds: List<String>.from(map['participantIds'] ?? []),
            groupId: map['groupId'] ?? ''
        );
    }
}
