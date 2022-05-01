///
/// グループリスト編集ページのbody部
///
import '../../Common/importer.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'grouptitle_textField.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  Color picker = Colors.blue;

  Body({Key? key}) : super(key: key);

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
                  child: InkWell(
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
                        SizedBox(
                          width: 50,
                          height: 40,
                          child: Container(
                            color: context.watch<ProviderGroup>().pickerColor,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showColorPicker(context);
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

Future _showColorPicker(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('カラー選択'),
        content: BlockPicker(
          pickerColor: context.watch<ProviderGroup>().pickerColor,
          onColorChanged: context.read<ProviderGroup>().changeColor,
        ),
        actions: <Widget>[
          ElevatedButton(
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
