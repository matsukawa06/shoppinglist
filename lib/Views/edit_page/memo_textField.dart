// ignore_for_file: file_names
import '../../Common/importer.dart';

class MemoTextField extends StatelessWidget {
  const MemoTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _todoProvider = context.watch<TodoProvider>();
    return TextField(
      controller: _todoProvider.memoController,
      enabled: true,
      maxLength: 300,
      style: const TextStyle(color: Colors.black),
      obscureText: false,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'メモ',
        // hintText: 'メモを入力してください',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
