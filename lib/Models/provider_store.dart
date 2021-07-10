import 'package:flutter/material.dart';
import '../Models/todo_store.dart';
import '../Cotrollers/todo_controller.dart';
import '../../Common/common_util.dart';

// ChangeNotifierを継承すると変更可能なデータを渡せる
class ProviderStore with ChangeNotifier {
  List<TodoStore> _todoList = [];
  List<TodoStore> get todoList => _todoList;

  Future<void> initializeList() async {
    _todoList = await TodoController.getAllTodos();
    notifyListeners();
  }

  Future<void> delete(int? id) async {
    TodoController.deleteTodo(id!);
  }

  // 明細を選択した時の情報保持
  void setRowInfo(TodoStore todo) {
    _id = todo.id!;
    _titleController.text = todo.title;
    _memoController.text = todo.memo;
    _priceController.text = todo.price.toString();
    _switchReleaseDay = intToBool(todo.release);
    _switchIsSum = intToBool(todo.isSum);
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

  // 金額計算対象チェックの状態
  var _switchIsSum = false;
  get switchIsSum => _switchIsSum;

  // 購入済みチェックの状態
  var _switchKonyuZumi = false;
  get switchKonyuZumi => _switchKonyuZumi;

  var _labelDate = '日付を選択してください';
  get labelDate => _labelDate;

  void changeReleaseDay(bool value) {
    _switchReleaseDay = value;
  }

  void changeIsSum(bool value) {
    _switchIsSum = value;
  }

  void changeKonyuZumi(bool value) {
    _switchKonyuZumi = value;
  }

  void changeLabelDate(String value) {
    _labelDate = value;
  }

  // 各Controllerのクリア
  void clearControllers() {
    _titleController.clear();
    _memoController.clear();
    _priceController.clear();
    _switchReleaseDay = false;
    _switchIsSum = false;
    _switchKonyuZumi = false;
  }
}
