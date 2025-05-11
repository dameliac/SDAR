import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:sdar/auth/login.dart';
import 'package:sdar/main.dart';
import 'package:sdar/trips.dart';
import 'package:intl/intl.dart';
import 'package:sdar/widgets/appNavBar.dart';

class PlannedTripsPage extends StatefulWidget {
  final String origin; //home or trips 
  const PlannedTripsPage({super.key, required this.origin});

  @override
  State<StatefulWidget> createState() {
    return _StatePlannedTripsPage();
  }
}

class _StatePlannedTripsPage extends State<PlannedTripsPage>{
  late final int currentIndex;
  @override
  void initState() {
  super.initState();
  currentIndex = widget.origin == 'home' ? 0 : 2;
}
  Widget build(BuildContext context){
     final enabledBoxDecoration = BoxDecoration(
      color: const Color.fromRGBO(53, 124, 247, 1), // primary
      borderRadius: BorderRadius.circular(5),
    );

    final enabledHoverBoxDecoration = BoxDecoration(
      color: const Color.fromRGBO(45, 110, 220, 1), // darker shade for hover
      borderRadius: BorderRadius.circular(5),
    );

    final disabledBoxDecoration = BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(5),
    );
    
    //TEMPORARY DATA
    final List<Map<String, dynamic>> plannedTrips = [
  {
    'destination': 'Alligator Pond, St Elizabeth',
    'date': DateTime(2025, 5, 15),
    'time': '09:30 AM'
  },
  {
    'destination': '12 Windsor Avenue, Kingston',
    'date': DateTime(2025, 5, 20),
    'time': '02:45 PM'
  },
];

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
        footer: AppNavbar(index: currentIndex),
        content: Column(
          children: [
          //EDIT BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 140,
                //height: 45,
                decoration: BoxDecoration(
                 // borderRadius: BorderRadius.circular(5)
                ),    
                child: FButton(onPress: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> Trips()));
                }, 
                label: const Text('New'),
                style: FButtonStyle(enabledBoxDecoration: enabledBoxDecoration, enabledHoverBoxDecoration: enabledHoverBoxDecoration, 
                disabledBoxDecoration: disabledBoxDecoration, 
                focusedOutlineStyle: FFocusedOutlineStyle(color:const Color.fromRGBO(53, 124, 247, 1) , borderRadius: BorderRadius.circular(5)), 
                contentStyle: FButtonContentStyle(enabledTextStyle: TextStyle(color: Colors.white), 
                disabledTextStyle:TextStyle(color: const Color.fromARGB(255, 154, 154, 154)), 
                enabledIconColor: Colors.white, disabledIconColor:const Color.fromARGB(255, 154, 154, 154) ), 
                iconContentStyle: FButtonIconContentStyle(enabledColor: Colors.white, disabledColor: const Color.fromARGB(255, 154, 154, 154)), 
                spinnerStyle: FButtonSpinnerStyle(enabledSpinnerColor: Colors.white, disabledSpinnerColor: Color.fromARGB(255, 154, 154, 154))),),//EDIT PROFILE
              ), 

            ],),
           const SizedBox(height: 16),

      // Trip Cards
      ...plannedTrips.map((trip) => TripCard(
            destination: trip['destination'],
            date: trip['date'],
            time: trip['time'],
          )),

        ],),
      );
  }
}


//Resuable layout for Planned Trips
class TripCard extends StatelessWidget{
  final String destination;
  final DateTime date;
  final String time;


  const TripCard({
    Key? key,
    required this.destination,
    required this.date,
    required this.time,
  }):super(key: key);

  @override
 Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 246, 243, 1),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side icon + vertical line
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination,
                    style: const TextStyle(
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(DateFormat('MMM d yyyy').format(date)),
                const SizedBox(height: 4),
                RichText(text: TextSpan(
            children: [
              TextSpan(
              text: 'ETA:',
              style: TextStyle(fontWeight: FontWeight.bold,
              color: Colors.black),

                                            
              ),
                      
              TextSpan(
                text: ' ${time}', //REPLACE WITH ACTUAL TYPE
                style: TextStyle(
                //fontWeight: FontWeight.normal,
                color: Colors.black
                )
                  )
                ]
              ),
            ),
                //Text('ETA: ${time}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Container(
                    width: 112,
                    child: FButton(onPress: (){}, label: Text('Execute'), )
                  ),
              ])
              ],
              
          ),),
            const SizedBox(width: 12),
          // Right side text content
          Column(
            children: [
              Icon(Icons.more_vert) //WHEN CLICKED ALLOWS USER TO DELETE - SEE FIGMA
             
            ],
          

        
      ),
    ],
    ),
    );
  }
}

