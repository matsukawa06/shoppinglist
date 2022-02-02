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
      Container(),
      // グループリストの削除
      Container(),
      // 下にスペース設ける
      SpaceBox.height(50),
    ],
  );
}
