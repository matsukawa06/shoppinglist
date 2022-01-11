import '../../Common/importer.dart';

import 'package:shoppinglist/Views/setting_page/setting_page.dart';
import '../edit_page/edit_page.dart';

// ignore: camel_case_types
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('買い物計画リスト'),
      // 右側ボタン
      actions: [
        IconButton(
          onPressed: () {
            // "push"で新規画面に遷移
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  // 遷移先の画面として編集用画面を指定
                  return EditPage();
                },
              ),
            ).then(
              (value) async {
                // 画面遷移から戻ってきた時の処理
                context.read<ProviderStore>().clearItems();
                context.read<ProviderStore>().initializeList();
              },
            );
          },
          icon: Icon(Icons.add),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SettingPage();
                },
              ),
            ).then(
              (value) async {
                // 画面遷移から戻ってきた時の処理
                context.read<ProviderStore>().clearItems();
                context.read<ProviderStore>().initializeList();
              },
            );
          },
          icon: Icon(
            Icons.settings, //dehaze_sharp,
            size: 30,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
