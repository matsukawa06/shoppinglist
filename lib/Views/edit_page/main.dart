///
/// Todo の編集ページ
///
import '../../Common/importer.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'body.dart';

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
          TextButton(
              onPressed: () {},
              child: Text(
                "更新",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              )),
        ],
      ),
      body: Body(),
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
