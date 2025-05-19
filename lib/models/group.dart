class Group {
    final String id;
    final String name;
    final List<String> memberIds;
    final List<String> expenseIds;

    Group({
        required this.id,
        required this.name,
        required this.memberIds,
        List<String>? expenseIds,
    }) : expenseIds = expenseIds ?? [];

    Group copyWith({
        String? id,
        String? name,
        List<String>? memberIds,
        List<String>? expenseIds,
    }) {
        return Group(
            id: id ?? this.id,
            name: name ?? this.name,
            memberIds: memberIds ?? List.from(this.memberIds),
            expenseIds: expenseIds ?? List.from(this.expenseIds),
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'name': name,
            'memberIds': memberIds,
            'expenseIds': expenseIds,
        };
    }

    factory Group.fromMap(String id, Map<String, dynamic> map) {
        return Group(
            id: id,
            name: map['name'] ?? '',
            memberIds: List<String>.from(map['memberIds'] ?? []),
            expenseIds: List<String>.from(map['expenseIds'] ?? []),
        );
    }
}
