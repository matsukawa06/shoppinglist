class GroupStore {
  final int? id;
  final String title;
  final String defualtKbn;

  GroupStore({this.id, required this.title, required this.defualtKbn});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'defualtKbn': defualtKbn,
    };
  }

  @override
  String toString() {
    return 'Group{id: $id, title: $title, defualtKbn: $defualtKbn}';
  }
}
