import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppinglist/common/common_const.dart';
import 'package:shoppinglist/common/common_util.dart';
import 'package:shoppinglist/models/group_provider.dart';
import 'package:shoppinglist/models/shared_provider.dart';
import 'package:shoppinglist/models/todo_provider.dart';
import 'package:shoppinglist/presentation/controllers/group_controller.dart';
import 'package:shoppinglist/presentation/controllers/todo_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  _restoreValues(WidgetRef ref) async {
    var prefs = await SharedPreferences.getInstance();
    ref.read(sharedProvider).setKonyuZumiView(prefs.getBool(keyKonyuzumiView) ?? false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _restoreValues(ref);
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Container(
        // 余白をつける
        padding: const EdgeInsets.all(28),
        child: FutureBuilder<PackageInfo>(
          future: _getPackageInfo(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            if (snapshot.hasError) {
              return const Text('ERROR');
            } else if (!snapshot.hasData) {
              return const Text('Loading...');
            }
            final data = snapshot.data!;
            return Column(
              children: <Widget>[
                // App設定
                _appSettings(ref),
                const SpaceBox.height(value: 32),
                // App共有・評価
                _appShare(context),
                const SpaceBox.height(value: 32),
                // App情報
                _appInfo(context, data),

                // その他のアプリ
                _appOther(context),
                const SpaceBox.height(value: 32),
                // データ初期化
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
            );
          },
        ),
      ),
    );
  }

  /// App設定
  Widget _appSettings(WidgetRef ref) {
    final _sharedProvider = ref.watch(sharedProvider);
    return Card(
      elevation: 5,
      child: SwitchListTile(
        value: _sharedProvider.isKonyuZumiView,
        title: const Text('購入済みを表示する'),
        onChanged: (bool value) {
          _sharedProvider.saveBoolValue(keyKonyuzumiView, value);
          _sharedProvider.setKonyuZumiView(value);
        },
      ),
    );
  }

  /// App共有・評価
  Widget _appShare(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          // シェアする
          InkWell(
            child: const ListTile(
              title: Text('シェアする'),
              leading: Icon(Icons.share),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            onTap: () async => _share(context),
          ),
          // 評価する
          InkWell(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: const ListTile(
                title: Text('評価する'),
                leading: Icon(Icons.star),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            onTap: () => _review(),
          ),
        ],
      ),
    );
  }

  /// シェアするタップ処理
  void _share(BuildContext context) async {
    // final box = context.findRenderObject() as RenderBox?;
    await Share.share('https://apple.co/3X3IDPb', subject: '買い物計画リスト');
  }

  /// 評価するタップ処理
  void _review() async {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(appStoreId: '1596917066', microsoftStoreId: '');
  }

  /// App情報
  Widget _appInfo(BuildContext context, PackageInfo data) {
    return Card(
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
                applicationVersion: 'Ver. ${data.version}',
              ),
              child: const ListTile(
                title: Text('アプリ情報'),
              ),
            ),
          ),
          // 利用規約
          InkWell(
            onTap: () async => _launchURL('https://naonari.com/kiyaku.html'),
            child: const ListTile(
              title: Text('利用規約・プライバシーポリシー'),
            ),
          ),
        ],
      ),
    );
  }
}

///
/// 利用規約のページをブラウザで表示する
///
void _launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not Launch $url';
  }
}

/// その他のアプリ
Widget _appOther(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
    margin: EdgeInsets.only(top: size.height * 0.05),
    child: Column(
      children: [
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: size.width * 0.03),
            alignment: Alignment.centerLeft,
            child: const Text('開発者の他のアプリ')),
        Card(
          elevation: 5,
          child: Column(
            children: [
              // カウントダウンリスト
              InkWell(
                onTap: () => _launchURL('https://apple.co/3WQVwMv'),
                child: ListTile(
                  leading: _appIcon(context, 'images/countdown.png'),
                  title: const Text('カウントダウンリスト'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// アプリのアイコンをサイズ指定して返す
Widget _appIcon(BuildContext context, String imagePath) {
  final size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width * 0.1,
    height: size.height * 0.1,
    child: Image.asset(imagePath),
  );
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
              Text('この操作は取り消しできません。', style: TextStyle(color: Colors.red))
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
