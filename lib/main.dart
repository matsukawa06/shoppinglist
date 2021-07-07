import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'edit_page.dart';

void main() {
  // 最初に表示するWidget
  runApp(ShoppingList());
}

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoppingList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ja'),
      ],
    );
  }
}

// リスト一覧画面用Widget
class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('買い物リスト'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('テスト'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // "push"で新規画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面として編集用画面を指定
              return EditPage();
            }),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
