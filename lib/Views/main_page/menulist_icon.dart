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
  return Column(
    children: [
      // グループリスト名の変更
      Container(
        margin: EdgeInsets.only(bottom: 25),
        height: 60.0,
        child: InkWell(
          child: Text("リスト名を変更する"),
          onTap: () {
            // "push"で更新画面に遷移
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ListEditPage(MODE_UPD);
                },
              ),
            );
          },
        ),
      ),
      // グループリストの削除
      Container(
        margin: EdgeInsets.only(bottom: 25),
        height: 60.0,
        child: InkWell(
          child: Text("リストを削除する"),
          onTap: () async {
            var result = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("確認"),
                    content: Text("リストを削除します。よろしいですか？"),
                  );
                });
            // "push"で確認ダイアログを表示
          },
        ),
      ),
      // 下にスペース設ける
      SpaceBox.height(50),
    ],
  );
}
