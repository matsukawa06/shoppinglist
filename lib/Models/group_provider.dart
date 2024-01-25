import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppinglist/common/common_const.dart';
import 'package:shoppinglist/common/common_util.dart';
import '../presentation/controllers/group_controller.dart';
import '../presentation/controllers/todo_controller.dart';
import 'package:shoppinglist/models/group_store.dart';

final groupProvider = ChangeNotifierProvider<GroupProvider>(
  (ref) => GroupProvider(),
);

class GroupProvider with ChangeNotifier {
  List<GroupStore> groupList = [];
  // タイトル入力内容
  final titleController = TextEditingController();
  // グループカラー
  Color primarySwatch = Colors.blue;
  // pickerで選択中のカラー
  Color pickerColor = Colors.blue;

  Color fontColor = Colors.white;

  ///
  /// グループリストの初期処理
  ///
  Future<void> initializeList() async {
    groupList = await GroupController.getGroup();
    if (groupList.isEmpty) {
      // デフォルトのグループ（id=0）を登録する
      var _store = GroupStore(
        id: defualtGroupId,
        title: "マイリスト",
        color: Colors.blue.toString(),
      );
      await GroupController.insertGroup(_store);
      groupList = await GroupController.getGroup();
      // 選択中のグループリストIDを更新
      var prefs = await SharedPreferences.getInstance();
      prefs.setInt(keySelectId, defualtGroupId);
    }
    notifyListeners();
  }

  // SharedPreferences に登録されている情報を保持
  int? selectedId = defualtGroupId;
  String selectedTitle = "";
  // Color groupColor = defualtGroupColor;

  ///
  /// SharedPreferences に登録されているリスト名を取得
  ///
  Future<void> getSelectedInfo() async {
    var prefs = await SharedPreferences.getInstance();
    var prefsSelectedId = (prefs.getInt(keySelectId) ?? defualtGroupId);
    List<GroupStore> list =
        await GroupController.getGroupSelect(prefsSelectedId);
    // 1件しか取得しないけどforでループしておく
    for (var i = 0; i < list.length;) {
      selectedId = list[i].id;
      selectedTitle = list[i].title;
      primarySwatch = stringToColor(list[i].color);
      changeFontColor(primarySwatch);
      // if (list[i].color == '') {
      //   primarySwatch = Colors.blue;
      //   changeFontColor(primarySwatch);
      // } else {
      //   String valueString = list[i].color.split('(0x')[1].split(')')[0];
      //   primarySwatch = Color(int.parse(valueString, radix: 16));
      //   changeFontColor(primarySwatch);
      // }
      break;
    }
    notifyListeners();
  }

  ///
  /// 1レコード削除
  ///
  Future<void> delete(int? id) async {
    GroupController.deleteGroup(id!);
    TodoController.deleteTodoGroup(id);
  }

  ///
  /// 全件削除
  ///
  Future<void> deleteAll() async {
    GroupController.deleteAll();
  }

  // 各Controllerの初期化
  void initTitleController(String title) {
    titleController.text = title;
    pickerColor = primarySwatch;
  }

  // 各Controllerのクリア
  void clearItems() {
    titleController.clear();
    pickerColor = Colors.blue;
  }

  // グループカラーの設定
  changeColor(Color _color) {
    pickerColor = _color;
    changeFontColor(_color);
    notifyListeners();
  }

  // フォントカラーの設定
  changeFontColor(Color _color) {
    switch (_color.value) {
      case 4278238420:
      case 4278430196:
      case 4287349578:
      case 4288585374:
      case 4291681337:
      case 4294940672:
      case 4294951175:
      case 4294961979:
        fontColor = Colors.black;
        break;
      default:
        fontColor = Colors.white;
    }
  }
}
