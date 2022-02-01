import '../Common/importer.dart';

class ProviderGroup with ChangeNotifier {
  List<GroupStore> _groupList = [];
  List<GroupStore> get groupList => _groupList;

  // SharedPreferences に登録されている情報を保持
  int? _selectedId = 0;
  int? get selectedId => _selectedId;
  String _selectedTitle = "";
  String get selectedTitle => _selectedTitle;

  ///
  /// グループリストの初期処理
  ///
  Future<void> initializeList() async {
    _groupList = await GroupController.getGroup();
    if (_groupList.length == 0) {
      // デフォルトのグループ（id=0）を登録する
      var _store = GroupStore(
        id: 0,
        title: "マイリスト",
        defualtKbn: "1",
      );
      await GroupController.insertGroup(_store);
      _groupList = await GroupController.getGroup();
    }
    notifyListeners();
  }

  ///
  /// SharedPreferences に登録されているリスト名を取得
  ///
  Future<void> getSelectedInfo() async {
    var prefs = await SharedPreferences.getInstance();
    var selectedId = (prefs.getInt('selectedId') ?? 0);
    List<GroupStore> list = await GroupController.getGroupSelect(selectedId);
    // 1件しか取得しないけどforでループしておく
    for (var i = 0; i < list.length; i++) {
      _selectedId = list[i].id;
      _selectedTitle = list[i].title;
      break;
    }
    notifyListeners();
  }

  ///
  /// 1レコード削除
  ///
  Future<void> delete(int? id) async {
    GroupController.deleteGroup(id!);
  }

  // ID
  int _id = 0;
  get id => _id;

  // タイトル入力内容
  final _titleController = TextEditingController();
  get titleController => _titleController;

  // デフォルト区分 追加登録するリストは"1"
  final _defualtKbnController = TextEditingController();
  get defualtController => _defualtKbnController;

  // 各Controllerのクリア
  void clearItems() {
    _id = 0;
    _titleController.clear();
    _defualtKbnController.clear();
  }
}
