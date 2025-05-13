import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:sdar/AddCommute.dart';
import 'package:sdar/EditEstimateTrip.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';

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
    final String startLoc;
    final String destination;
    final double avgGasPrice = 127.0512;
    final DateTime date;
    final String duration;
    final String make;
    final String model;
    final String usage; //fuel or ev usage
    final double cost;
    final double EVchargePrice = 90;


     
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
        content: SingleChildScrollView(
  padding: const EdgeInsets.all(16), // Optional: for breathing room
  child: Column(
    children: [
      const SizedBox(height: 16),
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
    ],
  ),
),
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
     required this.Price , //for Fuel/Ev Price
     required this.Usage , //for Fuel/EV Usage
     required this.cost, //total cost
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
          
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              const SizedBox(width: 7),

              // Main trip details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(startLoc, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Icon(Icons.arrow_forward_sharp),
                      Expanded(
                        child: Text(
                          destination,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text('${distance} km'),
                          width: 65,
                        ),
                         
                         SizedBox( 
                          width: 40,
                          child: Icon(Icons.circle_rounded, size: 10,)),
                          SizedBox(
                            width: 140,
                            child:Text('${timelength} hr'), 


                          ),
                          SizedBox(
                            width: 100,
                            child:Text(DateFormat('MMM d yyyy').format(date))
                          )
                      ],
                    ),
                  const SizedBox(height: 15,),
                   Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                   ),
                   const SizedBox(height: 15,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Make & Model:', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('${Make}, ${Model}')
                    ],
                   ),
                   const SizedBox(height: 8,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fuel/EV Price:', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('${Price} per litre or Kilowatts') //Adjust this so that if the car is fuel then it's per litre else per Kilowatts
                    ],
                   ),
                   const SizedBox(height: 8,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fuel/EV Usage:', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(Usage) 
                    ],
                   ),
                   const SizedBox(height: 15,),
                    Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                   ),
                   const SizedBox(height: 8,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Cost:', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('JMD \$${cost}') 
                    ],
                   ),
                   
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: 
          SizedBox(
            width:80 ,
            child: 
           FButton(
            onPress: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditEstimatedTripPage(tripData:{'startLoc': startLoc,
            'destination': destination,
            'date': date,
            'Make': Make,
            'Model': Model,
            }
            )));
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

