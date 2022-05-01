import 'package:shoppinglist/Views/newlist_page/main.dart';

import '../../Common/importer.dart';

///
/// メニューリスト
///
class MenuListIcon extends StatelessWidget {
  const MenuListIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_horiz),
      color: context.watch<ProviderGroup>().fontColor,
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
    final store = context.read<ProviderGroup>();

    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 5),
      height: 60.0,
      child: InkWell(
        child: Row(
          children: const [
            Padding(padding: EdgeInsets.only(left: 15.0)),
            Text(
              "リスト情報を変更する",
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
                return const ListEditPage(modeUpdate);
              },
            ),
          ).then(
            (value) async {
              // storeの初期化
              context.read<ProviderGroup>().clearItems();
              // タイトルを反映させる
              store.getSelectedInfo();
              // グループリストの再読み込み
              context.read<ProviderGroup>().initializeList();
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
    final prvShared = context.read<ProviderSharedPreferences>();
    final store = context.read<ProviderGroup>();

    return Container(
      margin: const EdgeInsets.only(bottom: 35),
      height: 70.0,
      child: InkWell(
        child: _delContainer(context),
        onTap: () async {
          if (store.selectedId != defualtGroupId) {
            // デフォルトのリストで無ければ、削除処理を行う
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("確認"),
                  content: SizedBox(
                    height: 90.0,
                    child: Column(
                      children: const [
                        Text("リストを削除します。よろしいですか？"),
                        Text(
                          "この操作は取り消しできません。",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        // ダイアログを閉じる
                        Navigator.of(context).pop(0);
                        // モーダルシートも閉じる
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        // グループリストと紐づくTodoを物理削除
                        store.delete(store.selectedId);
                        // グループリストの再読み込み
                        context.read<ProviderGroup>().initializeList();
                        // デフォルトリストを選択中にする
                        prvShared.saveIntValue(keySelectId, defualtGroupId);
                        prvShared.setSelectedGroupId(defualtGroupId);
                        // タイトルを反映させる
                        store.getSelectedInfo();
                        // ToDoリストも再読み込みする
                        context.read<ProviderTodo>().initializeList();
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
  final store = context.watch<ProviderGroup>();
  final _isDefualt = store.selectedId == defualtGroupId ? true : false;

  return Container(
    width: double.infinity,
    alignment: Alignment.topLeft,
    child: ListTile(
      title: Text(
        "リストを削除する",
        style: TextStyle(
          fontSize: 18,
          color: _isDefualt ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(
        _isDefualt ? "\nデフォルトのリストは削除できません" : "",
        style: TextStyle(
          fontSize: 14,
          color: _isDefualt ? Colors.grey : Colors.black,
        ),
      ),
    ),
  );
}
