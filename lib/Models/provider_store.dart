import 'package:flutter/material.dart';
import '../Models/todo_store.dart';
import '../Cotrollers/todo_controller.dart';
import '../../Common/common_util.dart';

// ChangeNotifierを継承すると変更可能なデータを渡せる
class ProviderStore with ChangeNotifier {
  List<TodoStore> _todoList = [];
  List<TodoStore> get todoList => _todoList;

  Future<void> initializeList() async {
    _todoList = await TodoController.getTodos(2);
    notifyListeners();
  }

  Future<void> delete(int? id) async {
    TodoController.deleteTodo(id!);
  }

  Future<void> updateSortNo(int? id, int sortNo) async {
    TodoController.updateSotrNo(id!, sortNo);
    notifyListeners();
  }

  Future<void> updateIsSum(int? id, bool value) async {
    TodoController.updateReleaseDay(id!, value);
    notifyListeners();
  }

  Future<void> updateKonyuZumi(int? id, bool value) async {
    TodoController.updateKonyuZumi(id!, value);
    notifyListeners();
  }

  // 明細を選択した時の情報保持
  void setRowInfo(TodoStore todo) {
    _id = todo.id!;
    _titleController.text = todo.title;
    _memoController.text = todo.memo;
    _priceController.text = todo.price.toString();
    _switchReleaseDay = intToBool(todo.release);
    _releaseDay = todo.releaseDay;
    _switchIsSum = intToBool(todo.isSum);
    _switchKonyuZumi = intToBool(todo.konyuZumi);
    _sortNo = todo.sortNo!;
    if (_switchReleaseDay == true) {
      _labelDate = dateToString(todo.releaseDay);
    }
  }

  // 各Controllerのクリア
  void clearItems() {
    _id = 0;
    _titleController.clear();
    _memoController.clear();
    _priceController.clear();
    _switchReleaseDay = false;
    _releaseDay = DateTime.now();
    _switchIsSum = false;
    _switchKonyuZumi = false;
    _sortNo = 0;
  }

  // ID
  int _id = 0;
  get id => _id;

  // タイトル入力内容
  final _titleController = TextEditingController();
  get titleController => _titleController;

  // メモ入力内容
  final _memoController = TextEditingController();
  get memoController => _memoController;

  // 価格
  final _priceController = TextEditingController();
  get priceController => _priceController;

  // 発売日選択チェックの状態
  var _switchReleaseDay = false;
  get switchReleaseDay => _switchReleaseDay;

  // 発売日
  DateTime _releaseDay = DateTime.now();
  get releaseDay => _releaseDay;

  // 金額計算対象チェックの状態
  var _switchIsSum = false;
  get switchIsSum => _switchIsSum;

  // 購入済みチェックの状態
  var _switchKonyuZumi = false;
  get switchKonyuZumi => _switchKonyuZumi;

  // 並び順
  int _sortNo = 0;
  get sortNo => _sortNo;

  var _labelDate = '日付を選択してください';
  get labelDate => _labelDate;

  void changeRelease(bool value) {
    _switchReleaseDay = value;
    _labelDate = '日付を選択してください';
    notifyListeners();
  }

  void changeIsSum(bool value) {
    _switchIsSum = value;
    notifyListeners();
  }

  void changeKonyuZumi(bool value) {
    _switchKonyuZumi = value;
    notifyListeners();
  }

  void changeReleaseDay(DateTime value) {
    _releaseDay = value;
    _labelDate = dateToString(value);
    notifyListeners();
  }
}
