import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/provider_store.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SettingPage> {
  _saveBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _restoreValues(BuildContext context) async {
    var provider = context.read<ProviderSharedPreferences>();
    var prefs = await SharedPreferences.getInstance();
    provider.setKonyuZumiView(prefs.getBool('konyuZumiView') ?? false);
  }

  @override
  void initState() {
    _restoreValues(context);
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
        child: Column(
          children: [
            SwitchListTile(
              value: prvSharedPreferences.isKonyuZumiView,
              title: Text('購入済みを表示する'),
              onChanged: (bool value) {
                _saveBool('konyuZumiView', value);
                prvSharedPreferences.setKonyuZumiView(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
