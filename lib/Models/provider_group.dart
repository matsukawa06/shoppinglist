import '../Common/importer.dart';

class ProviderGroup with ChangeNotifier {
  List<GroupStore> _groupList = [];
  List<GroupStore> get groupList => _groupList;

  ///
  /// グループリストの初期処理
  ///
  Future<void> initializeList() async {
    _groupList = await GroupController.getGroup();
    if (_groupList.isEmpty) {
      // デフォルトのグループ（id=0）を登録する
      var _store = GroupStore(
        id: defualtGroupId,
        title: "マイリスト",
      );
      await GroupController.insertGroup(_store);
      _groupList = await GroupController.getGroup();
      // 選択中のグループリストIDを更新
      var prefs = await SharedPreferences.getInstance();
      prefs.setInt(keySelectId, defualtGroupId);
    }
    notifyListeners();
  }

  // SharedPreferences に登録されている情報を保持
  int? _selectedId = defualtGroupId;
  int? get selectedId => _selectedId;
  String _selectedTitle = "";
  String get selectedTitle => _selectedTitle;
  MaterialColor _groupColor = defualtGroupColor;
  MaterialColor get groupColor => _groupColor;

  ///
  /// SharedPreferences に登録されているリスト名を取得
  ///
  Future<void> getSelectedInfo() async {
    var prefs = await SharedPreferences.getInstance();
    var selectedId = (prefs.getInt(keySelectId) ?? defualtGroupId);
    List<GroupStore> list = await GroupController.getGroupSelect(selectedId);
    // 1件しか取得しないけどforでループしておく
    for (var i = 0; i < list.length; i++) {
      _selectedId = list[i].id;
      _selectedTitle = list[i].title;
      _groupColor = Colors.blue; // ※とりあえずブルー固定
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
  final _titleController = TextEditingController();
  get titleController => _titleController;

  void initTitleController(String title) {
    _titleController.text = title;
  }

  // 各Controllerのクリア
  void clearItems() {
    _titleController.clear();
  }

  // グループカラーの設定

}
