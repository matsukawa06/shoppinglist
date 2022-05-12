import 'package:shoppinglist/Views/newlist_page/main.dart';

import '../../../Common/importer.dart';

///
/// メニューリスト
///
class MenuListIcon extends StatelessWidget {
  const MenuListIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_horiz),
      color: context.watch<GroupProvider>().fontColor,
      iconSize: 40,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext contex) {
            return SingleChildScrollView(
              child: Column(
                children: const [
                  // リスト更新
                  ListUpdate(),
                  // リスト削除
                  ListDelete(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

///
/// リスト更新
///
class ListUpdate extends StatelessWidget {
  const ListUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<GroupProvider>();

    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 5),
      height: 60.0,
      child: InkWell(
        child: Row(
          children: const [
            Padding(padding: EdgeInsets.only(left: 15.0)),
            Text(
              'リスト情報を変更する',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        onTap: () {
          // グループリストタイトルを初期化
          store.initTitleController(store.selectedTitle);
          // "push"で更新画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const Main(modeUpdate);
              },
            ),
          ).then(
            (value) async {
              // storeの初期化
              context.read<GroupProvider>().clearItems();
              // タイトルを反映させる
              store.getSelectedInfo();
              // グループリストの再読み込み
              context.read<GroupProvider>().initializeList();
              // // ToDoリストも再読み込みする
              // context.read<ProviderTodo>().initializeList();
              // メニューリストを閉じる
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

///
/// リスト削除
///
class ListDelete extends StatelessWidget {
  const ListDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _sharedProvider = context.read<SharedPreferencesProvider>();
    final _groupProvider = context.read<GroupProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 35),
      height: 70.0,
      child: InkWell(
        child: _delContainer(context),
        onTap: () async {
          if (_groupProvider.selectedId != defualtGroupId) {
            // デフォルトのリストで無ければ、削除処理を行う
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('確認'),
                  content: SizedBox(
                    height: 90.0,
                    child: Column(
                      children: const [
                        Text('リストを削除します。よろしいですか？'),
                        Text(
                          'この操作は取り消しできません。',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('いいえ'),
                      onPressed: () {
                        // ダイアログを閉じる
                        Navigator.of(context).pop(0);
                        // モーダルシートも閉じる
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('はい'),
                      onPressed: () {
                        // グループリストと紐づくTodoを物理削除
                        _groupProvider.delete(_groupProvider.selectedId);
                        // グループリストの再読み込み
                        context.read<GroupProvider>().initializeList();
                        // デフォルトリストを選択中にする
                        _sharedProvider.saveIntValue(
                            keySelectId, defualtGroupId);
                        _sharedProvider.setSelectedGroupId(defualtGroupId);
                        // タイトルを反映させる
                        _groupProvider.getSelectedInfo();
                        // ToDoリストも再読み込みする
                        context.read<TodoProvider>().initializeList();
                        // ダイアログを閉じる
                        Navigator.pop(context);
                        // メニューリストを閉じる
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

///
/// リスト削除用の選択行の見た目
///
Widget _delContainer(BuildContext context) {
  final _groupProvider = context.watch<GroupProvider>();
  final _isDefualt = _groupProvider.selectedId == defualtGroupId ? true : false;

  return Container(
    width: double.infinity,
    alignment: Alignment.topLeft,
    child: ListTile(
      title: Text(
        'リストを削除する',
        style: TextStyle(
          fontSize: 18,
          color: _isDefualt ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(
        _isDefualt ? '\nデフォルトのリストは削除できません' : '',
        style: TextStyle(
          fontSize: 14,
          color: _isDefualt ? Colors.grey : Colors.black,
        ),
      ),
    ),
  );
}
