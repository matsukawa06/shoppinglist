///
/// アプリ設定ページ
///
import '../../Common/importer.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SettingPage> {
  // String _appName = "";
  // String _packageName = "";
  String _version = "";
  // String _buildNumber = "";

  _restoreValues(BuildContext context) async {
    var provider = context.read<ProviderSharedPreferences>();
    var prefs = await SharedPreferences.getInstance();
    provider.setKonyuZumiView(prefs.getBool(keyKonyuzumiView) ?? false);
  }

  @override
  void initState() {
    _restoreValues(context);

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // _appName = packageInfo.appName;
      // _packageName = packageInfo.packageName;
      _version = packageInfo.version;
      // _buildNumber = packageInfo.buildNumber;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prvShared = context.watch<ProviderSharedPreferences>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Container(
        // 余白をつける
        padding: const EdgeInsets.all(28),
        child: Column(
          children: <Widget>[
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.only(left: 10),
            //   child: Text(
            //     '各種設定',
            //   ),
            // ),
            Card(
              elevation: 5,
              child: SwitchListTile(
                value: prvShared.isKonyuZumiView,
                title: const Text('購入済みを表示する'),
                onChanged: (bool value) {
                  prvShared.saveBoolValue(keyKonyuzumiView, value);
                  prvShared.setKonyuZumiView(value);
                },
              ),
            ),
            const SpaceBox.height(value: 32),
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.only(left: 10),
            //   child: Text('情報'),
            // ),
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
                        applicationName: "買い物計画",
                        applicationVersion: "Ver. " + _version,
                      ),
                      child: const ListTile(
                        title: Text("アプリ情報"),
                      ),
                    ),
                  ),
                  // 利用規約
                  const InkWell(
                    onTap: _launchURL,
                    child: ListTile(
                      title: Text("利用規約・プライバシーポリシー"),
                    ),
                  ),
                ],
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
  const url = "https://naonari.com/kiyaku.html";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not Launch $url';
  }
}
