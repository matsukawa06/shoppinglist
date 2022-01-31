import '../Common/importer.dart';

class ProviderGroup with ChangeNotifier {
  List<GroupStore> _groupList = [];
  List<GroupStore> get groupList => _groupList;

  String _selectedTitle = "";
  String get selectedTitle => _selectedTitle;

  String _selectListTitle = "";
  String get selectListTitle => _selectListTitle;

  Future<void> initializeList() async {
    _groupList = await GroupController.getGroup();
    if (_groupList.length == 0) {
      // デフォルトのグループ（id=0）を登録する
      var _store = GroupStore(
        title: "マイリスト",
        defualtKbn: "1",
      );
      await GroupController.insertGroup(_store);
      _groupList = await GroupController.getGroup();
    }
    notifyListeners();
  }

  ///
  /// select中のデータを取得
  ///
  Future<void> getSelectedTitle() async {
    var prefs = await SharedPreferences.getInstance();
    var selectedId = prefs.getInt('selectedId');
    List<GroupStore> list = await GroupController.getGroupSelect(selectedId);
    // 1件しか取得しないけどforでループしておく
    for (var i = 0; i < list.length; i++) {
      _selectedTitle = list[i].title;
      _selectListTitle = list[i].title;
      break;
    }
    notifyListeners();
  }

  ///
  /// 指定したidのデータを取得
  ///
  Future<void> getSelectedIdTitle(int? id) async {
    List<GroupStore> list = await GroupController.getGroup();
    for (var i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        _selectListTitle = list[i].title;
        break;
      }
    }
    notifyListeners();
  }

  // 1レコード削除
  Future<void> delete(int? id) async {
    GroupController.deleteGroup(id!);
  }

  // グループを選択した時の情報保持
  void setGroupInfo(GroupStore store) {
    _id = store.id!;
    _titleController.text = store.title;
    _defualtKbnController.text = store.defualtKbn;

    _selectedGroupId = store.id!;
    _selectListTitle = store.title;
  }

  // 各Controllerのクリア
  void clearItems() {
    _id = 0;
    _titleController.clear();
    _defualtKbnController.clear();
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

  int _selectedGroupId = 0;
  get selectedGroupId => _selectedGroupId;

  void changeSelectedGroupId(int? value) {
    _selectedGroupId = value!;
    notifyListeners();
  }

  // final _selectedGroupTitle = TextEditingController();
  // get selectedGroupTitle => _selectedGroupTitle;
}
