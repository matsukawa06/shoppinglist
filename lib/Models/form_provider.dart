import '../Common/importer.dart';

class FormProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool formVallidate() {
    return formKey.currentState!.validate();
  }
}
