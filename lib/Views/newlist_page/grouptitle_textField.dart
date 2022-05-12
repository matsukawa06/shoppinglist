// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/Models/group_provider.dart';

class GroupTitleTextField extends ConsumerWidget {
  const GroupTitleTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _groupProvider = ref.watch(groupProvider);
    return TextFormField(
      // 入力エリアのセレクトアクション（コピペ、選択、削除など）の有効、無効
      enableInteractiveSelection: true,
      controller: _groupProvider.titleController,
      enabled: true,
      maxLength: 15,
      style: const TextStyle(color: Colors.black),
      // 入力内容のマスク表示の切り替え
      obscureText: false,
      maxLines: 1,
      decoration: const InputDecoration(
        labelText: 'リスト名',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      validator: (String? value) {
        return value!.isEmpty ? 'リスト名を入力してください' : null;
      },
    );
  }
}
