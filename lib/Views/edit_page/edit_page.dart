import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'title_textField.dart';
import 'memo_textField.dart';
import 'price_textField.dart';
import 'release_container.dart';
import '../../Models/provider_store.dart';
import '../../Models/todo_store.dart';
import '../../Cotrollers/todo_controller.dart';
import '../../Common/common_util.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStore = context.watch<ProviderStore>();
    final providerForm = context.read<ProviderForm>();

    Intl.defaultLocale = 'ja';
    initializeDateFormatting('ja');
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
        // 右側のアイコン一覧
        actions: <Widget>[
          Visibility(
            visible: providerStore.id == 0 ? false : true,
            child: IconButton(
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
                            providerStore.delete(providerStore.id);
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
            ),
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
                            value: providerStore.switchIsSum,
                            title: Text('計算対象に含める'),
                            onChanged: (bool value) {
                              providerStore.changeIsSum(value);
                            },
                          ),
                        ),

                        // 購入済みチェック
                        SwitchListTile(
                          value: providerStore.switchKonyuZumi,
                          title: Text('購入済み'),
                          onChanged: (bool value) {
                            providerStore.changeKonyuZumi(value);
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
                Container(
                  // 横幅いっぱいに広げる
                  width: double.infinity,
                  height: 50,
                  // リスト追加ボタン
                  child: ElevatedButton(
                    onPressed: () async {
                      if (providerForm.formVallidate()) {
                        Text('エラー');
                      }
                      // DBに登録する
                      if (providerStore.id == 0) {
                        // 新規
                        var _todo = TodoStore(
                          title: providerStore.titleController.text,
                          memo: providerStore.memoController.text,
                          price: int.parse(providerStore.priceController.text),
                          release: boolToInt(providerStore.switchReleaseDay),
                          releaseDay: providerStore.releaseDay,
                          isSum: boolToInt(providerStore.switchIsSum),
                          konyuZumi: boolToInt(providerStore.switchKonyuZumi),
                          sortNo: await TodoController.getListCount(),
                        );

                        await TodoController.insertTodo(_todo);
                      } else {
                        // 修正
                        var _todo = TodoStore(
                          id: providerStore.id,
                          title: providerStore.titleController.text,
                          memo: providerStore.memoController.text,
                          price: int.parse(providerStore.priceController.text),
                          release: boolToInt(providerStore.switchReleaseDay),
                          releaseDay: providerStore.releaseDay,
                          isSum: boolToInt(providerStore.switchIsSum),
                          konyuZumi: boolToInt(providerStore.switchKonyuZumi),
                          sortNo: providerStore.sortNo,
                        );

                        await TodoController.updateTodo(_todo);
                      }
                      // await TodoController.insertTodo(_todo);
                      // 前の画面に戻る
                      Navigator.pop(context);
                    },
                    child: Text(
                      providerStore.id == 0 ? 'リスト追加' : '修正',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: <Widget>[
          //     // タイトル
          //     TitleTextField(),
          //     SpaceBox.height(16),
          //     // メモ
          //     MemoTextField(),
          //     SpaceBox.height(16),
          //     // 価格
          //     PriceTextField(),
          //     SpaceBox.height(24),

          //     // ====================================
          //     // 発売日
          //     // ====================================
          //     Container(
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.blue),
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       child: Column(
          //         children: [
          //           // 発売予定日
          //           ReleaseContainer(),
          //         ],
          //       ),
          //     ),
          //     SpaceBox.height(24),

          //     // ====================================
          //     // 計算チェックと購入済みチェック
          //     // ====================================
          //     Container(
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.blue),
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       child: Column(
          //         children: [
          //           Container(
          //             decoration: BoxDecoration(
          //               border: const Border(
          //                 bottom: const BorderSide(
          //                   color: Colors.blue,
          //                 ),
          //               ),
          //             ),
          //             // 金額計算チェック
          //             child: SwitchListTile(
          //               value: providerStore.switchIsSum,
          //               title: Text('計算対象に含める'),
          //               onChanged: (bool value) {
          //                 providerStore.changeIsSum(value);
          //               },
          //             ),
          //           ),

          //           // 購入済みチェック
          //           SwitchListTile(
          //             value: providerStore.switchKonyuZumi,
          //             title: Text('購入済み'),
          //             onChanged: (bool value) {
          //               providerStore.changeKonyuZumi(value);
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //     SpaceBox.height(24),

          //     // ====================================
          //     // ボタン
          //     // ====================================
          //     Container(
          //       // 横幅いっぱいに広げる
          //       width: double.infinity,
          //       height: 50,
          //       // リスト追加ボタン
          //       child: ElevatedButton(
          //         onPressed: () async {
          //           // DBに登録する
          //           if (providerStore.id == 0) {
          //             // 新規
          //             var _todo = TodoStore(
          //               title: providerStore.titleController.text,
          //               memo: providerStore.memoController.text,
          //               price: int.parse(providerStore.priceController.text),
          //               release: boolToInt(providerStore.switchReleaseDay),
          //               releaseDay: providerStore.releaseDay,
          //               isSum: boolToInt(providerStore.switchIsSum),
          //               konyuZumi: boolToInt(providerStore.switchKonyuZumi),
          //               sortNo: await TodoController.getListCount(),
          //             );

          //             await TodoController.insertTodo(_todo);
          //           } else {
          //             // 修正
          //             var _todo = TodoStore(
          //               id: providerStore.id,
          //               title: providerStore.titleController.text,
          //               memo: providerStore.memoController.text,
          //               price: int.parse(providerStore.priceController.text),
          //               release: boolToInt(providerStore.switchReleaseDay),
          //               releaseDay: providerStore.releaseDay,
          //               isSum: boolToInt(providerStore.switchIsSum),
          //               konyuZumi: boolToInt(providerStore.switchKonyuZumi),
          //               sortNo: providerStore.sortNo,
          //             );

          //             await TodoController.updateTodo(_todo);
          //           }
          //           // await TodoController.insertTodo(_todo);
          //           // 前の画面に戻る
          //           Navigator.pop(context);
          //         },
          //         child: Text(
          //           providerStore.id == 0 ? 'リスト追加' : '修正',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
