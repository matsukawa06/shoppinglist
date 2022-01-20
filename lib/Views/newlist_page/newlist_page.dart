import '../../Common/importer.dart';

class NewListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProviderGroup>();

    return Scaffold(
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
                // DBに登録する
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
                // 前の画面に戻る
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _titleText(context),
      ),
    );
  }
}

///
/// タイトル入力欄
///
Widget _titleText(BuildContext context) {
  final store = context.watch<ProviderGroup>();
  return Container(
    padding: EdgeInsets.all(18),
    child: TextFormField(
      controller: store.titleController,
      maxLength: 15,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'リスト名',
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    ),
  );
}
