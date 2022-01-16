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
        showBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 400,
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
        children: providerStore.groupList.map(
          (GroupStore store) {
            return Container(
              key: Key(store.id.toString()),
              child: Text(store.title),
            );
          },
        ).toList(),
      ),
      Text("新規追加"),
    ],
  );
}

final listItems = ['item1', 'item2'];
