///
/// メインページのbody部
///
import '../../Common/importer.dart';

import '../edit_page/main.dart' as edit_page;
import '../home/grouplist_icon.dart';
import '../home/menulist_icon.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ProviderTodo>().initializeList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 非同期処理未完了 = 通信中
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: <Widget>[
            // ColumnやRowの空いたスペースをレスポンシブに埋める
            Expanded(
              // ドラッグ＆ドロップできるListView
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  // Todoの並び順を変更
                  _changeSort(context, oldIndex, newIndex);
                },
                children: context.watch<ProviderTodo>().todoList.map(
                  (TodoStore todo) {
                    // // 合計金額計算処理
                    // _calculationPrice(context, todo);
                    return Dismissible(
                      key: Key(todo.id.toString()),
                      background: Container(
                        padding: const EdgeInsets.only(right: 10),
                        alignment: AlignmentDirectional.centerEnd,
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // Todo削除処理
                        _todoDelete(context, todo);
                      },
                      //================================
                      // 一覧に表示する内容
                      //================================
                      child: _bodyCard(context, todo),
                    );
                  },
                ).toList(),
              ),
            ),
            //================================
            // フッター
            //================================
            // _setFooter(context.read<ProviderTodo>().sumPrice),
            _setFooter(context),
            const SpaceBox.height(value: 20),
          ],
        );
      },
    );
  }
}

///
/// 一覧に表示するCardウィジェットの作成
///
Widget _bodyCard(BuildContext context, TodoStore todo) {
  return Card(
    margin: const EdgeInsets.symmetric(
      vertical: 4, // 上下
      horizontal: 8, // 左右
    ),
    elevation: 5.0,
    key: Key(todo.id.toString()),
    child: SizedBox(
      height: 70,
      child: InkWell(
        onTap: () {
          // Todoの編集画面へ遷移する処理
          _todoCardTap(context, todo);
        },
        child: Row(
          children: <Widget>[
            // 購入対象アイコン
            InkWell(
              onTap: () {
                _isSumIconTap(context, todo);
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
                // １カードの１行目
                // タイトル
                SizedBox(
                  width: 250,
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      todo.title,
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // １カードの２行目
                SizedBox(
                  height: 20,
                  child: Row(
                    children: <Widget>[
                      // 価格
                      SizedBox(
                        width: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${formatPrice(todo.price)} 円',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      // 発売日又は購入日
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            stringDay(todo),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // 購入済チェック
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  const SpaceBox.height(value: 5),
                  const SizedBox(
                    height: 17,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text("購入"),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.5, // 1.5倍  checkboxのサイズ変更
                    child: Checkbox(
                      activeColor: Colors.blue,
                      value: intToBool(todo.konyuZumi),
                      onChanged: (bool? value) {
                        // 購入済のチェックON/OFF処理
                        _konyuZumiOnOff(context, todo);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

///
/// 購入済のチェックON/OFFの処理
///
void _konyuZumiOnOff(BuildContext context, TodoStore todo) {
  final providerTodo = context.read<ProviderTodo>();

  providerTodo.updateKonyuZumi(
      todo.id, intToBool(todo.konyuZumi) ? false : true);
  providerTodo.initializeList();
  if (intToBool(todo.konyuZumi) == false) {
    // メッセージ表示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('購入済みに変更しました'),
      ),
    );
  }
}

///
/// Todo画面の上の並びを変更する処理
///
void _changeSort(BuildContext context, int oldIndex, int newIndex) {
  final store = context.read<ProviderTodo>();

  if (oldIndex < newIndex) {
    // 下に移動した場合
    newIndex -= 1;
  }
  final TodoStore todoStore = store.todoList.removeAt(oldIndex);

  store.todoList.insert(newIndex, todoStore);

  // リストのソート番号を全件更新
  updateSortNo(context);
  store.initializeList();
}

///
/// Todoを削除する処理
///
void _todoDelete(BuildContext context, TodoStore todo) {
  final store = context.read<ProviderTodo>();
  bool _isDelete = true;
  // まずリストから削除する
  store.todoList.removeAt(todo.sortNo!);
  // メッセージ表示
  ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          // 角を丸くする
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width.toDouble(),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // これで両端によせる
              children: [
                const Text('削除しました'),
                ElevatedButton(
                  onPressed: () {
                    // 再度DBからTodoを取得して、削除を無かったことにする
                    store.initializeList();
                    _isDelete = false;
                  },
                  child: const Text('元に戻す'),
                )
              ],
            ),
          ),
        ),
      )
      .closed
      .then((value) {
    if (_isDelete == true) {
      // 元に戻さなかった場合、DBからも削除する
      store.delete(todo.id);
      // リストのソート番号を全件更新
      updateSortNo(context);
      // スワイプ後に実行される削除処理
      store.initializeList();
    }
  });
}

///
/// DBのTodoのソート番号を更新する処理
///
void updateSortNo(BuildContext context) {
  final store = context.read<ProviderTodo>();

  // リストのソート番号を全件更新
  for (var i = 0; i < store.todoList.length; i++) {
    if (store.todoList[i].sortNo != i) {
      // 登録されているソート番号が現在のインデックスと異なる場合更新
      store.updateSortNo(store.todoList[i].id, i);
    }
  }
}

///
/// TodoカードTap処理
///
void _todoCardTap(BuildContext context, TodoStore todo) {
  final store = context.read<ProviderTodo>();

  // 一覧をタップした時の詳細画面遷移
  store.setRowInfo(todo);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return const edit_page.Main();
      },
    ),
  ).then(
    (value) async {
      // 画面遷移から戻ってきた時の処理
      store.clearItems();
      store.initializeList();
    },
  );
}

///
/// 購入対象アイコン表示処理
///
IconData isSumIcon(int value) {
  return value == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined;
}

///
/// 購入対象アイコンTap処理
///
void _isSumIconTap(BuildContext context, TodoStore todo) {
  final providerTodo = context.read<ProviderTodo>();
  providerTodo.updateIsSum(
    todo.id,
    intToBool(todo.isSum) ? false : true,
  );
  providerTodo.initializeList();
}

///
/// フッター表示
///
Widget _setFooter(BuildContext context) {
  final _groupProvider = context.watch<ProviderGroup>();
  final _todoProvider = context.read<ProviderTodo>();
  return Stack(
    children: [
      // 合計金額表示
      Container(
        color: _groupProvider.primarySwatch,
        // 左寄せ
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            '合計：${formatPrice(_todoProvider.sumPrice)} 円',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: context.watch<ProviderGroup>().fontColor,
            ),
          ),
        ),
      ),
      // グループリストアイコン
      const Align(
        alignment: Alignment.centerLeft,
        child: GroupListIcon(),
      ),
      // メニューアイコン
      const Align(
        alignment: Alignment.centerRight,
        child: MenuListIcon(),
      ),
    ],
  );
}

String stringDay(TodoStore todo) {
  if (intToBool(todo.konyuZumi) == true) {
    return '${dateToString(todo.konyuDay)} 購入';
  } else {
    return todo.release == 1 ? '${dateToString(todo.releaseDay)} 発売' : '';
  }
}

// String strReleaseDay(int isRelease, DateTime value) {
//   return isRelease == 1 ? '${dateToString(value)} 発売' : '';
// }

IconData konyuZumiIcon(int value) {
  return value == 1 ? Icons.check_box : Icons.check_box_outline_blank;
}
