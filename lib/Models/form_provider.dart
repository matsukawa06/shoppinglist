import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formProvider = ChangeNotifierProvider<FormProvider>(
  (ref) => FormProvider(),
);

class FormProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  bool formVallidate() {
    return formKey.currentState!.validate();
  }
}
