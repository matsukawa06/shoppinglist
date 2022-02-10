import 'dart:ffi';

import 'package:shoppinglist/Views/newlist_page/list_edit_page.dart';

import '../../Common/importer.dart';

///
/// メニューリスト
///
class MenuListIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_horiz),
      color: Colors.white,
      iconSize: 40,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext contex) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    // リスト更新
                    ListUpdate(),
                    // リスト削除
                    ListDelete(),
                  ],
                ),
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
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProviderGroup>();

    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 5),
      height: 60.0,
      child: InkWell(
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 15.0)),
            Text(
              "リスト名を変更する",
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
                return ListEditPage(MODE_UPD);
              },
            ),
          ).then((value) async {
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
          });
        },
      ),
    );
  }
}

///
/// リスト削除
///
class ListDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prvShared = context.watch<ProviderSharedPreferences>();
    final store = context.watch<ProviderGroup>();
    final _isDefualt = store.selectedId == GROUPID_DEFUALT ? true : false;
    return Container(
      margin: EdgeInsets.only(bottom: 35),
      height: 70.0,
      child: InkWell(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 15.0),
          child: Column(
            children: [
              Text(
                "リストを削除する",
                style: TextStyle(
                  fontSize: 18,
                  color: _isDefualt ? Colors.grey : Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 0.1,
              ),
              Text(
                _isDefualt ? "\nデフォルトのリストは削除できません" : "",
                style: TextStyle(
                  fontSize: 14,
                  color: _isDefualt ? Colors.grey : Colors.black,
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          if (store.selectedId != GROUPID_DEFUALT) {
            // デフォルトのリストで無ければ、削除処理を行う
            var result = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("確認"),
                  content: Container(
                    height: 90.0,
                    child: Column(
                      children: [
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
                      child: Text("Cancel"),
                      onPressed: () {
                        // ダイアログを閉じる
                        Navigator.of(context).pop(0);
                        // モーダルシートも閉じる
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {
                        // グループリストと紐づくTodoを物理削除
                        store.delete(store.selectedId);
                        // デフォルトリストを選択中にする
                        prvShared.saveValue(SELECT_ID_KEY, GROUPID_DEFUALT);
                        prvShared.setSelectedGroupId(GROUPID_DEFUALT);
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
            print("dialog result: $result");
          }
        },
      ),
    );
  }
}
