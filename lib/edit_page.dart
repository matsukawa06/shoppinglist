import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dbManager.dart';

class EditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<EditPage> {
  // タイトル入力内容
  final _titleController = TextEditingController();
  // メモ入力内容
  final _memoController = TextEditingController();
  // 価格
  final _priceController = TextEditingController();
  // 発売日選択チェックの状態
  var _switchReleaseDay = false;
  // 金額計算対象チェックの状態
  var _switchIsSum = false;
  // 購入済みチェックの状態
  var _switchKonyuZumi = false;

  var _labelDate = '日付を選択してください';

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
      setState(() {
        var formatter = new DateFormat('yyyy/MM/dd(E)', "ja_JP");
        _labelDate = formatter.format(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: _titleController,
              enabled: true,
              maxLength: 30,
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'タイトルを入力してください',
                enabledBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            // メモ
            TextField(
              controller: _memoController,
              enabled: true,
              maxLength: 300,
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'メモを入力してください',
                enabledBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  // 価格
                  TextField(
                    controller: _priceController,
                    enabled: true,
                    // maxLength: 8,
                    style: TextStyle(color: Colors.black),
                    // obscureText: false,
                    decoration: InputDecoration(
                      hintText: '価格を入力してください',
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  // 発売予定日
                  SwitchListTile(
                    value: _switchReleaseDay,
                    title: Text('発売日'),
                    onChanged: (bool value) {
                      setState(() {
                        _switchReleaseDay = value;
                      });
                    },
                  ),
                  Container(
                    child: Visibility(
                      visible: _switchReleaseDay,
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
                              _labelDate,
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
                      value: _switchIsSum,
                      title: Text('計算対象に含める'),
                      onChanged: (bool value) {
                        setState(() {
                          _switchIsSum = value;
                        });
                      },
                    ),
                  ),

                  // 購入済みチェック
                  SwitchListTile(
                    value: _switchKonyuZumi,
                    title: Text('購入済み'),
                    onChanged: (bool value) {
                      setState(() {
                        _switchKonyuZumi = value;
                      });
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
                  var _todo = Todo(
                    title: _titleController.text,
                    memo: _memoController.text,
                    price: int.parse(_priceController.text),
                    release: switchChange(_switchReleaseDay),
                    releaseDay: DateTime.now(),
                    isSum: switchChange(_switchIsSum),
                    konyuZumi: switchChange(_switchKonyuZumi),
                  );
                  await Todo.insertTodo(_todo);
                  // 各Controllerのクリア
                  _titleController.clear();
                  _memoController.clear();
                  _priceController.clear();
                  _switchReleaseDay = false;
                  _switchIsSum = false;
                  _switchKonyuZumi = false;
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
}

int switchChange(bool value) {
  int retValue;
  if (value == false) {
    retValue = 0;
  } else {
    retValue = 1;
  }
  return retValue;
}
