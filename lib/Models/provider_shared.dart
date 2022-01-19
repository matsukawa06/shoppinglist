import '../Common/importer.dart';

class ProviderSharedPreferences with ChangeNotifier {
  var _isKonyuZumiView = false;
  get isKonyuZumiView => _isKonyuZumiView;

  void setKonyuZumiView(bool value) {
    _isKonyuZumiView = value;
    notifyListeners();
  }
}
