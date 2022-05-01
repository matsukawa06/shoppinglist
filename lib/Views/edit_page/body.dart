///
/// Todo編集ページのbody部
///
import '../../Common/importer.dart';
import 'group_textButton.dart';
import 'konyu_container.dart';
import 'memo_textField.dart';
import 'price_textField.dart';
import 'release_container.dart';
import 'title_textField.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  final BannerAd myBanner = AdMobService().setBannerAd();

  @override
  Widget build(BuildContext context) {
    final _providerTodo = context.watch<ProviderTodo>();
    final _providerForm = context.read<ProviderForm>();

    // 広告の読み込み
    myBanner.load();
    final adWidget = AdWidget(ad: myBanner);

    return SingleChildScrollView(
      child: Container(
        // 余白をつける
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _providerForm.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // グループリスト選択
              const GroupTextButton(),
              const SpaceBox.height(value: 1),
              // タイトル
              const TitleTextField(),
              const SpaceBox.height(value: 1),
              // メモ
              const MemoTextField(),
              const SpaceBox.height(value: 1),
              // 価格
              const PriceTextField(),
              const SpaceBox.height(value: 24),

              // ====================================
              // 発売日
              // ====================================
              Card(
                elevation: 5,
                child: Column(
                  children: const [
                    // 発売予定日
                    ReleaseContainer(),
                  ],
                ),
              ),
              const SpaceBox.height(value: 24),

              // ====================================
              // 計算チェックと購入済みチェック
              // ====================================
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // 金額計算チェック
                      child: SwitchListTile(
                        value: _providerTodo.switchIsSum,
                        title: const Text('計算対象に含める'),
                        onChanged: (bool value) {
                          _providerTodo.changeIsSum(value);
                        },
                      ),
                    ),

                    // 購入済みチェック
                    const KonyuContainer(),
                  ],
                ),
              ),
              const SpaceBox.height(value: 36),

              // ====================================
              // ボタン
              // ====================================
              // _bottomButton(context),

              // Admob広告の表示
              AdMobService().setAdContainer(context, adWidget),
            ],
          ),
        ),
      ),
    );
  }
}

// ///
// /// 登録、修正ボタン部
// ///
// Widget _bottomButton(BuildContext context) {
//   final providerTodo = context.watch<ProviderTodo>();
//   final providerForm = context.read<ProviderForm>();

//   return Container(
//     // 横幅いっぱいに広げる
//     width: double.infinity,
//     height: 50,
//     // リスト追加ボタン
//     child: ElevatedButton(
//       onPressed: () async {
//         var prefs = await SharedPreferences.getInstance();
//         var selectedId = (prefs.getInt(SELECT_ID_KEY) ?? GROUPID_DEFUALT);

//         if (providerForm.formVallidate()) {
//           // 入力チェックでエラーが無ければ、DBに登録する
//           if (providerTodo.id == 0) {
//             // 新規
//             var _todo = TodoStore(
//               title: providerTodo.titleController.text,
//               memo: providerTodo.memoController.text,
//               price: int.parse(providerTodo.priceController.text),
//               release: boolToInt(providerTodo.switchReleaseDay),
//               releaseDay: providerTodo.releaseDay,
//               isSum: boolToInt(providerTodo.switchIsSum),
//               konyuZumi: boolToInt(providerTodo.switchKonyuZumi),
//               sortNo: await TodoController.getListCount(),
//               isDelete: boolToInt(providerTodo.isDelete),
//               deleteDay: providerTodo.deleteDay,
//               groupId: selectedId,
//               konyuDay: providerTodo.konyuDay,
//             );

//             await TodoController.insertTodo(_todo);
//           } else {
//             // 修正
//             var _todo = TodoStore(
//               id: providerTodo.id,
//               title: providerTodo.titleController.text,
//               memo: providerTodo.memoController.text,
//               price: int.parse(providerTodo.priceController.text),
//               release: boolToInt(providerTodo.switchReleaseDay),
//               releaseDay: providerTodo.releaseDay,
//               isSum: boolToInt(providerTodo.switchIsSum),
//               konyuZumi: boolToInt(providerTodo.switchKonyuZumi),
//               sortNo: providerTodo.sortNo,
//               isDelete: boolToInt(providerTodo.isDelete),
//               deleteDay: providerTodo.deleteDay,
//               groupId: selectedId,
//               konyuDay: providerTodo.konyuDay,
//             );

//             await TodoController.updateTodo(_todo);
//           }
//           // await TodoController.insertTodo(_todo);
//           // 前の画面に戻る
//           Navigator.pop(context);
//         }
//       },
//       child: Text(
//         providerTodo.id == 0 ? 'リスト追加' : '修正',
//         style: TextStyle(color: Colors.white),
//       ),
//     ),
//   );
// }
