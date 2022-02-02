import '../../Common/importer.dart';
import 'grouptitle_textField.dart';

class NewListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerForm = context.read<ProviderForm>();

    return Form(
      key: providerForm.formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('リストを新規作成'),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 10,
                right: 20,
              ),
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
                    _dataInsUpd(context);
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
/// グループリストテーブルの登録、更新処理
///
void _dataInsUpd(BuildContext context) async {
  final store = context.watch<ProviderGroup>();
  if (store.defualtController.text == "") {
    var _providerStore = GroupStore(
      title: store.titleController.text,
      defualtKbn: "0",
    );

    await GroupController.insertGroup(_providerStore);
  } else {
    // 修正
    var _providerStore = GroupStore(
      id: store.id,
      title: store.titleController.text,
      defualtKbn: store.defualtController.text,
    );

    await GroupController.updateGroup(_providerStore);
  }
}
