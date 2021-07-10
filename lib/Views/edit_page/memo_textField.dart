import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/provider_store.dart';

class MemoTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStore = context.watch<ProviderStore>();
    return TextField(
      controller: providerStore.memoController,
      enabled: true,
      maxLength: 300,
      style: TextStyle(color: Colors.black),
      obscureText: false,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'メモを入力してください',
        enabledBorder: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
