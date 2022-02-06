import '../../Common/importer.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'group_textButton.dart';
import 'title_textField.dart';
import 'memo_textField.dart';
import 'price_textField.dart';
import 'release_container.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerTodo = context.watch<ProviderTodo>();
    final providerForm = context.read<ProviderForm>();

    Intl.defaultLocale = 'ja';
    initializeDateFormatting('ja');
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
        // 右側のアイコン一覧
        actions: <Widget>[
          Visibility(
            visible: providerTodo.id == 0 ? false : true,
            child: _iconButton(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // 余白をつける
          padding: EdgeInsets.all(18),
          child: Form(
            key: providerForm.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // グループリスト選択
                GroupTextButton(),
                SpaceBox.height(1),
                // タイトル
                TitleTextField(),
                SpaceBox.height(1),
                // メモ
                MemoTextField(),
                SpaceBox.height(1),
                // 価格
                PriceTextField(),
                SpaceBox.height(24),

                // ====================================
                // 発売日
                // ====================================
                Card(
                  elevation: 5,
                  child: Container(
                    child: Column(
                      children: [
                        // 発売予定日
                        ReleaseContainer(),
                      ],
                    ),
                  ),
                ),
                SpaceBox.height(24),

                // ====================================
                // 計算チェックと購入済みチェック
                // ====================================
                Card(
                  elevation: 5,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: const Border(
                              bottom: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          // 金額計算チェック
                          child: SwitchListTile(
                            value: providerTodo.switchIsSum,
                            title: Text('計算対象に含める'),
                            onChanged: (bool value) {
                              providerTodo.changeIsSum(value);
                            },
                          ),
                        ),

                        // 購入済みチェック
                        SwitchListTile(
                          value: providerTodo.switchKonyuZumi,
                          title: Text('購入済み'),
                          onChanged: (bool value) {
                            providerTodo.changeKonyuZumi(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SpaceBox.height(24),

                // ====================================
                // ボタン
                // ====================================
                _bottomButton(context),
              ],
            ),
          ),
        ),
      ),
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
/// 登録、修正ボタン部
///
Widget _bottomButton(BuildContext context) {
  final providerTodo = context.watch<ProviderTodo>();
  final providerForm = context.read<ProviderForm>();

  return Container(
    // 横幅いっぱいに広げる
    width: double.infinity,
    height: 50,
    // リスト追加ボタン
    child: ElevatedButton(
      onPressed: () async {
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
            );

            await TodoController.updateTodo(_todo);
          }
          // await TodoController.insertTodo(_todo);
          // 前の画面に戻る
          Navigator.pop(context);
        }
      },
      child: Text(
        providerTodo.id == 0 ? 'リスト追加' : '修正',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
