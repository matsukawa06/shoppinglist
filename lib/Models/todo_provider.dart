import '../Common/importer.dart';

// ChangeNotifierを継承すると変更可能なデータを渡せる
class TodoProvider with ChangeNotifier {
  List<TodoStore> todoList = [];
  int totalPrice = 0;
  late TodoStore todoStore;

  Future<void> initializeList() async {
    todoList = await TodoController.getTodos();
    // 金額計算ここでやる
    _sumPrice();
    notifyListeners();
  }

  // 合計金額を計算する
  void _sumPrice() {
    totalPrice = 0;
    todoList.map(
      (TodoStore todo) {
        if (todo.isSum == 1) {
          totalPrice += todo.price;
        }
      },
    ).toList();
  }

  // 1レコード削除
  Future<void> delete(int? id) async {
    TodoController.deleteTodo(id!);
  }

  // 全レコード削除
  Future<void> deleteAll() async {
    TodoController.deleteAll();
  }

  // 購入済区分の更新
  Future<void> updateKonyuZumi(int? id, bool value) async {
    TodoController.updateKonyuZumi(id!, value);
    // notifyListeners();
  }

  // // 削除区分の更新
  // Future<void> updateIsDelete(int? id, bool value) async {
  //   TodoController.updateIsDelete(id!, value);
  //   // notifyListeners();
  // }

  // 明細を選択した時の情報保持
  void setRowInfo(TodoStore todo) {
    id = todo.id!;
    titleController.text = todo.title;
    memoController.text = todo.memo;
    priceController.text = todo.price.toString();
    switchReleaseDay = intToBool(todo.release);
    releaseDay = todo.releaseDay;
    switchIsSum = intToBool(todo.isSum);
    switchKonyuZumi = intToBool(todo.konyuZumi);
    sortNo = todo.sortNo!;
    if (switchReleaseDay == true) {
      labelReleaseDate = dateToString(todo.releaseDay);
    }
    isDelete = intToBool(todo.isDelete);
    deleteDay = todo.deleteDay;
    groupId = todo.groupId!;
    konyuDay = todo.konyuDay;
    if (switchKonyuZumi == true) {
      labelKonyuDate = dateToString(todo.konyuDay);
    }
  }

  // 各Controllerのクリア
  void clearItems() {
    id = 0;
    titleController.clear();
    memoController.clear();
    priceController.clear();
    switchReleaseDay = false;
    releaseDay = DateTime.now();
    switchIsSum = true;
    switchKonyuZumi = false;
    sortNo = 0;
    isDelete = false;
    deleteDay = DateTime.now();
    groupId = 1;
    konyuDay = DateTime.now();
  }

  // ID
  int id = 0;
  // タイトル入力内容
  final titleController = TextEditingController();
  // メモ入力内容
  final memoController = TextEditingController();
  // 価格
  final priceController = TextEditingController();
  // 発売日選択チェックの状態
  var switchReleaseDay = false;
  // 金額計算対象チェックの状態
  var switchIsSum = true;
  // 購入済みチェックの状態
  var switchKonyuZumi = false;
  // 削除区分の状態
  var isDelete = false;
  // 削除日（物理削除する日）
  late var deleteDay = DateTime.now();
  // グループID
  int groupId = 1;
  // 並び順
  int sortNo = 0;
  // 発売日
  DateTime releaseDay = DateTime.now();
  // 発売日の初期ラベル
  var labelReleaseDate = '日付を選択してください';

  void changeRelease(bool value) {
    switchReleaseDay = value;
    labelReleaseDate = '日付を選択してください';
    notifyListeners();
  }

  void changeReleaseDay(DateTime value) {
    releaseDay = value;
    labelReleaseDate = dateToString(value);
    notifyListeners();
  }

  void changeIsSum(bool value) {
    switchIsSum = value;
    notifyListeners();
  }

  // 購入日
  late var konyuDay = DateTime.now();
  // 購入日の初期ラベル
  var labelKonyuDate = '';

  void changeKonyuZumi(bool value) {
    switchKonyuZumi = value;
    konyuDay = DateTime.now();
    labelKonyuDate = dateToString(konyuDay);
    notifyListeners();
  }

  void changeKonyuDay(DateTime value) {
    konyuDay = value;
    labelKonyuDate = dateToString(value);
    notifyListeners();
  }

  /* リストのソート順変更処理 */
  void changeSort(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // 下に移動した場合
      newIndex -= 1;
    }
    final TodoStore todoStore = todoList.removeAt(oldIndex);
    todoList.insert(newIndex, todoStore);

    // リストのソート番号を全件更新
    changeSortAll();
    // 再描画
    notifyListeners();
  }

  /* リストのソート番号を全件更新 */
  void changeSortAll() {
    // リストのソート番号を全件更新
    for (var i = 0; i < todoList.length; i++) {
      if (todoList[i].sortNo != i) {
        // 登録されているソート番号が現在のインデックスと異なる場合更新
        TodoController.updateSotrNo(todoList[i].id!, i);
      }
    }
  }

  /* todoを１件削除 */
  void todoDelete(int? id) {
    // DBから削除
    delete(id);
    // リストのソート番号を全件更新
    changeSortAll();
    // 合計金額再計算
    _sumPrice();
    // 再描画
    notifyListeners();
  }

  /* 計算対象区分の更新 */
  void updateIsSum(TodoStore _todo) {
    TodoController.updateIsSum(
        _todo.id!, intToBool(_todo.isSum) ? false : true);
    initializeList();
  }
}
