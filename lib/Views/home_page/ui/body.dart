import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/Common/common_util.dart';
import 'package:shoppinglist/Models/group_provider.dart';
import 'package:shoppinglist/Models/todo_provider.dart';
import 'package:shoppinglist/Models/todo_store.dart';

import '../../edit_page/main.dart' as edit_page;
import 'grouplist_icon.dart';
import 'menulist_icon.dart';

///
/// メインページのbody部
///
class Body extends ConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(todoProvider).initializeList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 非同期処理未完了 = 通信中
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: <Widget>[
            // コンテンツ部
            _Content(),
            // フッター部
            _setFooter(ref),
            const SpaceBox.height(value: 20),
          ],
        );
      },
    );
  }
}

///
/// コンテンツ部クラス
///
class _Content extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      // ドラッグ＆ドロップできるListView
      child: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          // Todoの並び順を変更
          ref.read(todoProvider).changeSort(oldIndex, newIndex);
        },
        children: ref.watch(todoProvider).todoList.map(
          (TodoStore todo) {
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
                // 一旦todoListからデータを削除
                ref.read(todoProvider).todoList.removeAt(todo.sortNo!);
                // Todo削除処理
                _todoDelete(context, ref, todo);
              },
              //================================
              // 一覧に表示する内容
              //================================
              child: _ContentCard(todo: todo),
            );
          },
        ).toList(),
      ),
    );
  }

  /* Todoを削除する処理 */
  void _todoDelete(BuildContext context, WidgetRef ref, TodoStore _todo) {
    final _todoProvider = ref.read(todoProvider);
    bool _isDelete = true;
    // まずリストから削除する
    // _todoProvider.todoList.removeAt(_todo.sortNo!);
    // メッセージ表示
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            margin: const EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // これで両端によせる
                children: [
                  const Text(
                    '削除しました',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 再度DBからTodoを取得して、削除を無かったことにする
                      _todoProvider.initializeList();
                      _isDelete = false;
                    },
                    child: const Text(
                      '元に戻す',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
        .closed
        .then(
      (value) {
        if (_isDelete == true) {
          // 元に戻さなかった場合、DBからも削除する
          _todoProvider.todoDelete(_todo.id);
        }
      },
    );
  }
}

///
/// 一覧に表示するCardウィジェットのクラス
///
class _ContentCard extends ConsumerWidget {
  // 引数を受け取る（todoListの1件）
  final TodoStore todo;
  const _ContentCard({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            _todoCardTap(context, ref, todo);
          },
          // Cardに表示する部分
          child: _row(context, ref, todo),
        ),
      ),
    );
  }

  /* TodoカードTap処理 */
  void _todoCardTap(BuildContext context, WidgetRef ref, TodoStore _todo) {
    final _todoProvider = ref.read(todoProvider);

    // 一覧をタップした時の詳細画面遷移
    _todoProvider.setRowInfo(_todo);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const edit_page.Main();
        },
      ),
    ).then(
      (value) async {
        // 画面遷移から戻ってきた時の処理
        _todoProvider.clearItems();
        _todoProvider.initializeList();
      },
    );
  }

  /* Cardに表示する部分 */
  Widget _row(BuildContext context, WidgetRef ref, TodoStore todo) {
    return Row(
      children: <Widget>[
        // 購入対象アイコン
        InkWell(
          onTap: () {
            // 計算対象区分の更新処理
            ref.read(todoProvider).updateIsSum(todo);
          },
          child: SizedBox(
            width: 60,
            child: Icon(
              todo.isSum == 1
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined,
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
                    _konyuZumiOnOff(context, ref, todo);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /* 日付を画面表示用の文字列に変換 */
  String stringDay(TodoStore _todo) {
    if (intToBool(_todo.konyuZumi) == true) {
      return '${dateToString(_todo.konyuDay)} 購入';
    } else {
      return _todo.release == 1 ? '${dateToString(_todo.releaseDay)} 発売' : '';
    }
  }

  /* 購入済のチェックON/OFFの処理 */
  void _konyuZumiOnOff(BuildContext context, WidgetRef ref, TodoStore todo) {
    final _todoProvider = ref.read(todoProvider);

    _todoProvider.updateKonyuZumi(
        todo.id, intToBool(todo.konyuZumi) ? false : true);
    _todoProvider.initializeList();
    if (intToBool(todo.konyuZumi) == false) {
      // メッセージ表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: 60,
            child: const Text(
              '購入済みに変更しました',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }
}

///
/// フッター表示
///
Widget _setFooter(WidgetRef ref) {
  final _todoProvider = ref.read(todoProvider);
  return Stack(
    children: [
      // 合計金額表示
      Consumer(
        builder: (context, ref, child) {
          return Container(
            color: ref.watch(groupProvider).primarySwatch,
            // 左寄せ
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                '合計：${formatPrice(_todoProvider.totalPrice)} 円',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: ref.watch(groupProvider).fontColor,
                ),
              ),
            ),
          );
        },
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
