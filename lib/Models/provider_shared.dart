import '../Common/importer.dart';

class ProviderSharedPreferences with ChangeNotifier {
  // 購入済を表示するか
  var _isKonyuZumiView = false;
  get isKonyuZumiView => _isKonyuZumiView;

  void setKonyuZumiView(bool value) {
    _isKonyuZumiView = value;
    notifyListeners();
  }

  // 選択中のグループID
  var _selectedGroupId = 0;
  get selectedGroupId => _selectedGroupId;

  void setSelectedGroupId(int value) {
    _selectedGroupId = value;
    notifyListeners();
  }

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
}
