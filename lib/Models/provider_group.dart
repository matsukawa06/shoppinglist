import '../Common/importer.dart';

class ProviderGroup with ChangeNotifier {
  List<GroupStore> _groupList = [];
  List<GroupStore> get groupList => _groupList;

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

  // 1レコード削除
  Future<void> delete(int? id) async {
    GroupController.deleteGroup(id!);
  }

  // グループを選択した時の情報保持
  void setGroupInfo(GroupStore store) {
    _id = store.id!;
    _titleController.text = store.title;
    _defualtKbnController.text = store.defualtKbn;
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
}
