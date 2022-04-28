// ignore_for_file: file_names
import '../../Common/importer.dart';

class GroupTitleTextField extends StatelessWidget {
  const GroupTitleTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProviderGroup>();
    return TextFormField(
      // 入力エリアのセレクトアクション（コピペ、選択、削除など）の有効、無効
      enableInteractiveSelection: true,
      controller: store.titleController,
      enabled: true,
      maxLength: 15,
      style: const TextStyle(color: Colors.black),
      // 入力内容のマスク表示の切り替え
      obscureText: false,
      maxLines: 1,
      decoration: const InputDecoration(
        labelText: 'リスト名',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
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
