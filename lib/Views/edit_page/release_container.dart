import '../../Common/importer.dart';

class ReleaseContainer extends StatelessWidget {
  const ReleaseContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _todoProvider = context.watch<TodoProvider>();
    return Column(
      children: [
        SwitchListTile(
          value: _todoProvider.switchReleaseDay,
          title: const Text('発売日'),
          onChanged: (bool value) {
            _todoProvider.changeRelease(value);
          },
        ),
        // 日付表示（switchReleaseDayで表示・非表示切替）
        Visibility(
          visible: _todoProvider.switchReleaseDay,
          child: Container(
            padding: const EdgeInsets.only(left: 15),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                const SizedBox(height: 15),
                Text(
                  _todoProvider.labelReleaseDate,
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.date_range))
              ],
            ),
          ),
        ),
      ],
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
      context.read<TodoProvider>().changeReleaseDay(selected);
    }
  }
}
