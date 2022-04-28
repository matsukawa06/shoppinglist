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
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // タイトル
              const GroupTitleTextField(),
              const SpaceBox.height(value: 1),
              // カラー選択
              // Card(
              //   elevation: 5,
              //   child: InkWell(
              //     child: Container(),
              //     onTap: () {
              //       _showColorPicker(context);
              //     },
              //   ),
              // ),
              TextButton(
                onPressed: () async {
                  // await _showColorPicker(context);
                },
                child: const Text('カラー選択'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Future _showColorPicker(BuildContext context) async {
//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('カラー選択'),
//         content: BlockPicker(
//           pickerColor: myTheme.pickerColor,
//           onColorChanged: myTheme.changeColor,
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('決定'),
//           )
//         ],
//       );
//     },
//   );
// }
