class Friend {
    final String id;
    final String avatar;
    final String name;
    final String relation;
    final String email;
    final bool isHighlighted;

    Friend({
        required this.id,
        required this.avatar,
        required this.name,
        required this.relation,
        required this.email,
        this.isHighlighted = false
    });

    Friend copyWith({String? id, String? avatar, String? name, String? relation, String? email, bool? isHighlighted}) {
        return Friend(
            id: id ?? this.id,
            avatar: avatar ?? this.avatar,
            name: name ?? this.name,
            relation: relation ?? this.relation,
            email: email ?? this.email,
            isHighlighted: isHighlighted ?? this.isHighlighted
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'avatar': avatar,
            'name': name,
            'relation': relation,
            'email': email,
            'isHighlighted': isHighlighted
        };
    }

    factory Friend.fromMap(String id, Map<String, dynamic> map) {
        return Friend(
            id: id,
            avatar: map['avatar'] ?? '',
            name: map['name'] ?? '',
            relation: map['relation'] ?? '',
            email: map['email'] ?? '',
            isHighlighted: map['isHighlighted'] ?? false
        );
    }
}
