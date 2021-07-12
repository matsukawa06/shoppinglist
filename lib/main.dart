import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'Views/edit_page/edit_page.dart';
import 'Models/todo_store.dart';
import 'Models/provider_store.dart';

void main() {
  // 最初に表示するWidget
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderStore()),
      ],
      child: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListPage(),
      title: 'ShoppingList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
          future: context.read<ProviderStore>().initializeList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 非同期処理未完了 = 通信中
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  // 下に移動した場合
                  newIndex -= 1;
                }
                final TodoStore todoStore =
                    context.watch<ProviderStore>().todoList.removeAt(oldIndex);
              },
              children: context.watch<ProviderStore>().todoList.map(
                (TodoStore todo) {
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
                      context.read<ProviderStore>().delete(todo.id);
                    },
                    // 一覧に表示する内容
                    child: Card(
                      elevation: 2.0,
                      key: Key(todo.id.toString()),
                      child: ListTile(
                        title: Text(
                            '${todo.id.toString()} ${todo.title} sortNo:${todo.sortNo}'),
                        subtitle: Text('${todo.price.toString()} 円'),
                        onTap: () {
                          // 一覧をタップした時の詳細画面遷移
                          context.read<ProviderStore>().setRowInfo(todo);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EditPage();
                              },
                            ),
                          ).then(
                            (value) async {
                              // 画面遷移から戻ってきた時の処理
                              context.read<ProviderStore>().clearItems();
                              context.read<ProviderStore>().initializeList();
                            },
                          );
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
            MaterialPageRoute(
              builder: (context) {
                // 遷移先の画面として編集用画面を指定
                return EditPage();
              },
            ),
          ).then(
            (value) async {
              // 画面遷移から戻ってきた時の処理
              context.read<ProviderStore>().clearItems();
              context.read<ProviderStore>().initializeList();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
