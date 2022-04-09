///
/// リストの新規追加ページ
///
import '../../Common/importer.dart';
import 'body.dart';

class ListEditPage extends StatelessWidget {
  final String mode;
  ListEditPage(this.mode);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ProviderForm>().formKey,
      child: Scaffold(
        appBar: AppBar(
          title: _retTitleTextWidget(mode),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(
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
    case MODE_INS:
      strTitle = "リストを新規作成";
      break;
    case MODE_UPD:
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
  return Text(
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
  if (context.read<ProviderForm>().formVallidate()) {
    // 入力チェックでエラーが無ければ、DBに登録する
    switch (mode) {
      case MODE_INS:
        var _providerStore = GroupStore(
          title: context.read<ProviderGroup>().titleController.text,
        );
        await GroupController.insertGroup(_providerStore);
        break;
      case MODE_UPD:
        var _providerStore = GroupStore(
          id: context.read<ProviderGroup>().selectedId,
          title: context.read<ProviderGroup>().titleController.text,
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
