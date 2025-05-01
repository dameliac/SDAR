import 'package:flutter/material.dart';
import 'package:forui/forui.dart';


class History extends StatefulWidget {
  const History({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateHistory();
  }
}

class _StateHistory extends State<History> {

    @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(title: const Text("History")),
      content: Column(
        children: [
          Text('Hello World')
        ],
      )
    );
  }
}