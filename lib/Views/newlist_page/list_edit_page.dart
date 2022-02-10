import '../../Common/importer.dart';
import 'grouptitle_textField.dart';

class ListEditPage extends StatelessWidget {
  final String mode;
  ListEditPage(this.mode);

  @override
  Widget build(BuildContext context) {
    final providerForm = context.read<ProviderForm>();
    final store = context.watch<ProviderGroup>();
    return Form(
      key: providerForm.formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_setTitle(mode)),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 10,
                right: 20,
              ),
              // 右上完了テキスト
              child: InkWell(
                child: Text(
                  '完了',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  if (providerForm.formVallidate()) {
                    // 入力チェックでエラーが無ければ、DBに登録する
                    switch (mode) {
                      case MODE_INS:
                        var _providerStore = GroupStore(
                          title: store.titleController.text,
                        );
                        await GroupController.insertGroup(_providerStore);
                        break;
                      case MODE_UPD:
                        var _providerStore = GroupStore(
                          id: store.selectedId,
                          title: store.titleController.text,
                        );
                        await GroupController.updateGroup(_providerStore);
                        break;
                      default:
                    }
                    // storeの初期化
                    context.read<ProviderGroup>().clearItems();
                    // タイトルを反映させる
                    store.getSelectedInfo();
                    // グループリストの再読み込み
                    context.read<ProviderGroup>().initializeList();
                    // 前の画面に戻る
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(18),
            child: GroupTitleTextField(),
          ),
        ),
      ),
    );
  }
}

///
/// 画面タイトル設定
///
String _setTitle(String mode) {
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
  return strTitle;
}
