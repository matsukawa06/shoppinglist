// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shoppinglist/models/group_provider.dart';
// import 'package:shoppinglist/models/todo_provider.dart';
// import 'package:shoppinglist/presentation/ui/setting_page/setting_page.dart';

// import '../edit_page/edit_page.dart';

// ///
// /// メインページのAppBar設定
// ///
// class MyAppBar extends ConsumerWidget with PreferredSizeWidget {
//   const MyAppBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _groupProvider = ref.watch(groupProvider);

//     return FutureBuilder(
//       future: _groupProvider.getSelectedInfo(),
//       builder: (context, snapshot) {
//         return AppBar(
//           // タイトル
//           title: Text(_groupProvider.selectedTitle),
//           // 右側ボタン
//           actions: [
//             // 新規追加アイコン
//             _NewAddIcon(),
//             // 設定画面遷移アイコン
//             _SettingIcon(),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// ///
// /// 新規追加アイコン
// /// 新規登録ページへ遷移する
// class _NewAddIcon extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _todoProvider = ref.read(todoProvider);
//     return IconButton(
//       onPressed: () {
//         // "push"で新規画面に遷移
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) {
//               // 遷移先の画面として編集用画面を指定
//               return const EditPage();
//             },
//           ),
//         ).then(
//           (value) async {
//             // 画面遷移から戻ってきた時の処理
//             _todoProvider.clearItems();
//             _todoProvider.initializeList();
//           },
//         );
//       },
//       icon: const Icon(Icons.add),
//     );
//   }
// }

// ///
// /// 設定アイコン
// /// 設定画面へ遷移する
// class _SettingIcon extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _todoProvider = ref.read(todoProvider);
//     return IconButton(
//       onPressed: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) {
//               return const SettingPage();
//             },
//           ),
//         ).then(
//           (value) async {
//             // 画面遷移から戻ってきた時の処理
//             _todoProvider.clearItems();
//             _todoProvider.initializeList();
//           },
//         );
//       },
//       icon: const Icon(
//         Icons.settings, //dehaze_sharp,
//         size: 30,
//       ),
//     );
//   }
// }
