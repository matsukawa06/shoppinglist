import '../../../Common/importer.dart';

import 'package:shoppinglist/Views/home_page/ui/appbar.dart';
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
