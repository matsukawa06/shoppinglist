import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'Views/edit_page/edit_page.dart';
import 'Models/todo_store.dart';
import 'Models/provider_store.dart';
import 'Common/common_util.dart';

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
    int sumPrice = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('買い物リスト'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: context.read<ProviderStore>().initializeList(),
          builder: (context, snapshot) {
            final providerStore = context.watch<ProviderStore>();
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 非同期処理未完了 = 通信中
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // // 合計金額の算出
            // for (var i = 0; i < providerStore.todoList.length; i++) {
            //   providerStore.addPrice(providerStore.todoList[i].price);
            // }
            return Column(children: <Widget>[
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      // 下に移動した場合
                      newIndex -= 1;
                    }
                    final TodoStore todoStore =
                        providerStore.todoList.removeAt(oldIndex);

                    providerStore.todoList.insert(newIndex, todoStore);

                    // リストのソート番号を全件更新
                    for (var i = 0; i < providerStore.todoList.length; i++) {
                      if (providerStore.todoList[i].sortNo != i) {
                        // 登録されているソート番号が現在のインデックスと異なる場合更新
                        providerStore.updateSortNo(
                            providerStore.todoList[i].id, i);
                      }
                    }
                    context.read<ProviderStore>().initializeList();
                  },
                  children: providerStore.todoList.map(
                    (TodoStore todo) {
                      if (todo.sortNo == 0) {
                        sumPrice = 0;
                      }
                      sumPrice += todo.price;
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
                          // まずリストから削除する
                          providerStore.todoList.removeAt(todo.sortNo!);
                          // リストのソート番号を全件更新
                          for (var i = 0;
                              i < providerStore.todoList.length;
                              i++) {
                            if (providerStore.todoList[i].sortNo != i) {
                              // 登録されているソート番号が現在のインデックスと異なる場合更新
                              providerStore.updateSortNo(
                                  providerStore.todoList[i].id, i);
                            }
                          }
                          // スワイプ後に実行される削除処理
                          context.read<ProviderStore>().delete(todo.id);
                          context.read<ProviderStore>().initializeList();
                        },
                        // 一覧に表示する内容
                        child: Card(
                          elevation: 2.0,
                          key: Key(todo.id.toString()),
                          child: ListTile(
                            title: Text(
                                '${todo.id.toString()} ${todo.title} sortNo:${todo.sortNo}'),
                            subtitle: Text('${formatPrice(todo.price)} 円'),
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
                                  context
                                      .read<ProviderStore>()
                                      .initializeList();
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              // 合計金額表示
              Container(
                // 左寄せ
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 20,
                  bottom: 50,
                ),
                child: Text(
                  '合計：${formatPrice(sumPrice)} 円',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ]);
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
