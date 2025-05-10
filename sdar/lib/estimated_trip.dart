import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:sdar/AddCommute.dart';
import 'package:sdar/EditCommute.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';

class EstimatedTripPage extends StatefulWidget {
  
  const EstimatedTripPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateEstimatedTripPage();
  }
}

class _StateEstimatedTripPage extends State<EstimatedTripPage>{
  @override

  Widget build(BuildContext context){
     
    //TEMPORARY DATA
    final List<Map<String, dynamic>> estimate = [
  {
    'startLoc':'Home',
    'destination': 'Alligator Pond, St Elizabeth',
    'distance': 30.5,
    'date': DateTime(2025,6,23),
    'timelength': 1.5,
    'Make': 'Toyota',
    'Model': 'CR-V',
    'Price': 143.4,
    'Usage': '75 litres/100 km',
    'cost':3217.50
  },
  {
    'startLoc':'Devon House',
    'destination': '12 Windsor Avenue, Kingston',
   'distance': 38.90,
    'date': DateTime(2025,6,23),
    'timelength': 2.5,
    'Make': 'Toyota',
    'Model': 'CR-V',
    'Price': 143.4,
    'Usage': '75 litres/100 km',
    'cost':3217.50
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
                "Estimated Trip Costs",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        ),
        footer: AppNavbar(index: 0),
        content: Column(
          children: [
         
           const SizedBox(height: 16),

      // Estimate Cards
      ...estimate.map((route) => EstimateCard(
            startLoc: route['startLoc'],
            destination: route['destination'],
            distance: route['distance'],
            timelength: route['timelength'],
            date: route['date'],
            Make: route['Make'],
            Model: route['Model'],
            Price: route['Price'],
            Usage: route['Usage'],
            cost: route['cost'],
          )),
          
         
        ],),
      );
  }
}


//Resuable layout for Estimated Trip 
class EstimateCard extends StatelessWidget{
  final String startLoc;
  final String destination;
  final double distance ;
  final DateTime date ;
  final double timelength;
  final String Make;
  final String Model ;
  final double Price ;
  final String Usage ;
  final double cost;


  const EstimateCard({
    Key? key,
    required this.startLoc,
    required this.destination,
     required this.distance,
    required this.date ,
     required this.timelength,
     required this.Make,
     required this.Model,
     required this.Price ,
     required this.Usage ,
     required this.cost,
  }):super(key: key);

  @override
 Widget build(BuildContext context) {
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
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 246, 243, 1),
        borderRadius: BorderRadius.circular(5)
      ),
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${timelength} hr'),
              IconButton(
                icon:Icon(Icons.more_horiz),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditCommutePage()));
                },
              )
            ],
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left-side icons
              Column(
                children: [
                  Icon(Icons.location_pin),
                  const SizedBox(height: 8),
                  Icon(Icons.calendar_today_outlined),
                  const SizedBox(height: 8),
                  Icon(Icons.notifications_outlined),
                ],
              ),
              const SizedBox(width: 12),

              // Main trip details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(startLoc, style: const TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_forward_sharp),
                      Expanded(
                        child: Text(
                          destination,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Text('${distance} km'),
                    const SizedBox(height: 8),
                    //Text('Notifications: ${DateFormat("MMM dd YYYY")}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.bottomRight,
            child: 
          SizedBox(
            width:80 ,
            child: 
           FButton(
            onPress: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AddCommutePage()));
          }, label: Text('Edit',), 
          style: 
                FButtonStyle(enabledBoxDecoration: enabledBoxDecoration, enabledHoverBoxDecoration: enabledHoverBoxDecoration, 
                disabledBoxDecoration: disabledBoxDecoration, 
                focusedOutlineStyle: FFocusedOutlineStyle(color:const Color.fromRGBO(53, 124, 247, 1) , borderRadius: BorderRadius.circular(5)), 
                contentStyle: FButtonContentStyle(enabledTextStyle: TextStyle(color: Colors.white), 
                disabledTextStyle:TextStyle(color: const Color.fromARGB(255, 154, 154, 154)), 
                enabledIconColor: Colors.white, disabledIconColor:const Color.fromARGB(255, 154, 154, 154) ), 
                iconContentStyle: FButtonIconContentStyle(enabledColor: Colors.white, disabledColor: const Color.fromARGB(255, 154, 154, 154)), 
                spinnerStyle: FButtonSpinnerStyle(enabledSpinnerColor: Colors.white, disabledSpinnerColor: Color.fromARGB(255, 154, 154, 154))))
          )
          )
        ],
        
      ),

      
       
    );
  }
}

