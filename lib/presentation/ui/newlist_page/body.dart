///
/// グループリスト編集ページのbody部
///
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/common/common_util.dart';
import 'package:shoppinglist/models/group_provider.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'grouptitle_textField.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);
  // Color picker = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.95,
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              // タイトル
              const GroupTitleTextField(),
              const SpaceBox.height(value: 20),
              // カラー選択
              Card(
                elevation: 5,
                child: SizedBox(
                  height: 50,
                  child: Consumer(
                    builder: (context, ref, child) {
                      return InkWell(
                        child: Row(
                          children: [
                            // Cardのタイトル
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: const SizedBox(
                                width: 220,
                                child: Text(
                                  'カラー選択',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            // 選択中のカラーをContainerで表示
                            Consumer(
                              builder: (context, ref, child) {
                                return SizedBox(
                                  width: 50,
                                  height: 40,
                                  child: Container(
                                    color: ref.watch(groupProvider).pickerColor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _showColorPicker(context, ref);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future _showColorPicker(BuildContext context, WidgetRef ref) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('カラー選択'),
        content: BlockPicker(
          pickerColor: ref.watch(groupProvider).pickerColor,
          onColorChanged: ref.read(groupProvider).changeColor,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('決定'),
          )
        ],
      );
    },
  );
}
