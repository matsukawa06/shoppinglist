// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/Models/todo_provider.dart';

class PriceTextField extends ConsumerWidget {
  const PriceTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: ref.watch(todoProvider).priceController,
      enabled: true,
      maxLength: 8,
      style: const TextStyle(color: Colors.black),
      obscureText: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      decoration: const InputDecoration(
        labelText: '価格',
        // hintText: '価格を入力してください',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      validator: (String? value) {
        return value!.isEmpty ? '価格を入力してください' : null;
      },
    );
  }
}
