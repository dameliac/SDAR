import 'package:flutter/material.dart';
import 'package:forui/forui.dart';


class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateTrips();
  }
}

class _StateTrips extends State<Trips> {

    @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(title: const Text("Trips")),
      content: Column(
        children: [
          Text('Hello World')
        ],
      )
    );
  }
}