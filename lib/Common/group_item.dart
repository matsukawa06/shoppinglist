import 'importer.dart';

///
/// grouplistテーブルに登録されているデータを表示するアイテム
///
Widget groupItem(BuildContext context, int? id, String title) {
  final prvShared = context.read<ProviderSharedPreferences>();
  final providerGroup = context.read<ProviderGroup>();

  return Container(
    // margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(color: _setBackColor(context, id)),
    child: Container(
      margin: EdgeInsets.only(left: 40, right: 10),
      height: 60.0,
      child: InkWell(
        onTap: () {
          // 選択したリストを選択中にする
          prvShared.saveIntValue(SELECT_ID_KEY, id!);
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
    ),
  );
}

///
/// グループリストの背景色を設定
Color _setBackColor(BuildContext context, int? id) {
  final providerGroup = context.read<ProviderGroup>();

  if (providerGroup.selectedId == id) {
    // 選択中は背景色を変える
    return Colors.yellow.shade100;
  } else {
    return Colors.grey.shade50;
  }
}
