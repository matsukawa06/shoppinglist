class TodoStore {
  final int? id;
  final String title;
  final String memo;
  final int price;
  final int release;
  final DateTime releaseDay;
  final int isSum;
  final int konyuZumi;
  final int? sortNo;
  final int isDelete;
  final DateTime deleteDay;
  final int? groupId;
  final DateTime konyuDay;

  TodoStore(
      {this.id,
      required this.title,
      required this.memo,
      required this.price,
      required this.release,
      required this.releaseDay,
      required this.isSum,
      required this.konyuZumi,
      required this.sortNo,
      required this.isDelete,
      required this.deleteDay,
      required this.groupId,
      required this.konyuDay});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'price': price,
      'release': release,
      'releaseDay': releaseDay.toUtc().toIso8601String(),
      'isSum': isSum,
      'konyuZumi': konyuZumi,
      'sortNo': sortNo,
      'isDelete': isDelete,
      'deleteDay': deleteDay.toUtc().toIso8601String(),
      'groupId': groupId,
      'konyuDay': konyuDay.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, memo: $memo, price: $price}';
  }
}
