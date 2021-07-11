import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/provider_store.dart';
import 'package:intl/intl.dart';

class ReleaseContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerStore = context.watch<ProviderStore>();
    return Container(
      child: Column(
        children: [
          SwitchListTile(
            value: providerStore.switchReleaseDay,
            title: Text('発売日'),
            onChanged: (bool value) {
              providerStore.changeReleaseDay(value);
            },
          ),
          // 日付表示（switchReleaseDayで表示・非表示切替）
          Container(
            child: Visibility(
              visible: providerStore.switchReleaseDay,
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
                      providerStore.labelDate,
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
      var formatter = new DateFormat('yyyy/MM/dd(E)', "ja_JP");
      context.read<ProviderStore>().changeLabelDate(formatter.format(selected));
    }
  }
}
