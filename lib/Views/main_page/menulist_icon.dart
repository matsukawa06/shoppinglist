import '../../Common/importer.dart';
import '../newlist_page/newlist_page.dart';

///
/// メニューリスト
///
class MenuListIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ProviderGroup>().initializeList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 非同期処理未完了 = 処理中
          return Center(
            child: CircularProgressIndicator(),
          );
        }
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
                return SingleChildScrollView(
                  // child: ConstrainedBox(
                  //   constraints: BoxConstraints(
                  //     maxHeight: 600.0,
                  //   ),
                  child: Container(
                    child: _menuList(context),
                  ),
                  // ),
                );
              },
            );
          },
        );
      },
    );
  }
}

///
/// showModalBottomSheetの表示内容
///
Widget _menuList(BuildContext context) {
  final providerGroup = context.watch<ProviderGroup>();
  return Column(
    children: [
      ListView(
        // shrinkWrap、physicsの記述が無いとエラーになる
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: providerGroup.groupList.map(
          (GroupStore store) {
            return Container(
              key: Key(store.id.toString()),
              child: menuItem(context, store.id, store.title),
            );
          },
        ).toList(),
      ),
      _menuItemAdd(context, "リストを新しく作成"),
    ],
  );
}

///
/// リストを新規作成する画面へ遷移するアイテム
///
Widget _menuItemAdd(BuildContext context, String title) {
  return Container(
    margin: EdgeInsets.only(bottom: 25),
    height: 60.0,
    decoration: new BoxDecoration(
      border: new Border(
        top: BorderSide(
          width: 0.8,
          color: Colors.grey,
        ),
      ),
    ),
    child: InkWell(
      onTap: () {
        // "push"で新規画面に遷移
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              // 遷移先の画面として編集用画面を指定
              return NewListPage();
            },
          ),
        ).then(
          (value) async {
            // storeの初期化
            context.read<ProviderGroup>().clearItems();
            // グループリストの再読み込み
            context.read<ProviderGroup>().initializeList();
            // ToDoリストも再読み込みする
            context.read<ProviderTodo>().initializeList();
            // メニューリストを閉じる
            Navigator.pop(context);
          },
        );
      },
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
    ),
  );
}
