// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/Models/todo_provider.dart';

class MemoTextField extends ConsumerWidget {
  const MemoTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _todoProvider = ref.watch(todoProvider);
    return TextField(
      controller: _todoProvider.memoController,
      enabled: true,
      maxLength: 300,
      style: const TextStyle(color: Colors.black),
      obscureText: false,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'メモ',
        // hintText: 'メモを入力してください',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
