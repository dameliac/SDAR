import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:sdar/auth/login.dart';
import 'package:sdar/commute.dart';
import 'package:sdar/editProfile.dart';
import 'package:sdar/main.dart';
import 'package:sdar/travel_info.dart';
import 'package:sdar/widgets/appNavBar.dart';
//import 'package:flutter/src/rendering/box.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateProfilePage();
  }
}

class _StateProfilePage extends State<ProfilePage> {
     late PocketBase pb;
     String? userEmail;
     String? vehicle_type;
     String? optimization_priority;
     String? home;
     String? work;
     


  

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      pb = appProvider.pb;
      fetchUserEmail();
      fetchDriver();
      fetchVehicleType();
    });
  }

  

   Future<void> fetchUserEmail() async {
  try {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final userId = appProvider.userdata?.record.id;

    if (userId == null) {
      print('User ID is null');
      return;
    }

    final user = await pb.collection('users').getFirstListItem('id = "$userId"');

    setState(() {
      userEmail = user.getStringValue('email');
    });
  } catch (e) {
    print('Error fetching current user email: $e');
  }
}


  Future<void> fetchDriver() async {
    try {
     final appProvider = Provider.of<AppProvider>(context, listen: false);
     final userId = appProvider.userdata?.record.id; // Get current user ID
      
      if(userId == null){
        print('User ID is null');
        return;
      }

     final driver = await pb.collection('Driver').getFirstListItem('userID = "$userId"');
     
      setState(() {
      optimization_priority = driver.getStringValue('OptimisationPriority');
      home = driver.getStringValue('Home');
      work = driver.getStringValue('Work');
    });
    }catch(e){
      print('Error getting driver information: $e');
    }
    
    }

    

Future<void> fetchVehicleType() async {
  try {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final userId = appProvider.userdata?.record.id;
    final driverinfo = await pb
      .collection('Driver')
      .getFirstListItem('userID = "$userId"');

     final driverID = driverinfo.id;

    final response = await pb.collection('vehicle').getFullList(
      filter: 'driverID = "$driverID"',
    );

    if (response.isNotEmpty) {
      final record = response.first;
      setState(() {
        vehicle_type = record.getStringValue('VehicleType'); 
      });
    } else {
      print('No vehicle record found. $response');
    }
  } catch (e) {
    print('Error getting vehicle type: $e');
  }
}



    @override
  Widget build(BuildContext context) {
    final drivername =context.watch<AppProvider>().driverName; //trying to get username - check App Provider
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

    return FScaffold(
      header: FHeader(
        title: Stack(
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
                "Your Profile",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      
      content: SingleChildScrollView(
        child: Column(
          children: [
            //EDIT BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //padding: EdgeInsets.only(bottom: 1),
                  width: 140,
                  height: 45,
                  //alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                   // borderRadius: BorderRadius.circular(5)
                  ),    
                  child: FButton(onPress: (){
                     Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> EditProfilePage()));
                  }, 
                  label: const Text('Edit Profile'),
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
            
            const SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                          
                    color: Color.fromRGBO(193, 240, 169, 1),
                    borderRadius: BorderRadius.circular(5),
               ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Image.asset("assets/images/b45fff6b8e9ca09258e544c7bd3e6cd00180d427.png", 
                      width: 100, height: 100, fit: BoxFit.contain,),
                    ),
                    const SizedBox(height: 5,),
                    Text('$drivername'),
                    const SizedBox(height: 5,),
                    Text(userEmail ?? 'Loading email..'), //replace with actual email
                              
                  ],
                ),
              ),
            ),
                        
            const SizedBox(height: 10,),
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Vehicle Type:'
            //   ),
            // ),
            
            //VEHICLE TYPE
            Container(
              width: double.infinity,
              height: 48,
              decoration: ShapeDecoration(
              color: const Color(0xFFF3F6F3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              alignment: Alignment.centerLeft,
              child: RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: '  Vehicle Type: ',
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black),
                                          
                ),
        
        
                TextSpan(
                  text: vehicle_type, //REPLACE WITH ACTUAL TYPE
                  style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black
                      )
                    )
                  ]
                ),
              ),
            ),
            const SizedBox(height: 10),
            //OPTIMISATION PRIORITY
            Container(
              width: double.infinity,
              height: 48,
              decoration: ShapeDecoration(
              color: const Color(0xFFF3F6F3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              alignment: Alignment.centerLeft,
              child: RichText(text: TextSpan(
              children: [
                TextSpan(
                text: '  Optimisation Priority: ',
                style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.black),
        
                                              
                ),
                        
                TextSpan(
                  text: optimization_priority, //REPLACE WITH ACTUAL TYPE
                  style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black
                  )
                    )
                  ]
                ),
              ),
            ),
            const SizedBox(height: 10),
           //HOME
            Container(
                      width: double.infinity,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF3F6F3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: RichText(text: TextSpan(
                        children: [
                          TextSpan(
                            text: '  Home: ',
                            style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.black),
        
                                              
                          ),
                        
                          TextSpan(
                            text: home, //REPLACE WITH ACTUAL TYPE
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black
                            )
                          )
                        ]
                      )),
                    ),
            const SizedBox(height: 10),
            //WORK
            Container(
                  width: double.infinity,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF3F6F3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: '  Work: ',
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.black),
        
                                          
                      ),
                    
                      TextSpan(
                        text: work , //REPLACE WITH ACTUAL TYPE
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                        )
                      )
                    ]
                  )),
                ),
            const SizedBox(height: 15),
           Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Text(
                'Travel Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            FTile(
              prefixIcon: FIcon(FAssets.icons.save, color: const Color.fromRGBO(53, 124, 247, 1),),
              title: Text('Store Travel Information'),
              suffixIcon: FIcon(FAssets.icons.chevronRight,),
              semanticLabel: 'Label',
              enabled: true,
              onPress: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TravelInfoPage()));
              },
              ),
            const SizedBox(height: 20),
            //Logout Button
            FButton(
              label: const Text('Logout'),
              onPress: () {
                Provider.of<AppProvider>(context,listen: false).clearAppData();
                Provider.of<AppProvider>(context,listen:false).logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
              },
              style: 
                  FButtonStyle(enabledBoxDecoration: enabledBoxDecoration, enabledHoverBoxDecoration: enabledHoverBoxDecoration, 
                  disabledBoxDecoration: disabledBoxDecoration, 
                  focusedOutlineStyle: FFocusedOutlineStyle(color:const Color.fromRGBO(53, 124, 247, 1) , borderRadius: BorderRadius.circular(5)), 
                  contentStyle: FButtonContentStyle(enabledTextStyle: TextStyle(color: Colors.white), 
                  disabledTextStyle:TextStyle(color: const Color.fromARGB(255, 154, 154, 154)), 
                  enabledIconColor: Colors.white, disabledIconColor:const Color.fromARGB(255, 154, 154, 154) ), 
                  iconContentStyle: FButtonIconContentStyle(enabledColor: Colors.white, disabledColor: const Color.fromARGB(255, 154, 154, 154)), 
                  spinnerStyle: FButtonSpinnerStyle(enabledSpinnerColor: Colors.white, disabledSpinnerColor: Color.fromARGB(255, 154, 154, 154)))
            ) ,
          ],
        ),
      )
    );
  }
}