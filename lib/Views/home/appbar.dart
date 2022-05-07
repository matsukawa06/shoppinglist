import '../../Common/importer.dart';

import 'package:shoppinglist/Views/setting_page/setting_page.dart';
import '../edit_page/main.dart' as edit_page;

///
/// メインページのAppBar設定
///
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerGroup = context.watch<ProviderGroup>();

    return FutureBuilder(
      future: providerGroup.getSelectedInfo(),
      builder: (context, snapshot) {
        return AppBar(
          // タイトル
          title: Text(providerGroup.selectedTitle),
          // 右側ボタン
          actions: [
            // 新規追加アイコン
            _newAddIcon(context),
            // 設定画面遷移アイコン
            _settingIcon(context),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

///
/// 新規追加アイコン
/// 新規登録ページへ遷移する
Widget _newAddIcon(BuildContext context) {
  return IconButton(
    onPressed: () {
      // "push"で新規画面に遷移
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            // 遷移先の画面として編集用画面を指定
            return const edit_page.Main();
          },
        ),
      ).then(
        (value) async {
          // 画面遷移から戻ってきた時の処理
          context.read<ProviderTodo>().clearItems();
          context.read<ProviderTodo>().initializeList();
        },
      );
    },
    icon: const Icon(Icons.add),
  );
}

///
/// 設定アイコン
/// 設定画面へ遷移する
Widget _settingIcon(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const SettingPage();
          },
        ),
      ).then(
        (value) async {
          // 画面遷移から戻ってきた時の処理
          context.read<ProviderTodo>().clearItems();
          context.read<ProviderTodo>().initializeList();
        },
      );
    },
    icon: const Icon(
      Icons.settings, //dehaze_sharp,
      size: 30,
    ),
  );
}
