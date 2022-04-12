import '../../Common/importer.dart';

class PriceTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerTodo = context.watch<ProviderTodo>();
    return new TextFormField(
      controller: providerTodo.priceController,
      enabled: true,
      maxLength: 8,
      style: TextStyle(color: Colors.black),
      obscureText: false,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      decoration: InputDecoration(
        labelText: '価格',
        // hintText: '価格を入力してください',
        enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      validator: (String? value) {
        return value!.isEmpty ? '価格を入力してください' : null;
      },
    );
  }
}
