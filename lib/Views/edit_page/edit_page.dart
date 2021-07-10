import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'title_textField.dart';
import 'memo_textField.dart';
import 'price_textField.dart';
import '../../Models/provider_store.dart';
import '../../Models/todo_store.dart';
import '../../Cotrollers/todo_controller.dart';
import '../../Common/common_util.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStore = context.watch<ProviderStore>();
    Intl.defaultLocale = 'ja';
    initializeDateFormatting('ja');
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細'),
      ),
      body: Container(
        // 余白をつける
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // タイトル
            TitleTextField(),
            // メモ
            MemoTextField(),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  // 価格
                  PriceTextField(),

                  // 発売予定日
                  SwitchListTile(
                    value: providerStore.switchReleaseDay,
                    title: Text('発売日'),
                    onChanged: (bool value) {
                      providerStore.changeReleaseDay(value);
                    },
                  ),
                  Container(
                    child: Visibility(
                      visible: providerStore.switchReleaseDay,
                      child: Container(
                        padding: const EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          border: const Border(
                            top: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(height: 15),
                            Text(
                              providerStore.labelDate,
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                                onPressed: () => _selectDate(context),
                                icon: Icon(Icons.date_range))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: const BorderSide(
                          color: Colors.blue,
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
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              height: 50,
              // リスト追加ボタン
              child: ElevatedButton(
                onPressed: () async {
                  // DBに登録する
                  var _todo = TodoStore(
                    title: providerStore.titleController.text,
                    memo: providerStore.memoController.text,
                    price: int.parse(providerStore.priceController.text),
                    release: boolToInt(providerStore.switchReleaseDay),
                    releaseDay: DateTime.now(),
                    isSum: boolToInt(providerStore.switchIsSum),
                    konyuZumi: boolToInt(providerStore.switchKonyuZumi),
                  );
                  await TodoController.insertTodo(_todo);
                  // 各Controllerのクリア
                  providerStore.clearControllers();
                  // 前の画面に戻る
                  Navigator.pop(context);
                },
                child: Text(
                  'リスト追加',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 選択した発売日
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      locale: const Locale('ja'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2024),
    );
    if (selected != null) {
      var formatter = new DateFormat('yyyy/MM/dd(E)', "ja_JP");
      context.read<ProviderStore>().changeLabelDate(formatter.format(selected));
    }
  }
}
