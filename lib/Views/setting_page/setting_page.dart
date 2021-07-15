import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bool = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Container(
        // 余白をつける
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            SwitchListTile(
              value: _bool,
              title: Text('購入済みを表示する'),
              onChanged: (bool value) {
                //providerStore.changeIsSum(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
