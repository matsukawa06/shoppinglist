import 'importer.dart';

///
/// grouplistテーブルに登録されているデータを表示するアイテム
///
Widget groupItem(BuildContext context, int? id, String title) {
  final prvShared = context.watch<ProviderSharedPreferences>();
  final providerGroup = context.watch<ProviderGroup>();

  return Container(
    margin: EdgeInsets.only(left: 40, top: 10),
    height: 60.0,
    child: InkWell(
      onTap: () {
        // 選択したリストを選択中にする
        prvShared.saveValue(SELECT_ID_KEY, id!);
        prvShared.setSelectedGroupId(id);
        // タイトルを反映させる
        providerGroup.getSelectedInfo();
        // ToDoリストも再読み込みする
        context.read<ProviderTodo>().initializeList();
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
