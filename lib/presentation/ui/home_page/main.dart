import 'package:flutter/material.dart';

import 'package:shoppinglist/presentation/ui/home_page/appbar.dart';
import 'body.dart';

// リスト一覧画面用Widget
class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Body(),
    );
  }
}
