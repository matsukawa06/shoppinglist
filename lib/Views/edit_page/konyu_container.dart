import '../../Common/importer.dart';

class KonyuContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerTodo = context.watch<ProviderTodo>();
    return Container(
      child: Column(
        children: [
          SwitchListTile(
            value: providerTodo.switchKonyuZumi,
            title: Text('購入済'),
            onChanged: (bool value) {
              providerTodo.changeKonyuZumi(value);
            },
          ),
          // 日付表示（switchReleaseDayで表示・非表示切替）
          Container(
            child: Visibility(
              visible: providerTodo.switchKonyuZumi,
              child: Container(
                padding: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  border: const Border(
                    top: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    Text(
                      providerTodo.labelKonyuDate,
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.date_range))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 選択した発売日
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      locale: const Locale('ja'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2024),
    );
    if (selected != null) {
      context.read<ProviderTodo>().changeKonyuDay(selected);
    }
  }
}
