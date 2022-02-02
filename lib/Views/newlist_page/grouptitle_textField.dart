import '../../Common/importer.dart';

class GroupTitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProviderGroup>();
    return new TextFormField(
      // 入力エリアのセレクトアクション（コピペ、選択、削除など）の有効、無効
      enableInteractiveSelection: true,
      controller: store.titleController,
      enabled: true,
      maxLength: 15,
      style: TextStyle(color: Colors.black),
      // 入力内容のマスク表示の切り替え
      obscureText: false,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'リスト名',
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      validator: (String? value) {
        return value!.isEmpty ? 'リスト名を入力してください' : null;
      },
    );
  }
}
