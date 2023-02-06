import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedProvider = ChangeNotifierProvider<SharedPreferencesProvider>(
  (ref) => SharedPreferencesProvider(),
);

class SharedPreferencesProvider with ChangeNotifier {
  // 購入済を表示するか
  var isKonyuZumiView = false;

  void setKonyuZumiView(bool value) {
    isKonyuZumiView = value;
    notifyListeners();
  }

  // 選択中のグループID
  var selectedGroupId = 0;

  void setSelectedGroupId(int value) {
    selectedGroupId = value;
    notifyListeners();
  }

  final color = Colors.blue;

  ///
  /// ローカル設定を保存する
  ///
  Future saveIntValue(String key, int value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future saveBoolValue(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    // PackageInfo _packageInfo = await PackageInfo.fromPlatform();
  }

  Future saveStringValue(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // ///
  // /// ローカル設定を取得する
  // ///
  // Future getColor() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   var _prefsColor = prefs.getInt(COLOR_KEY) ?? 0xFF42A5F5;
  //   // _color = Colors(_prefsColor);
  // }
}
