import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthPage extends ConsumerWidget {
  const MonthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: const Text('てすと２'),
        )
      ],
    );
  }
}
