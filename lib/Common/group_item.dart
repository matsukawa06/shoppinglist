import 'importer.dart';

///
/// grouplistテーブルに登録されているデータを表示するアイテム
///
Widget groupItem(BuildContext context, int? id, String title, String color) {
  final prvShared = context.read<ProviderSharedPreferences>();
  final providerGroup = context.read<ProviderGroup>();

  return Container(
    // margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(color: _setBackColor(context, id)),
    child: Container(
      margin: const EdgeInsets.only(left: 40, right: 10),
      height: 60.0,
      child: InkWell(
        onTap: () {
          // 選択したリストを選択中にする
          prvShared.saveIntValue(keySelectId, id!);
          prvShared.setSelectedGroupId(id);
          // タイトルを反映させる
          providerGroup.getSelectedInfo();
          // ToDoリストも再読み込みする
          context.read<ProviderTodo>().initializeList();
          Navigator.pop(context);
        },
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 1.0)),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: stringToColor(color),
                shape: BoxShape.circle,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 5.0)),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
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
