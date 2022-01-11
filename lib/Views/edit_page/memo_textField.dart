import '../../Common/importer.dart';

class MemoTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStore = context.watch<ProviderStore>();
    return TextField(
      controller: providerStore.memoController,
      enabled: true,
      maxLength: 300,
      style: TextStyle(color: Colors.black),
      obscureText: false,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'メモ',
        // hintText: 'メモを入力してください',
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }
}
