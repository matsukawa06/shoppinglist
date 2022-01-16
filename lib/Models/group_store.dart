class GroupStore {
  final int? id;
  final String title;

  GroupStore({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  String toString() {
    return 'Group{id: $id, title: $title}';
  }
}
