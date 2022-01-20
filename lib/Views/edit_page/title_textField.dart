import '../../Common/importer.dart';

class TitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerTodo = context.watch<ProviderTodo>();
    return new TextFormField(
      controller: providerTodo.titleController,
      enabled: true,
      maxLength: 30,
      style: TextStyle(color: Colors.black),
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
        return value!.isEmpty ? '必須入力です' : null;
      },
    );
  }
}
