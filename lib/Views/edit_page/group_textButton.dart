import '../../Common/importer.dart';

class GroupTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerGroup = context.watch<ProviderGroup>();
    return Container(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600.0),
                child: _menuList(context),
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
Widget _menuList(BuildContext context) {
  final providerGroup = context.read<ProviderGroup>();
  return Column(
    children: [
      ListView(
        // shrinkWrap、physicsの記述が無いとエラーになる
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: providerGroup.groupList.map(
          (GroupStore store) {
            return Container(
              key: Key(store.id.toString()),
              child: menuItem(context, store.id, store.title),
            );
          },
        ).toList(),
      ),
    ],
  );
}
