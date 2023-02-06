///
/// リストの新規追加ページ
///
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/common/common_const.dart';
import 'package:shoppinglist/common/common_util.dart';
import 'package:shoppinglist/models/form_provider.dart';
import 'package:shoppinglist/models/group_provider.dart';
import 'package:shoppinglist/models/group_store.dart';
import 'package:shoppinglist/presentation/controllers/group_controller.dart';
import 'package:shoppinglist/presentation/ui/newlist_page/grouptitle_textField.dart';

class NewListPage extends ConsumerWidget {
  final String _mode;
  const NewListPage(this._mode, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: ref.read(formProvider).formKey,
      child: Scaffold(
        appBar: AppBar(
          title: _retTitleTextWidget(_mode),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                right: 20,
              ),
              // 右上保存テキスト
              child: InkWell(
                child: _retSaveTextWidget(),
                onTap: () async {
                  _clickSave(context, ref, _mode);
                },
              ),
            ),
          ],
        ),
        body: const Body(),
      ),
    );
  }
}

///
/// 画面タイトルテキスト
///
Widget _retTitleTextWidget(String _mode) {
  String _strTitle = "";

  switch (_mode) {
    case modeInsert:
      _strTitle = "リストを新規作成";
      break;
    case modeUpdate:
      _strTitle = "リスト名を変更";
      break;
    default:
  }
  return Text(_strTitle);
}

///
/// 保存テキスト
///
Widget _retSaveTextWidget() {
  return const Text(
    '保存',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

///
/// 保存クリック処理
///
void _clickSave(BuildContext context, WidgetRef ref, String _mode) async {
  final _groupProvider = ref.read(groupProvider);
  if (ref.read(formProvider).formVallidate()) {
    // 入力チェックでエラーが無ければ、DBに登録する
    switch (_mode) {
      case modeInsert:
        var _providerStore = GroupStore(
          title: _groupProvider.titleController.text,
          color: _groupProvider.pickerColor.toString(),
        );
        await GroupController.insertGroup(_providerStore);
        break;
      case modeUpdate:
        var _providerStore = GroupStore(
          id: _groupProvider.selectedId,
          title: _groupProvider.titleController.text,
          color: _groupProvider.pickerColor.toString(),
        );
        await GroupController.updateGroup(_providerStore);
        break;
      default:
    }
    // storeの初期化
    _groupProvider.clearItems();
    // タイトルを反映させる
    _groupProvider.getSelectedInfo();
    // グループリストの再読み込み
    _groupProvider.initializeList();
    // 前の画面に戻る
    Navigator.pop(context);
  }
}

///
/// newListページのbody部
///
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
