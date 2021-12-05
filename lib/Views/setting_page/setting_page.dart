import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/provider_store.dart';
import '../../Common/common_util.dart';
import 'package:package_info/package_info.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SettingPage> {
  String _appName = "";
  String _packageName = "";
  String _version = "";
  String _buildNumber = "";

  _saveBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
  }

  _restoreValues(BuildContext context) async {
    var provider = context.read<ProviderSharedPreferences>();
    var prefs = await SharedPreferences.getInstance();
    provider.setKonyuZumiView(prefs.getBool('konyuZumiView') ?? false);
  }

  @override
  void initState() {
    _restoreValues(context);

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _appName = packageInfo.appName;
      _packageName = packageInfo.packageName;
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prvSharedPreferences = context.watch<ProviderSharedPreferences>();

    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Container(
        // 余白をつける
        padding: EdgeInsets.all(32),
        child:  Column(
              children: <Widget>[
                SwitchListTile(
                  value: prvSharedPreferences.isKonyuZumiView,
                  title: Text('購入済みを表示する'),
                  onChanged: (bool value) {
                    _saveBool('konyuZumiView', value);
                    prvSharedPreferences.setKonyuZumiView(value);
                  },
                ),
                SpaceBox.height(32),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () =>
                        showAboutDialog(
                          context: context,
                          applicationName: "買い物計画",
                          applicationVersion: _version,
                        ),
                  ),
                ),
              ],
            ),
        ),
      );

  }
}
