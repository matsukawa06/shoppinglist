///
/// グループリスト編集ページのbody部
///
import '../../Common/importer.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'grouptitle_textField.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  Color picker = Colors.blue;

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
              GroupTitleTextField(),
              // SpaceBox.height(1),
              // // カラー選択
              // Card(
              //   elevation: 5,
              //   child: InkWell(
              //     child: Container(),
              //     onTap: () {
              //       _showPicker(context);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// void _showPicker(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('カラー選択'),
//         content: SingleChildScrollView(
//           child: BlockPicker(
//             pickerColor: Colors.blue,
//             onColorChanged: _changeColor,
//           ),
//         ),
//         actions: [],
//       );
//     },
//   );
// }

///
/// カラー選択Widget
///
Widget retColorPikerWidet(BuildContext contex) {
  return BlockPicker(
    pickerColor: Colors.blue,
    onColorChanged: _changeColor,
  );
}

void _changeColor(Color color) {}
