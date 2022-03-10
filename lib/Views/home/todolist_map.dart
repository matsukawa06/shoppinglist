// import '../../Common/importer.dart';
// import '../edit_page/edit_page.dart';

// class TodoListMap extends StatelessWidget {
//   @override
//   Widget build(BuildContext context, TodoStore todo) {
//     return Card(
//       // margin: const EdgeInsets.all(4),
//       margin: const EdgeInsets.only(
//         left: 8,
//         right: 8,
//         top: 4,
//         bottom: 4,
//       ),
//       elevation: 5.0,
//       key: Key(todo.id.toString()),
//       child: SizedBox(
//         height: 70,
//         child: InkWell(
//           onTap: () {
//             // 一覧をタップした時の詳細画面遷移
//             context.read<ProviderStore>().setRowInfo(todo);
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) {
//                   return EditPage();
//                 },
//               ),
//             ).then(
//               (value) async {
//                 // 画面遷移から戻ってきた時の処理
//                 context.read<ProviderStore>().clearItems();
//                 context.read<ProviderStore>().initializeList();
//               },
//             );
//           },
//           child: Row(
//             children: <Widget>[
//               InkWell(
//                 onTap: () {
//                   context.read<ProviderStore>().updateIsSum(
//                       todo.id, intToBool(todo.isSum) ? false : true);
//                   context.read<ProviderStore>().initializeList();
//                 },
//                 child: SizedBox(
//                   width: 60,
//                   child: Icon(
//                     isSumIcon(todo.isSum),
//                     size: 45,
//                   ),
//                 ),
//               ),
//               Column(
//                 children: <Widget>[
//                   SizedBox(
//                     width: 250,
//                     height: 40,
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         '${todo.title}',
//                         style: TextStyle(fontSize: 18),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                     child: Row(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 100,
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               '${formatPrice(todo.price)} 円',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 150,
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               strReleaseDay(todo.release, todo.releaseDay),
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: 40,
//                 child: Checkbox(
//                   activeColor: Colors.blue,
//                   value: intToBool(todo.konyuZumi),
//                   onChanged: (bool? value) {
//                     context.read<ProviderStore>().updateKonyuZumi(
//                         todo.id, intToBool(todo.konyuZumi) ? false : true);
//                     context.read<ProviderStore>().initializeList();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// IconData isSumIcon(int value) {
//   return value == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined;
// }

// String strReleaseDay(int isRelease, DateTime value) {
//   return isRelease == 1 ? '${dateToString(value)} 発売' : '';
// }
