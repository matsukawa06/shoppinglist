import '../../Common/importer.dart';

import 'package:shoppinglist/Views/home/appbar.dart';
import '../home/body.dart';

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
