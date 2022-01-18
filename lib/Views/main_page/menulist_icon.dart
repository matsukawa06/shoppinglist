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
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            return Container(
              // height: (100 + (55 * 0)),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20,
                  )
                ],
              ),
              child: _menuList(context),
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
          // _menuItem("メニュー１"),
          // _menuItem("メニュー2"),
          // _menuItem("メニュー3"),
        ],
      ),
      _menuItemAdd("リストを新しく作成"),
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
    height: 100.0,
    decoration: new BoxDecoration(
      border: new Border(
        top: BorderSide(
          width: 0.8,
          color: Colors.grey,
        ),
      ),
    ),
    child: ListTile(
        leading: Icon(Icons.add),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        )),
  );
}
