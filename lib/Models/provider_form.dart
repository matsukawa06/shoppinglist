import '../Common/importer.dart';

class ProviderForm with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;

  bool formVallidate() {
    return _formKey.currentState!.validate();
  }
}
