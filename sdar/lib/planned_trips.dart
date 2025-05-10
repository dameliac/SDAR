import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:sdar/auth/login.dart';
import 'package:sdar/main.dart';

class PlannedTripsPage extends StatefulWidget {
  const PlannedTripsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatePlannedTripsPage();
  }
}

class _StatePlannedTripsPage extends State<PlannedTripsPage>{
  @override
  Widget build(BuildContext context){
    return FScaffold(header:FHeader( title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  // Your onPressed logic here
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'SDAR')));
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            const Center(
              child: Text(
                "Planned Trips",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        ),
        content: Column(),
      );
  }
}
