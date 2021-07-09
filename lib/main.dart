import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'edit_page.dart';
import 'dbManager.dart';

// ChangeNotifierを継承すると変更可能なデータを渡せる
class TodoListState with ChangeNotifier {
  List<Todo> _todoList = [];

  Future<void> initializeList() async {
    _todoList = await Todo.getAllTodos();
    notifyListeners();
  }

  Future<void> delete(int? id) async {
    Todo.deleteTodo(id!);
  }
}

void main() {
  // 最初に表示するWidget
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
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
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) {},
              children: context.read<TodoListState>()._todoList.map(
                (Todo todo) {
                  return Dismissible(
                    key: Key(todo.id.toString()),
                    background: Container(
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      // スワイプ後に実行される削除処理
                      context.read<TodoListState>().delete(todo.id);
                    },
                    // 一覧に表示する内容
                    child: Card(
                      elevation: 2.0,
                      key: Key(todo.id.toString()),
                      child: ListTile(
                        title: Text(todo.title),
                        subtitle: Text('${todo.price.toString()} 円'),
                        onTap: () {
                          // 一覧をタップした時の詳細画面遷移
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
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
