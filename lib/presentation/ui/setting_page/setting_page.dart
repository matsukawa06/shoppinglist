///
/// アプリ設定ページ
///
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppinglist/common/common_const.dart';
import 'package:shoppinglist/common/common_util.dart';
import 'package:shoppinglist/presentation/controllers/group_controller.dart';
import 'package:shoppinglist/presentation/controllers/todo_controller.dart';
import 'package:shoppinglist/models/group_provider.dart';
import 'package:shoppinglist/models/shared_provider.dart';
import 'package:shoppinglist/models/todo_provider.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  final String _version = '';
//   @override
//   State<StatefulWidget> createState() {
//     return _State();
//   }
// }

// class _State extends State<SettingPage> {
//   // String _appName = "";
//   // String _packageName = "";
//   String _version = '';
//   // String _buildNumber = "";

  _restoreValues(WidgetRef ref) async {
    var prefs = await SharedPreferences.getInstance();
    ref
        .read(sharedProvider)
        .setKonyuZumiView(prefs.getBool(keyKonyuzumiView) ?? false);
  }

//   @override
//   void initState() {
//     _restoreValues(context);

//     PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//       // _appName = packageInfo.appName;
//       // _packageName = packageInfo.packageName;
//       _version = packageInfo.version;
//       // _buildNumber = packageInfo.buildNumber;
//     });

//     super.initState();
//   }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _sharedProvider = ref.watch(sharedProvider);
    _restoreValues(ref);
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Container(
        // 余白をつける
        padding: const EdgeInsets.all(28),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              child: SwitchListTile(
                value: _sharedProvider.isKonyuZumiView,
                title: const Text('購入済みを表示する'),
                onChanged: (bool value) {
                  _sharedProvider.saveBoolValue(keyKonyuzumiView, value);
                  _sharedProvider.setKonyuZumiView(value);
                },
              ),
            ),
            const SpaceBox.height(value: 32),
            Card(
              elevation: 5, // 影のサイズ
              child: Column(
                children: [
                  // アプリ情報
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: '買い物計画',
                        applicationVersion: 'Ver. ' + _version,
                      ),
                      child: const ListTile(
                        title: Text('アプリ情報'),
                      ),
                    ),
                  ),
                  // 利用規約
                  const InkWell(
                    onTap: _launchURL,
                    child: ListTile(
                      title: Text('利用規約・プライバシーポリシー'),
                    ),
                  ),
                ],
              ),
            ),
            const SpaceBox.height(value: 32),
            Card(
              elevation: 5, // 影のサイズ
              child: InkWell(
                child: const ListTile(
                  title: Text('データ初期化'),
                ),
                onTap: () {
                  _allDataInit(context, ref);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// 利用規約のページをブラウザで表示する
///
void _launchURL() async {
  const url = 'https://naonari.com/kiyaku.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not Launch $url';
  }
}

///
/// 全データ初期化処理
/// リスト・グループを全て削除する
///
Future _allDataInit(BuildContext context, WidgetRef ref) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('確認'),
        content: SizedBox(
          height: 90,
          child: Column(
            children: const [
              Text('全てのデータを削除します。よろしいですか？'),
              Text(
                'この操作は取り消しできません。',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('いいえ'),
            onPressed: () => Navigator.of(context).pop(0),
          ),
          // const SpaceBox.width(value: 12),
          TextButton(
            child: const Text('はい'),
            onPressed: () {
              TodoController.deleteAll();
              GroupController.deleteAll();
              ref.read(groupProvider).initializeList();
              ref.read(todoProvider).initializeList();
              Navigator.of(context).pop(0);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  margin: const EdgeInsets.all(20),
                  behavior: SnackBarBehavior.floating,
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      '全てのデータを削除しました',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
