///
/// Todo の編集ページ
///
import '../../Common/importer.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'body.dart';
// import 'footer.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _providerTodo = context.watch<ProviderTodo>();

    Intl.defaultLocale = 'ja';
    initializeDateFormatting('ja');
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
        // 右側のアイコン一覧
        actions: <Widget>[
          Visibility(
            visible: _providerTodo.id == 0 ? false : true,
            child: _iconButton(context),
          ),
          SpaceBox.width(15),
          TextButton(
              onPressed: () async {
                // 登録・更新処理
                _insertUpdate(context);
              },
              child: Text(
                '保存',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
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
Widget _iconButton(BuildContext context) {
  final providerTodo = context.watch<ProviderTodo>();
  return IconButton(
    onPressed: () async {
      var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('確認'),
            content: Text('削除します。よろしいですか？'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(0),
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  // 論理削除に変更
                  // providerStore.delete(providerStore.id);
                  providerTodo.updateIsDelete(providerTodo.id, true);
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
      print('dialog result: $result');
      // providerStore.delete(providerStore.id);
    },
    icon: Icon(Icons.delete),
  );
}

///
/// 登録・修正処理
///
void _insertUpdate(BuildContext context) async {
  final providerTodo = context.read<ProviderTodo>();
  final providerForm = context.read<ProviderForm>();
  var prefs = await SharedPreferences.getInstance();
  var selectedId = (prefs.getInt(SELECT_ID_KEY) ?? GROUPID_DEFUALT);

  if (providerForm.formVallidate()) {
    // 入力チェックでエラーが無ければ、DBに登録する
    if (providerTodo.id == 0) {
      // 新規
      var _todo = TodoStore(
        title: providerTodo.titleController.text,
        memo: providerTodo.memoController.text,
        price: int.parse(providerTodo.priceController.text),
        release: boolToInt(providerTodo.switchReleaseDay),
        releaseDay: providerTodo.releaseDay,
        isSum: boolToInt(providerTodo.switchIsSum),
        konyuZumi: boolToInt(providerTodo.switchKonyuZumi),
        sortNo: await TodoController.getListCount(),
        isDelete: boolToInt(providerTodo.isDelete),
        deleteDay: providerTodo.deleteDay,
        groupId: selectedId,
        konyuDay: providerTodo.konyuDay,
      );

      await TodoController.insertTodo(_todo);
    } else {
      // 修正
      var _todo = TodoStore(
        id: providerTodo.id,
        title: providerTodo.titleController.text,
        memo: providerTodo.memoController.text,
        price: int.parse(providerTodo.priceController.text),
        release: boolToInt(providerTodo.switchReleaseDay),
        releaseDay: providerTodo.releaseDay,
        isSum: boolToInt(providerTodo.switchIsSum),
        konyuZumi: boolToInt(providerTodo.switchKonyuZumi),
        sortNo: providerTodo.sortNo,
        isDelete: boolToInt(providerTodo.isDelete),
        deleteDay: providerTodo.deleteDay,
        groupId: selectedId,
        konyuDay: providerTodo.konyuDay,
      );

      await TodoController.updateTodo(_todo);
    }
    // await TodoController.insertTodo(_todo);
    // 前の画面に戻る
    Navigator.pop(context);
  }
}
