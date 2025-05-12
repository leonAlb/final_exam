class Group {
    final String id;
    final String name;
    final List<String> memberIds;

    Group({
        required this.id,
        required this.name,
        required this.memberIds
    });

    Group copyWith({String? id, String? name, List<String>? memberIds}) {
        return Group(
            id: id ?? this.id,
            name: name ?? this.name,
            memberIds: memberIds ?? List.from(this.memberIds)
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'name': name,
            'memberIds': memberIds
        };
    }

    factory Group.fromMap(String id, Map<String, dynamic> map) {
        return Group(
            id: id,
            name: map['name'] ?? '',
            memberIds: List<String>.from(map['memberIds'] ?? [])
        );
    }
}
