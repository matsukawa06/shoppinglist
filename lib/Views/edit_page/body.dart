///
/// Todo編集ページのbody部
///
import '../../Common/importer.dart';
import 'group_textButton.dart';
import 'title_textField.dart';
import 'memo_textField.dart';
import 'price_textField.dart';
import 'release_container.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _providerTodo = context.watch<ProviderTodo>();
    final _providerForm = context.read<ProviderForm>();

    return SingleChildScrollView(
      child: Container(
        // 余白をつける
        padding: EdgeInsets.all(18),
        child: Form(
          key: _providerForm.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // グループリスト選択
              GroupTextButton(),
              SpaceBox.height(1),
              // タイトル
              TitleTextField(),
              SpaceBox.height(1),
              // メモ
              MemoTextField(),
              SpaceBox.height(1),
              // 価格
              PriceTextField(),
              SpaceBox.height(24),

              // ====================================
              // 発売日
              // ====================================
              Card(
                elevation: 5,
                child: Container(
                  child: Column(
                    children: [
                      // 発売予定日
                      ReleaseContainer(),
                    ],
                  ),
                ),
              ),
              SpaceBox.height(24),

              // ====================================
              // 計算チェックと購入済みチェック
              // ====================================
              Card(
                elevation: 5,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: const Border(
                            bottom: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // 金額計算チェック
                        child: SwitchListTile(
                          value: _providerTodo.switchIsSum,
                          title: Text('計算対象に含める'),
                          onChanged: (bool value) {
                            _providerTodo.changeIsSum(value);
                          },
                        ),
                      ),

                      // 購入済みチェック
                      SwitchListTile(
                        value: _providerTodo.switchKonyuZumi,
                        title: Text('購入済み'),
                        onChanged: (bool value) {
                          _providerTodo.changeKonyuZumi(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SpaceBox.height(24),

              // ====================================
              // ボタン
              // ====================================
              _bottomButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// 登録、修正ボタン部
///
Widget _bottomButton(BuildContext context) {
  final providerTodo = context.watch<ProviderTodo>();
  final providerForm = context.read<ProviderForm>();

  return Container(
    // 横幅いっぱいに広げる
    width: double.infinity,
    height: 50,
    // リスト追加ボタン
    child: ElevatedButton(
      onPressed: () async {
        var prefs = await SharedPreferences.getInstance();
        var selectedId = (prefs.getInt(SELECT_ID_KEY) ?? GROUPID_DEFUALT);

        if (providerForm.formVallidate()) {
          // 入力チェックでエラーが無ければ、DBに登録する
          if (providerTodo.id == 0) {
            // 新規
            var _todo = TodoStore(
              title: providerTodo.titleController.text,
              memo: providerTodo.memoController.text,
              price: int.parse(providerTodo.priceController.text),
              release: boolToInt(providerTodo.switchReleaseDay),
              releaseDay: providerTodo.releaseDay,
              isSum: boolToInt(providerTodo.switchIsSum),
              konyuZumi: boolToInt(providerTodo.switchKonyuZumi),
              sortNo: await TodoController.getListCount(),
              isDelete: boolToInt(providerTodo.isDelete),
              deleteDay: providerTodo.deleteDay,
              groupId: selectedId,
            );

            await TodoController.insertTodo(_todo);
          } else {
            // 修正
            var _todo = TodoStore(
              id: providerTodo.id,
              title: providerTodo.titleController.text,
              memo: providerTodo.memoController.text,
              price: int.parse(providerTodo.priceController.text),
              release: boolToInt(providerTodo.switchReleaseDay),
              releaseDay: providerTodo.releaseDay,
              isSum: boolToInt(providerTodo.switchIsSum),
              konyuZumi: boolToInt(providerTodo.switchKonyuZumi),
              sortNo: providerTodo.sortNo,
              isDelete: boolToInt(providerTodo.isDelete),
              deleteDay: providerTodo.deleteDay,
              groupId: selectedId,
            );

            await TodoController.updateTodo(_todo);
          }
          // await TodoController.insertTodo(_todo);
          // 前の画面に戻る
          Navigator.pop(context);
        }
      },
      child: Text(
        providerTodo.id == 0 ? 'リスト追加' : '修正',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}