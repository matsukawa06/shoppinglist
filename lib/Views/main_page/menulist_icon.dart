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
                child: _menuList(context),
              ),
            );
          },
        );
      },
    );
  }
}

///
/// showModalBottomSheet の表示内容
///
Widget _menuList(BuildContext context) {
  final store = context.watch<ProviderGroup>();

  return Column(
    children: [
      // グループリスト名の変更
      Container(
        margin: EdgeInsets.only(bottom: 25),
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
              // グループリストの再読み込み
              context.read<ProviderGroup>().initializeList();
              // ToDoリストも再読み込みする
              context.read<ProviderTodo>().initializeList();
              // メニューリストを閉じる
              Navigator.pop(context);
            });
          },
        ),
      ),
      // グループリストの削除
      Container(
        margin: EdgeInsets.only(bottom: 25),
        height: 60.0,
        child: InkWell(
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 15.0)),
              Text(
                "リストを削除する",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          onTap: () async {
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
                      onPressed: () => Navigator.of(context).pop(0),
                    ),
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {
                        // グループリストと紐づくTodoを物理削除

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
          },
        ),
      ),
      // 下にスペース設ける
      SpaceBox.height(50),
    ],
  );
}
