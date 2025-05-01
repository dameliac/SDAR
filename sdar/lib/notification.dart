import 'package:flutter/material.dart';
import 'package:forui/forui.dart';


class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateMessages();
  }
}

class _StateMessages extends State<Messages> {

    @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(title: const Text("Messages")),
      content: Column(
        children: [
          Text('Hello World')
        ],
      )
    );
  }
}