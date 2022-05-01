import '../../Common/importer.dart';
import '../newlist_page/main.dart';

///
/// グループリスト
///
class GroupListIcon extends StatelessWidget {
  const GroupListIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ProviderGroup>().initializeList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 非同期処理未完了 = 処理中
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return IconButton(
          icon: const Icon(Icons.menu),
          color: context.watch<ProviderGroup>().fontColor,
          iconSize: 40,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: _groupList(context),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

///
/// showModalBottomSheetの表示内容
///
Widget _groupList(BuildContext context) {
  final providerGroup = context.watch<ProviderGroup>();
  return Column(
    children: [
      ListView(
        // shrinkWrap、physicsの記述が無いとエラーになる
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: providerGroup.groupList.map(
          (GroupStore store) {
            return Container(
              key: Key(store.id.toString()),
              child: groupItem(context, store.id, store.title),
            );
          },
        ).toList(),
      ),
      _groupItemAdd(context, "リストを新しく作成"),
    ],
  );
}

///
/// リストを新規作成する画面へ遷移するアイテム
///
Widget _groupItemAdd(BuildContext context, String title) {
  final store = context.read<ProviderGroup>();

  return Container(
    margin: const EdgeInsets.only(bottom: 25),
    height: 60.0,
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(
          width: 0.8,
          color: Colors.grey,
        ),
      ),
    ),
    child: InkWell(
      onTap: () async {
        if (store.groupList.length > maxGroupListCount) {
          // グループリストの最大件数を超えている場合、更新画面に遷移させない
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("エラー"),
                content: const Text("リスト最大件数を超えるため\nこれ以上追加できません。"),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(0),
                  )
                ],
              );
            },
          );
          // print("dialog result: $result");
          Navigator.pop(context);
        } else {
          // "push"で新規画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                // 遷移先の画面として編集用画面を指定
                return const ListEditPage(modeInsert);
              },
            ),
          ).then(
            (value) async {
              // storeの初期化
              context.read<ProviderGroup>().clearItems();
              // グループリストの再読み込み
              context.read<ProviderGroup>().initializeList();
              // ToDoリストも再読み込みする
              context.read<ProviderTodo>().initializeList();
              // メニューリストを閉じる
              Navigator.pop(context);
            },
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(left: 15.0)),
          const Icon(Icons.add),
          const Padding(padding: EdgeInsets.only(left: 15.0)),
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
  );
}
