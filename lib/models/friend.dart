class Friend {
  final String id;
  final String name;
  final String relation;
  final String avatar;

  Friend({
    required this.id,
    required this.name,
    required this.relation,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relation': relation,
      'avatar': avatar,
    };
  }

  factory Friend.fromMap(String id, Map<String, dynamic> map) {
    return Friend(
      id: id,
      name: map['name'] ?? '',
      relation: map['relation'] ?? '',
      avatar: map['avatar'] ?? '',
    );
  }
}
