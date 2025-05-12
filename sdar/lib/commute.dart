import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/AddCommute.dart';
import 'package:sdar/EditCommute.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';

class CommutePage extends StatefulWidget {
  
  const CommutePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateCommutePage();
  }
}

class _StateCommutePage extends State<CommutePage>{
  @override

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
    final List<Map<String, dynamic>> commute = [
      {
        'startLoc':'Home',
        'destination': 'Alligator Pond, St Elizabeth',
        'date': 'Mon, Tue, Thu, Fri',
        'time': '09:30 AM',
        'notification':true
      },
      {
        'startLoc':'Devon House',
        'destination': '12 Windsor Avenue, Kingston',
        'date': 'Mon, Tue, Fri',
        'time': '02:45 PM',
        'notification':true
      },
]   ;

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
                "Commute Alerts",
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

      // Commute Cards
      ...commute.map((route) => CommuteCard(
            startLoc: route['startLoc'],
            destination: route['destination'],
            days: route['date'],
            time: route['time'],
            Notification: route['notification'],
          )),
          const SizedBox(height: 30),
          FButton(onPress: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AddCommutePage()));
          }, label: Text('Add Commute', style: TextStyle(fontWeight: FontWeight.bold),), style: 
                FButtonStyle(enabledBoxDecoration: enabledBoxDecoration, enabledHoverBoxDecoration: enabledHoverBoxDecoration, 
                disabledBoxDecoration: disabledBoxDecoration, 
                focusedOutlineStyle: FFocusedOutlineStyle(color:const Color.fromRGBO(53, 124, 247, 1) , borderRadius: BorderRadius.circular(5)), 
                contentStyle: FButtonContentStyle(enabledTextStyle: TextStyle(color: Colors.white), 
                disabledTextStyle:TextStyle(color: const Color.fromARGB(255, 154, 154, 154)), 
                enabledIconColor: Colors.white, disabledIconColor:const Color.fromARGB(255, 154, 154, 154) ), 
                iconContentStyle: FButtonIconContentStyle(enabledColor: Colors.white, disabledColor: const Color.fromARGB(255, 154, 154, 154)), 
                spinnerStyle: FButtonSpinnerStyle(enabledSpinnerColor: Colors.white, disabledSpinnerColor: Color.fromARGB(255, 154, 154, 154))))
        ],),
      );
  }
}


//Resuable layout for Planned Trips
class CommuteCard extends StatelessWidget{
  final String startLoc;
  final String destination;
  final String days;
  final String time;
  final bool Notification;


  const CommuteCard({
    Key? key,
    required this.startLoc,
    required this.destination,
    required this.days,
    required this.time,
    required this.Notification,
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
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Arrive by $time'),
              IconButton(
                icon:Icon(Icons.more_horiz),
                tooltip: 'Edit Commute',
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditCommutePage(commuteData: {
                    'startLoc': startLoc,
                    'destination': destination,
                    'remindMe': Notification,
                    'dropOffTime': time,
                    'selectedDays':  [false, true, true, true, true, true, false],
                  })));
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
                    Text(days),
                    const SizedBox(height: 8),
                    Text('Notifications: ${Notification ? 'ON' : 'OFF'}'),
                  ],
                ),
              ),
            ],
          ),

          
        ],
        
      ),

      
       
    );
  }
}

