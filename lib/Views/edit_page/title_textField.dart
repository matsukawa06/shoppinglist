// ignore_for_file: file_names
import '../../Common/importer.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _todoProvider = context.watch<TodoProvider>();
    return TextFormField(
      // 入力エリアのセレクトアクション（コピペ、選択、削除など）の有効、無効
      enableInteractiveSelection: true,
      controller: _todoProvider.titleController,
      enabled: true,
      maxLength: 30,
      style: const TextStyle(color: Colors.black),
      // 入力内容のマスク表示の切り替え
      obscureText: false,
      maxLines: 1,
      decoration: const InputDecoration(
        labelText: 'タイトル',
        //hintText: 'タイトルを入力してください',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
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
