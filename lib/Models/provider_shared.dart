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

  var _color = Colors.blue;
  get color => _color;

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

  ///
  /// ローカル設定を取得する
  ///
  Future getColor() async {
    var prefs = await SharedPreferences.getInstance();
    var _prefsColor = prefs.getString(COLOR_KEY) ?? "";
    if (_prefsColor != "") {
      String valueColor = _prefsColor.split('(0x')[1].split(')')[0];
      _color = MaterialColor(int.parse(valueColor, radix: 16));
    }
  }
}
