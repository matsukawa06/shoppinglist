import '../../Common/importer.dart';

class NewListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProviderStore>();

    return Scaffold(
      appBar: AppBar(
        title: Text('リストを新規作成'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 10,
              right: 20,
            ),
            child: InkWell(
              child: Text(
                '完了',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
