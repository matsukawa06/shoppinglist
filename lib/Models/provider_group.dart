import '../Common/importer.dart';

class ProviderGroup with ChangeNotifier {
  List<GroupStore> groupList = [];

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
  MaterialColor groupColor = defualtGroupColor;

  ///
  /// SharedPreferences に登録されているリスト名を取得
  ///
  Future<void> getSelectedInfo() async {
    var prefs = await SharedPreferences.getInstance();
    var prefsSelectedId = (prefs.getInt(keySelectId) ?? defualtGroupId);
    List<GroupStore> list =
        await GroupController.getGroupSelect(prefsSelectedId);
    // 1件しか取得しないけどforでループしておく
    for (var i = 0; i < list.length; i++) {
      selectedId = list[i].id;
      selectedTitle = list[i].title;
      groupColor = Colors.blue; // ※とりあえずブルー固定
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

  // タイトル入力内容
  final titleController = TextEditingController();

  void initTitleController(String title) {
    titleController.text = title;
  }

  // 各Controllerのクリア
  void clearItems() {
    titleController.clear();
  }

  // グループカラーの設定

}
