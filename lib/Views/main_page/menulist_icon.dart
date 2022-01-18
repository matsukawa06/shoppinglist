import '../../Common/importer.dart';

///
/// メニューリスト
///
class MenuListIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      color: Colors.white,
      iconSize: 40,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                // minHeight: 100.0,
                maxHeight: 600.0,
              ),
              child: Container(
                // height: (100 + (55 * 0)),
                child: _menuList(context),
              ),
            );
          },
        );
      },
    );
  }
}

Widget _menuList(BuildContext context) {
  final providerStore = context.watch<ProviderStore>();
  return Column(
    children: [
      _menuItemAdd("リストを新しく作成"),
      ListView(
        // shrinkWrap、physicsの記述が無いとエラーになる
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // children: providerStore.groupList.map(
        //   (GroupStore store) {
        //     return Container(
        //       key: Key(store.id.toString()),
        //       child: _menuItem(store.title),
        //     );
        //   },
        // ).toList(),
        children: [
          _menuItem("日用品リスト"),
          _menuItem("電化製品"),
          _menuItem("スーパー○○のリスト"),
        ],
      ),
    ],
  );
}

Widget _menuItem(String title) {
  return Container(
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    ),
  );
}

Widget _menuItemAdd(String title) {
  return Container(
    margin: EdgeInsets.only(top: 18),
    height: 60.0,
    decoration: new BoxDecoration(
      border: new Border(
        bottom: BorderSide(
          width: 0.8,
          color: Colors.grey,
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(left: 15.0)),
        Icon(Icons.add),
        Padding(padding: EdgeInsets.only(left: 15.0)),
        Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}
