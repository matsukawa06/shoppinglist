import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/provider_store.dart';

class TitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStore = context.watch<ProviderStore>();
    return TextField(
      controller: providerStore.titleController,
      enabled: true,
      maxLength: 30,
      style: TextStyle(color: Colors.black),
      obscureText: false,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: 'タイトルを入力してください',
        enabledBorder: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
