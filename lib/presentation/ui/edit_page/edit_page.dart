///
/// Todo の編集ページ
///
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppinglist/common/common_const.dart';
import 'package:shoppinglist/common/common_util.dart';
import 'package:shoppinglist/models/form_provider.dart';
import 'package:shoppinglist/models/group_provider.dart';
import 'package:shoppinglist/models/todo_provider.dart';
import 'package:shoppinglist/models/todo_store.dart';
import 'package:shoppinglist/presentation/controllers/todo_controller.dart';
import 'package:shoppinglist/presentation/ui/edit_page/group_textButton.dart';
import 'package:shoppinglist/presentation/ui/edit_page/konyu_container.dart';
import 'package:shoppinglist/presentation/ui/edit_page/memo_textField.dart';
import 'package:shoppinglist/presentation/ui/edit_page/price_textField.dart';
import 'package:shoppinglist/presentation/ui/edit_page/release_container.dart';
import 'package:shoppinglist/presentation/ui/edit_page/title_textField.dart';
import 'package:shoppinglist/services/admob.dart';

// import 'body.dart';
// import 'footer.dart';

class EditPage extends StatelessWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _providerTodo = context.watch<TodoProvider>();

    Intl.defaultLocale = 'ja';
    initializeDateFormatting('ja');
    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細'),
        // 右側のアイコン一覧
        actions: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              return Visibility(
                visible: ref.watch(todoProvider).id == 0 ? false : true,
                child: _IconButton(),
              );
            },
          ),
          const SpaceBox.width(value: 15),
          Consumer(
            builder: (context, ref, child) {
              return TextButton(
                onPressed: () async {
                  // 登録・更新処理
                  _insertUpdate(context, ref);
                },
                child: Text(
                  '保存',
                  style: TextStyle(
                    color: ref.read(groupProvider).fontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Body(),
      // bottomNavigationBar: Footer(),
    );
  }
}

///
/// AppBarの右側
///
class _IconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _todoProvider = ref.watch(todoProvider);
    return IconButton(
      onPressed: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('確認'),
              content: const Text('削除します。よろしいですか？'),
              actions: <Widget>[
                TextButton(
                  child: const Text('いいえ'),
                  onPressed: () => Navigator.of(context).pop(0),
                ),
                TextButton(
                  child: const Text('はい'),
                  onPressed: () {
                    // 論理削除に変更
                    _todoProvider.delete(_todoProvider.id);
                    // providerTodo.updateIsDelete(providerTodo.id, true);
                    // ダイアログを閉じる
                    Navigator.pop(context);
                    // 編集画面を閉じる
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        // providerStore.delete(providerStore.id);
      },
      icon: const Icon(Icons.delete),
    );
  }
}

///
/// 登録・修正処理
///
void _insertUpdate(BuildContext context, WidgetRef ref) async {
  final _todoProvider = ref.read(todoProvider);
  final _formProvider = ref.read(formProvider);
  var prefs = await SharedPreferences.getInstance();
  var selectedId = (prefs.getInt(keySelectId) ?? defualtGroupId);

  if (_formProvider.formVallidate()) {
    // 入力チェックでエラーが無ければ、DBに登録する
    if (_todoProvider.id == 0) {
      // 新規
      var _todo = TodoStore(
        title: _todoProvider.titleController.text,
        memo: _todoProvider.memoController.text,
        price: int.parse(_todoProvider.priceController.text),
        release: boolToInt(_todoProvider.switchReleaseDay),
        releaseDay: _todoProvider.releaseDay,
        isSum: boolToInt(_todoProvider.switchIsSum),
        konyuZumi: boolToInt(_todoProvider.switchKonyuZumi),
        sortNo: await TodoController.getListCount(selectedId),
        isDelete: boolToInt(_todoProvider.isDelete),
        deleteDay: _todoProvider.deleteDay,
        groupId: selectedId,
        konyuDay: _todoProvider.konyuDay,
      );

      await TodoController.insertTodo(_todo);
    } else {
      // 修正
      var _todo = TodoStore(
        id: _todoProvider.id,
        title: _todoProvider.titleController.text,
        memo: _todoProvider.memoController.text,
        price: int.parse(_todoProvider.priceController.text),
        release: boolToInt(_todoProvider.switchReleaseDay),
        releaseDay: _todoProvider.releaseDay,
        isSum: boolToInt(_todoProvider.switchIsSum),
        konyuZumi: boolToInt(_todoProvider.switchKonyuZumi),
        sortNo: _todoProvider.sortNo,
        isDelete: boolToInt(_todoProvider.isDelete),
        deleteDay: _todoProvider.deleteDay,
        groupId: selectedId,
        konyuDay: _todoProvider.konyuDay,
      );

      await TodoController.updateTodo(_todo);
    }
    // await TodoController.insertTodo(_todo);
    // 前の画面に戻る
    Navigator.pop(context);
  }
}

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  final BannerAd myBanner = AdMobService().setBannerAd();

  @override
  Widget build(BuildContext context) {
    // final _todoProvider = context.watch<TodoProvider>();
    // final _formProvider = context.read<FormProvider>();

    // 広告の読み込み
    myBanner.load();
    final adWidget = AdWidget(ad: myBanner);

    return SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, _) {
          final _formProvider = ref.read(formProvider);
          final _todoProvider = ref.watch(todoProvider);
          return Container(
            // 余白をつける
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formProvider.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // グループリスト選択
                  const GroupTextButton(),
                  const SpaceBox.height(value: 1),
                  // タイトル
                  const TitleTextField(),
                  const SpaceBox.height(value: 1),
                  // 価格
                  const PriceTextField(),
                  const SpaceBox.height(value: 1),
                  // メモ
                  const MemoTextField(),
                  const SpaceBox.height(value: 1),

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
                            value: _todoProvider.switchIsSum,
                            title: const Text('計算対象に含める'),
                            onChanged: (bool value) {
                              _todoProvider.changeIsSum(value);
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
          );
        },
      ),
    );
  }
}
