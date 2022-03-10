import '../../Common/importer.dart';

import 'package:shoppinglist/Views/home/appbar.dart';
import '../home/body.dart';

// リスト一覧画面用Widget
class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Body(),
    );
  }
}
