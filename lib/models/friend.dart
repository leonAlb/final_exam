class Friend {
    final String id;
    final String name;
    final String relation;
    final String avatar;
    final bool isHighlighted;

    Friend({
        required this.id,
        required this.name,
        required this.relation,
        required this.avatar,
        this.isHighlighted = false
    });

    Friend copyWith({String? id, String? name, String? avatar, String? relation, bool? isHighlighted}) {
        return Friend(
            id: id ?? this.id,
            name: name ?? this.name,
            avatar: avatar ?? this.avatar,
            relation: relation ?? this.relation,
            isHighlighted: isHighlighted ?? this.isHighlighted,
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'name': name,
            'relation': relation,
            'avatar': avatar,
            'isHighlighted': isHighlighted,
        };
    }

    factory Friend.fromMap(String id, Map<String, dynamic> map) {
        return Friend(
            id: id,
            name: map['name'] ?? '',
            relation: map['relation'] ?? '',
            avatar: map['avatar'] ?? '',
            isHighlighted: map['isHighlighted'] ?? false,
        );
    }
}
