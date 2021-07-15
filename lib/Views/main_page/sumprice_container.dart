// import 'package:provider/provider.dart';
// import '../../Models/provider_store.dart';
// import 'package:flutter/cupertino.dart';
// import '../../Common/common_util.dart';

// class SumPriceContainer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final providerPrice = context.watch<ProviderPrice>();
//     return // 合計金額表示
//         Container(
//       // 左寄せ
//       width: double.infinity,
//       margin: EdgeInsets.only(
//         left: 20,
//         bottom: 50,
//       ),
//       child: Text(
//         '合計：${formatPrice(providerPrice.sumPrice)} 円',
//         textAlign: TextAlign.left,
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 24,
//         ),
//       ),
//     );
//   }
// }
