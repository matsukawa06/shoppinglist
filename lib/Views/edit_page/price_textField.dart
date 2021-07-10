import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/provider_store.dart';

class PriceTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStore = context.watch<ProviderStore>();
    return TextField(
      controller: providerStore.priceController,
      enabled: true,
      // maxLength: 8,
      style: TextStyle(color: Colors.black),
      // obscureText: false,
      decoration: InputDecoration(
        hintText: '価格を入力してください',
        enabledBorder: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
