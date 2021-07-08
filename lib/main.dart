import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'edit_page.dart';
import 'dbManager.dart';

// ChangeNotifierを継承すると変更可能なデータを渡せる
class TodoListState with ChangeNotifier {
  List<Todo> _todoList = [];

  Future<void> initializeList() async {
    _todoList = await Todo.getTodos();
    notifyListeners();
  }
}

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
      home: ChangeNotifierProvider(
        create: (context) => TodoListState(),
        child: ListPage(),
      ),
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
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: context.read<TodoListState>().initializeList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 非同期処理未完了 = 通信中
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: context.read<TodoListState>()._todoList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Text(
                      'ID ${context.read<TodoListState>()._todoList[index].id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                        '${context.read<TodoListState>()._todoList[index].title}'),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // "push"で新規画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面として編集用画面を指定
              return EditPage();
            }),
          ).then((value) async {
            // 画面遷移から戻ってきた時の処理
            context.read<TodoListState>().initializeList();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
