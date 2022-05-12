import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/Common/common_const.dart';
import 'package:shoppinglist/Common/common_util.dart';
import 'package:shoppinglist/Models/group_provider.dart';
import 'package:shoppinglist/Models/shared_provider.dart';
import 'package:shoppinglist/Models/todo_provider.dart';

///
/// grouplistテーブルに登録されているデータを表示するアイテム
///
Widget groupItem(BuildContext context, int? id, String title, String color) {
  return Consumer(
    builder: (context, ref, child) {
      final _sharedProvider = ref.read(sharedProvider);
      final _groupProvider = ref.read(groupProvider);
      return Container(
        // margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(color: _setBackColor(ref, id)),
        child: Container(
          margin: const EdgeInsets.only(left: 40, right: 10),
          height: 60.0,
          child: InkWell(
            onTap: () {
              // 選択したリストを選択中にする
              _sharedProvider.saveIntValue(keySelectId, id!);
              _sharedProvider.setSelectedGroupId(id);
              // タイトルを反映させる
              _groupProvider.getSelectedInfo();
              // ToDoリストも再読み込みする
              ref.read(todoProvider).initializeList();
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
    },
  );
}

///
/// グループリストの背景色を設定
Color _setBackColor(WidgetRef ref, int? id) {
  if (ref.read(groupProvider).selectedId == id) {
    // 選択中は背景色を変える
    return Colors.yellow.shade100;
  } else {
    return Colors.grey.shade50;
  }
}
