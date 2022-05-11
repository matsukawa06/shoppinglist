///
/// リストの新規追加ページ
///
import '../../Common/importer.dart';
import 'body.dart';

class Main extends StatelessWidget {
  final String _mode;
  const Main(this._mode, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<FormProvider>().formKey,
      child: Scaffold(
        appBar: AppBar(
          title: _retTitleTextWidget(_mode),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                right: 20,
              ),
              // 右上完了テキスト
              child: InkWell(
                child: _retKanryoTextWidget(),
                onTap: () async {
                  _clickKanryo(context, _mode);
                },
              ),
            ),
          ],
        ),
        body: Body(),
      ),
    );
  }
}

///
/// 画面タイトルテキスト
///
Widget _retTitleTextWidget(String _mode) {
  String _strTitle = "";

  switch (_mode) {
    case modeInsert:
      _strTitle = "リストを新規作成";
      break;
    case modeUpdate:
      _strTitle = "リスト名を変更";
      break;
    default:
  }
  return Text(_strTitle);
}

///
/// 完了テキスト
///
Widget _retKanryoTextWidget() {
  return const Text(
    '保存',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

///
/// 完了クリック処理
///
void _clickKanryo(BuildContext context, String _mode) async {
  final _groupProvider = context.read<GroupProvider>();
  if (context.read<FormProvider>().formVallidate()) {
    // 入力チェックでエラーが無ければ、DBに登録する
    switch (_mode) {
      case modeInsert:
        var _providerStore = GroupStore(
          title: _groupProvider.titleController.text,
          color: _groupProvider.pickerColor.toString(),
        );
        await GroupController.insertGroup(_providerStore);
        break;
      case modeUpdate:
        var _providerStore = GroupStore(
          id: _groupProvider.selectedId,
          title: _groupProvider.titleController.text,
          color: _groupProvider.pickerColor.toString(),
        );
        await GroupController.updateGroup(_providerStore);
        break;
      default:
    }
    // storeの初期化
    _groupProvider.clearItems();
    // タイトルを反映させる
    _groupProvider.getSelectedInfo();
    // グループリストの再読み込み
    _groupProvider.initializeList();
    // 前の画面に戻る
    Navigator.pop(context);
  }
}
