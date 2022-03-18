///
/// グループリスト編集ページのbody部
///
import '../../Common/importer.dart';
import 'grouptitle_textField.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(18),
        child: GroupTitleTextField(),
      ),
    );
  }
}
