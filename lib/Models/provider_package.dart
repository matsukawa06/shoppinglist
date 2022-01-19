import '../Common/importer.dart';

class ProviderPackage with ChangeNotifier {
  PackageInfo? _packageInfo;
  get packageInfo => _packageInfo;

  Future<void> getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }
}
