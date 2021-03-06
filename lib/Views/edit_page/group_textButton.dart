// ignore_for_file: file_names
import '../../Common/importer.dart';

class GroupTextButton extends StatelessWidget {
  const GroupTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerGroup = context.watch<ProviderGroup>();
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
          providerGroup.selectedTitle + " ▼",
        ),
      ),
    );
  }
}

///
/// showModalBottomSheetの表示内容
///
Widget _groupList(BuildContext context) {
  final providerGroup = context.read<ProviderGroup>();
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
              child: groupItem(context, store.id, store.title, store.color),
            );
          },
        ).toList(),
      ),
      const SpaceBox.height(value: 50),
    ],
  );
}
