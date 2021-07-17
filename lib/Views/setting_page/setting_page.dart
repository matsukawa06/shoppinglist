import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/provider_store.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prvSharedPreferences = context.watch<ProviderSharedPreferences>();
    // 設定の取得
    _restoreValues(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Container(
        // 余白をつける
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            SwitchListTile(
              value: prvSharedPreferences.isKonyuZumiView,
              title: Text('購入済みを表示する'),
              onChanged: (bool value) {
                prvSharedPreferences.setKonyuZumiView(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  _saveBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _restoreValues(BuildContext context) async {
    var provider = context.read<ProviderSharedPreferences>();
    var prefs = await SharedPreferences.getInstance();
    provider.setKonyuZumiView(prefs.getBool('konyuZumiView') ?? false);
  }
}
