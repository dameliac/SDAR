import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';

class EditEstimatedTripPage extends StatefulWidget {
  
  const EditEstimatedTripPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateEditEstimatedTripPage();
  }
}

class _StateEditEstimatedTripPage extends State<EditEstimatedTripPage>{
  @override

  Widget build(BuildContext context){
    return FScaffold(header:FHeader(title:Stack(
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
                "Estimated Trip Costs",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        ),
      footer: AppNavbar(index: 0),
      content: Column());
  }
  }