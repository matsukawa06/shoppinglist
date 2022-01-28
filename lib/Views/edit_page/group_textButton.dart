import '../../Common/importer.dart';

class GroupTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerGroup = context.watch<ProviderGroup>();
    return new Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600.0),
                child: _menuList(context),
              );
            },
          );
        },
        child: Text(
          providerGroup.selectListTitle + " ▼",
        ),
      ),
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
              child: _menuItem(context, store.id, store.title),
            );
          },
        ).toList(),
      ),
    ],
  );
}

///
/// grouplistテーブルに登録されているデータを表示するアイテム
///
Widget _menuItem(BuildContext context, int? id, String title) {
  final providerGroup = context.watch<ProviderGroup>();

  return Container(
    margin: EdgeInsets.only(left: 40),
    height: 60.0,
    child: InkWell(
      onTap: () {
        // 選択したタイトルを設定
        providerGroup.getSelectedIdTitle(id);
        Navigator.pop(context);
      },
      child: Row(
        children: [
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
