class GroupStore {
  final int? id;
  final String title;
  final String color;

  GroupStore({this.id, required this.title, required this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'color': color,
    };
  }

  @override
  String toString() {
    return 'Group{id: $id, title: $title, color: $color}';
  }
}
