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

  TodoStore(
      {this.id,
      required this.title,
      required this.memo,
      required this.price,
      required this.release,
      required this.releaseDay,
      required this.isSum,
      required this.konyuZumi,
      required this.sortNo});

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
    };
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, memo: $memo, price: $price}';
  }
}
