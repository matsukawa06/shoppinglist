// ignore_for_file: file_names
import '../../Common/importer.dart';

class GroupTextButton extends StatelessWidget {
  const GroupTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _groupProvider = context.watch<GroupProvider>();
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
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
                  child: _groupList(context),
                ),
              );
            },
          );
        },
        child: Text(
          _groupProvider.selectedTitle + " ▼",
        ),
      ),
    );
  }
}

///
/// showModalBottomSheetの表示内容
///
Widget _groupList(BuildContext context) {
  final _groupProvider = context.read<GroupProvider>();
  return Column(
    children: [
      ListView(
        // shrinkWrap、physicsの記述が無いとエラーになる
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: _groupProvider.groupList.map(
          (GroupStore store) {
            return Container(
              key: Key(store.id.toString()),
              child: groupItem(context, store.id, store.title, store.color),
            );
          },
        ).toList(),
      ),
      const SpaceBox.height(value: 50),
    ],
  );
}
