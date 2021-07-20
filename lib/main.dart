import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shoppinglist/Views/setting_page/setting_page.dart';
import 'package:shoppinglist/services/admob.dart';
import 'Views/edit_page/edit_page.dart';
import 'Models/todo_store.dart';
import 'Models/provider_store.dart';
import 'Common/common_util.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  // AdMob 用のプラグイン初期化
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  // 最初に表示するWidget
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderStore()),
        ChangeNotifierProvider(create: (_) => ProviderSharedPreferences()),
        ChangeNotifierProvider(create: (_) => ProviderForm()),
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
        title: Text('買い物計画リスト'),
        // 右側ボタン
        actions: [
          IconButton(
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
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SettingPage();
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
            icon: Icon(
              Icons.settings, //dehaze_sharp,
              size: 30,
            ),
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: context.read<ProviderStore>().initializeList(),
          builder: (context, snapshot) {
            final providerStore = context.watch<ProviderStore>();
            // 合計金額初期化
            sumPrice = 0;
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 非同期処理未完了 = 通信中
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: <Widget>[
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
                      updateSortNo(context);
                      context.read<ProviderStore>().initializeList();
                    },
                    children: providerStore.todoList.map(
                      (TodoStore todo) {
                        // 合計金額に明細の金額を加算
                        if (todo.isSum == 1) {
                          sumPrice += todo.price;
                        }
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
                            // DBからも削除
                            context.read<ProviderStore>().delete(todo.id);
                            // リストのソート番号を全件更新
                            updateSortNo(context);
                            // スワイプ後に実行される削除処理
                            context.read<ProviderStore>().initializeList();
                          },
                          // 一覧に表示する内容
                          child: Card(
                            // margin: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 4,
                              bottom: 4,
                            ),
                            elevation: 2.0,
                            key: Key(todo.id.toString()),
                            child: SizedBox(
                              height: 70,
                              child: InkWell(
                                onTap: () {
                                  // 一覧をタップした時の詳細画面遷移
                                  context
                                      .read<ProviderStore>()
                                      .setRowInfo(todo);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return EditPage();
                                      },
                                    ),
                                  ).then(
                                    (value) async {
                                      // 画面遷移から戻ってきた時の処理
                                      context
                                          .read<ProviderStore>()
                                          .clearItems();
                                      context
                                          .read<ProviderStore>()
                                          .initializeList();
                                    },
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        context
                                            .read<ProviderStore>()
                                            .updateIsSum(
                                                todo.id,
                                                intToBool(todo.isSum)
                                                    ? false
                                                    : true);
                                        context
                                            .read<ProviderStore>()
                                            .initializeList();
                                      },
                                      child: SizedBox(
                                        width: 60,
                                        child: Icon(
                                          isSumIcon(todo.isSum),
                                          size: 45,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 250,
                                          height: 40,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${todo.title}',
                                              style: TextStyle(fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 100,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${formatPrice(todo.price)} 円',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    strReleaseDay(todo.release,
                                                        todo.releaseDay),
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Checkbox(
                                        activeColor: Colors.blue,
                                        value: intToBool(todo.konyuZumi),
                                        onChanged: (bool? value) {
                                          context
                                              .read<ProviderStore>()
                                              .updateKonyuZumi(
                                                  todo.id,
                                                  intToBool(todo.konyuZumi)
                                                      ? false
                                                      : true);
                                          context
                                              .read<ProviderStore>()
                                              .initializeList();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                // 合計金額表示
                Container(
                  color: Colors.blue.shade600,
                  // 左寄せ
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  // margin: EdgeInsets.only(
                  //   left: 20,
                  //   bottom: 35,
                  // ),
                  child: Center(
                    child: Text(
                      '合計：${formatPrice(sumPrice)} 円',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // 広告表示
                AdmobBanner(
                  adUnitId: AdMobService().getBannerAdUnitId()!,
                  adSize: AdmobBannerSize(
                    width: MediaQuery.of(context).size.width.toInt(),
                    height: AdMobService().getHeight(context).toInt(),
                    name: 'SMART_BANNER',
                  ),
                ),
                SpaceBox.height(20),
              ],
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // "push"で新規画面に遷移
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) {
      //           // 遷移先の画面として編集用画面を指定
      //           return EditPage();
      //         },
      //       ),
      //     ).then(
      //       (value) async {
      //         // 画面遷移から戻ってきた時の処理
      //         context.read<ProviderStore>().clearItems();
      //         context.read<ProviderStore>().initializeList();
      //       },
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

void updateSortNo(BuildContext context) {
  final providerStore = context.read<ProviderStore>();

  // リストのソート番号を全件更新
  for (var i = 0; i < providerStore.todoList.length; i++) {
    if (providerStore.todoList[i].sortNo != i) {
      // 登録されているソート番号が現在のインデックスと異なる場合更新
      providerStore.updateSortNo(providerStore.todoList[i].id, i);
    }
  }
}

IconData isSumIcon(int value) {
  return value == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined;
}

String strReleaseDay(int isRelease, DateTime value) {
  return isRelease == 1 ? '${dateToString(value)} 発売' : '';
}

IconData konyuZumiIcon(int value) {
  return value == 1 ? Icons.check_box : Icons.check_box_outline_blank;
}
