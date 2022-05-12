///
/// Todo の編集ページ
///
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppinglist/Common/common_const.dart';
import 'package:shoppinglist/Common/common_util.dart';
import 'package:shoppinglist/Cotrollers/todo_controller.dart';
import 'package:shoppinglist/Models/form_provider.dart';
import 'package:shoppinglist/Models/group_provider.dart';
import 'package:shoppinglist/Models/todo_provider.dart';
import 'package:shoppinglist/Models/todo_store.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'body.dart';
// import 'footer.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _providerTodo = context.watch<TodoProvider>();

    Intl.defaultLocale = 'ja';
    initializeDateFormatting('ja');
    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細'),
        // 右側のアイコン一覧
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return Visibility(
                visible: ref.watch(todoProvider).id == 0 ? false : true,
                child: _IconButton(),
              );
            },
          ),
          const SpaceBox.width(value: 15),
          Consumer(
            builder: (context, ref, child) {
              return TextButton(
                onPressed: () async {
                  // 登録・更新処理
                  _insertUpdate(context, ref);
                },
                child: Text(
                  '保存',
                  style: TextStyle(
                    color: ref.read(groupProvider).fontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Body(),
      // bottomNavigationBar: Footer(),
    );
  }
}

///
/// AppBarの右側
///
class _IconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _todoProvider = ref.watch(todoProvider);
    return IconButton(
      onPressed: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('確認'),
              content: const Text('削除します。よろしいですか？'),
              actions: <Widget>[
                TextButton(
                  child: const Text('いいえ'),
                  onPressed: () => Navigator.of(context).pop(0),
                ),
                TextButton(
                  child: const Text('はい'),
                  onPressed: () {
                    // 論理削除に変更
                    _todoProvider.delete(_todoProvider.id);
                    // providerTodo.updateIsDelete(providerTodo.id, true);
                    // ダイアログを閉じる
                    Navigator.pop(context);
                    // 編集画面を閉じる
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        // providerStore.delete(providerStore.id);
      },
      icon: const Icon(Icons.delete),
    );
  }
}

// Widget _iconButton(BuildContext context) {
//   final _todoProvider = context.watch<TodoProvider>();
//   return IconButton(
//     onPressed: () async {
//       await showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('確認'),
//             content: const Text('削除します。よろしいですか？'),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('いいえ'),
//                 onPressed: () => Navigator.of(context).pop(0),
//               ),
//               TextButton(
//                 child: const Text('はい'),
//                 onPressed: () {
//                   // 論理削除に変更
//                   _todoProvider.delete(_todoProvider.id);
//                   // providerTodo.updateIsDelete(providerTodo.id, true);
//                   // ダイアログを閉じる
//                   Navigator.pop(context);
//                   // 編集画面を閉じる
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         },
//       );
//       // providerStore.delete(providerStore.id);
//     },
//     icon: const Icon(Icons.delete),
//   );
// }

///
/// 登録・修正処理
///
void _insertUpdate(BuildContext context, WidgetRef ref) async {
  final _todoProvider = ref.read(todoProvider);
  final _formProvider = ref.read(formProvider);
  var prefs = await SharedPreferences.getInstance();
  var selectedId = (prefs.getInt(keySelectId) ?? defualtGroupId);

  if (_formProvider.formVallidate()) {
    // 入力チェックでエラーが無ければ、DBに登録する
    if (_todoProvider.id == 0) {
      // 新規
      var _todo = TodoStore(
        title: _todoProvider.titleController.text,
        memo: _todoProvider.memoController.text,
        price: int.parse(_todoProvider.priceController.text),
        release: boolToInt(_todoProvider.switchReleaseDay),
        releaseDay: _todoProvider.releaseDay,
        isSum: boolToInt(_todoProvider.switchIsSum),
        konyuZumi: boolToInt(_todoProvider.switchKonyuZumi),
        sortNo: await TodoController.getListCount(selectedId),
        isDelete: boolToInt(_todoProvider.isDelete),
        deleteDay: _todoProvider.deleteDay,
        groupId: selectedId,
        konyuDay: _todoProvider.konyuDay,
      );

      await TodoController.insertTodo(_todo);
    } else {
      // 修正
      var _todo = TodoStore(
        id: _todoProvider.id,
        title: _todoProvider.titleController.text,
        memo: _todoProvider.memoController.text,
        price: int.parse(_todoProvider.priceController.text),
        release: boolToInt(_todoProvider.switchReleaseDay),
        releaseDay: _todoProvider.releaseDay,
        isSum: boolToInt(_todoProvider.switchIsSum),
        konyuZumi: boolToInt(_todoProvider.switchKonyuZumi),
        sortNo: _todoProvider.sortNo,
        isDelete: boolToInt(_todoProvider.isDelete),
        deleteDay: _todoProvider.deleteDay,
        groupId: selectedId,
        konyuDay: _todoProvider.konyuDay,
      );

      await TodoController.updateTodo(_todo);
    }
    // await TodoController.insertTodo(_todo);
    // 前の画面に戻る
    Navigator.pop(context);
  }
}
