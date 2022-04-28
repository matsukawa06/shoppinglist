import '../Common/importer.dart';

class ProviderForm with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  // get formKey => _formKey;

  bool formVallidate() {
    return formKey.currentState!.validate();
  }
}
