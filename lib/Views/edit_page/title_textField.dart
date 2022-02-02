import '../../Common/importer.dart';

class TitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerTodo = context.watch<ProviderTodo>();
    return new TextFormField(
      // 入力エリアのセレクトアクション（コピペ、選択、削除など）の有効、無効
      enableInteractiveSelection: true,
      controller: providerTodo.titleController,
      enabled: true,
      maxLength: 30,
      style: TextStyle(color: Colors.black),
      // 入力内容のマスク表示の切り替え
      obscureText: false,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'タイトル',
        //hintText: 'タイトルを入力してください',
        enabledBorder: new UnderlineInputBorder(
          borderSide: new BorderSide(color: Colors.blue),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      validator: (String? value) {
        return value!.isEmpty ? 'タイトルを入力してください' : null;
      },
    );
  }
}
