import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:sdar/auth/login.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateProfilePage();
  }
}

class _StateProfilePage extends State<ProfilePage> {

    @override
  Widget build(BuildContext context) {
    final drivername =context.watch<AppProvider>().driverName;
    return FScaffold(
      header: FHeader(title: const Text("Your Profile", textAlign: TextAlign.center,)),
      content: Column(
        children: [
          
          FButton(onPress: (){}, label: const Text('Edit Profile')),//EDIT PROFILE
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
                  const Text('user@user.com'), //replace with actual email
                            
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
          const SizedBox(height: 10,),

          //Logout Button
          FButton(
            label: const Text('Logout'),
            onPress: () {
              Provider.of<AppProvider>(context,listen: false).clearAppData();
              Provider.of<AppProvider>(context,listen:false).logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            },
          ) ,
        ],
      )
    );
  }
}