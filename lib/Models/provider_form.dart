import '../Common/importer.dart';

class ProviderForm with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool formVallidate() {
    return formKey.currentState!.validate();
  }
}
