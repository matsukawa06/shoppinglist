// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/common/common_util.dart';
import 'package:shoppinglist/common/group_item.dart';
import 'package:shoppinglist/models/group_provider.dart';
import 'package:shoppinglist/models/group_store.dart';

class GroupTextButton extends StatelessWidget {
  const GroupTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _groupProvider = context.watch<GroupProvider>();
    return Consumer(
      builder: (context, ref, child) {
        final _groupProvider = ref.watch(groupProvider);
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
                    child: _GroupList(),
                  );
                },
              );
            },
            child: Text(
              _groupProvider.selectedTitle + " ▼",
            ),
          ),
        );
      },
    );
  }
}

///
/// showModalBottomSheetの表示内容
///
class _GroupList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListView(
          // shrinkWrap、physicsの記述が無いとエラーになる
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: ref.read(groupProvider).groupList.map(
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
}
// Widget _groupList(BuildContext context) {
//   final _groupProvider = context.read<GroupProvider>();
//   return Column(
//     children: [
//       ListView(
//         // shrinkWrap、physicsの記述が無いとエラーになる
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         children: _groupProvider.groupList.map(
//           (GroupStore store) {
//             return Container(
//               key: Key(store.id.toString()),
//               child: groupItem(context, store.id, store.title, store.color),
//             );
//           },
//         ).toList(),
//       ),
//       const SpaceBox.height(value: 50),
//     ],
//   );
// }
