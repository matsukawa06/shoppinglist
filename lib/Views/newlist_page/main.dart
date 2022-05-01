///
/// リストの新規追加ページ
///
import '../../Common/importer.dart';
import 'body.dart';

class ListEditPage extends StatelessWidget {
  final String mode;
  const ListEditPage(this.mode, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ProviderForm>().formKey,
      child: Scaffold(
        appBar: AppBar(
          title: _retTitleTextWidget(mode),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                right: 20,
              ),
              // 右上完了テキスト
              child: InkWell(
                child: _retKanryoTextWidget(),
                onTap: () async {
                  _clickKanryo(context, mode);
                },
              ),
            ),
          ],
        ),
        body: Body(),
      ),
    );
  }
}

///
/// 画面タイトルテキスト
///
Widget _retTitleTextWidget(String mode) {
  String strTitle = "";

  switch (mode) {
    case modeInsert:
      strTitle = "リストを新規作成";
      break;
    case modeUpdate:
      strTitle = "リスト名を変更";
      break;
    default:
  }
  return Text(strTitle);
}

///
/// 完了テキスト
///
Widget _retKanryoTextWidget() {
  return const Text(
    '保存',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

///
/// 完了クリック処理
///
void _clickKanryo(BuildContext context, String mode) async {
  final _providerGroup = context.read<ProviderGroup>();
  if (context.read<ProviderForm>().formVallidate()) {
    // 入力チェックでエラーが無ければ、DBに登録する
    switch (mode) {
      case modeInsert:
        var _providerStore = GroupStore(
          title: _providerGroup.titleController.text,
          color: _providerGroup.pickerColor.toString(),
        );
        await GroupController.insertGroup(_providerStore);
        break;
      case modeUpdate:
        var _providerStore = GroupStore(
          id: _providerGroup.selectedId,
          title: _providerGroup.titleController.text,
          color: _providerGroup.pickerColor.toString(),
        );
        await GroupController.updateGroup(_providerStore);
        break;
      default:
    }
    // storeの初期化
    context.read<ProviderGroup>().clearItems();
    // タイトルを反映させる
    context.read<ProviderGroup>().getSelectedInfo();
    // グループリストの再読み込み
    context.read<ProviderGroup>().initializeList();
    // 前の画面に戻る
    Navigator.pop(context);
  }
}
