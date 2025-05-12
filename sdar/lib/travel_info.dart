import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/estimated_trip.dart';
import 'package:sdar/profile.dart';
import 'package:sdar/widgets/appNavBar.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';


class TravelInfoPage extends StatefulWidget{
  const TravelInfoPage({
    super.key
  });

  @override
State<StatefulWidget> createState()=> _StateTravelInfoPage();
}

class _StateTravelInfoPage extends State<TravelInfoPage>{
  //STORING INPUTS
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }


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
  @override
  Widget build(BuildContext context){
      final drivername =context.watch<AppProvider>().driverName; //trying to get username - check App Provider
    return Consumer<AppProvider>(
      builder: (context,app,child) => FScaffold(
        header: FHeader( title: Text('Travel Information')),
        footer: AppNavbar(index: 4),
        content:SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height:40 ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 FButton(
                      onPress: (){ 
                        Navigator.pop(context);
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EstimatedTripPage()));
                        },
                      label: const Text('Cancel'),
                      style: FButtonStyle(enabledBoxDecoration: enabledBoxDecoration, enabledHoverBoxDecoration: enabledHoverBoxDecoration, 
                    disabledBoxDecoration: disabledBoxDecoration, 
                    focusedOutlineStyle: FFocusedOutlineStyle(color:const Color.fromRGBO(53, 124, 247, 1) , borderRadius: BorderRadius.circular(5)), 
                    contentStyle: FButtonContentStyle(enabledTextStyle: TextStyle(color: Colors.white), 
                    disabledTextStyle:TextStyle(color: const Color.fromARGB(255, 154, 154, 154)), 
                    enabledIconColor: Colors.white, disabledIconColor:const Color.fromARGB(255, 154, 154, 154) ), 
                    iconContentStyle: FButtonIconContentStyle(enabledColor: Colors.white, disabledColor: const Color.fromARGB(255, 154, 154, 154)), 
                    spinnerStyle: FButtonSpinnerStyle(enabledSpinnerColor: Colors.white, disabledSpinnerColor: Color.fromARGB(255, 154, 154, 154))),
                    )
              ],
            ),
            const SizedBox(height: 30,),
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
              const SizedBox(height: 20,),
              Text('Enter the following information below to see your travel trends.', style: TextStyle(fontWeight: FontWeight.w600),),
              const SizedBox(height: 15,),
              Material(
                color: Color.fromRGBO(243, 246, 243, 1),
                borderRadius: BorderRadius.circular(5),
                child:Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                        controller: _makeController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                        hintText: 'Please enter the make of your car (e.g., Toyota)',
                        border: UnderlineInputBorder(borderSide: BorderSide.none)
                      ),
                      onSubmitted: (value) {
                    },
                  ) ,
                )
              ),
              const SizedBox(height: 15,),
              Material(
                color: Color.fromRGBO(243, 246, 243, 1),
                borderRadius: BorderRadius.circular(5),
                child:Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    controller: _modelController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                        hintText: 'Please enter the model of your car (e.g., Prius)',
                        border: UnderlineInputBorder(borderSide: BorderSide.none)
                      ),
                      onSubmitted: (value) {
                    },
                  ) ,
                )
              ),
              const SizedBox(height: 15,),
              Material(
                color: Color.fromRGBO(243, 246, 243, 1),
                borderRadius: BorderRadius.circular(5),
                child:Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    controller: _yearController,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                        hintText: "Please enter manufacturing year (e.g., 2020)",
                        border: UnderlineInputBorder(borderSide: BorderSide.none)
                      ),
                      onSubmitted: (value) {
                    },
                  ) ,
                )
              ),
               const SizedBox(height: 15,),
              FButton(
                onPress: () async{ 
                   String make = _makeController.text.trim();
                    String model = _modelController.text.trim();
                    String year = _yearController.text.trim();
          
                    // Simple validation - FROM CHATGPT
                    if (make.isEmpty || model.isEmpty || year.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields.')),
                      );
                      return;
                    }

                    final success = await app.createVehicle(make, model, year);
                    if(success == true) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
                    } else {
                      toastification.show(
                        autoCloseDuration: Duration(seconds: 1),
                        title: Text('Something went wrong'),
                        type: ToastificationType.error
                      );
                    }


                   },
                      label: const Text('Submit'),
                    //   style: FButtonStyle(enabledBoxDecoration: enabledBoxDecoration, enabledHoverBoxDecoration: enabledHoverBoxDecoration, 
                    // disabledBoxDecoration: disabledBoxDecoration, 
                    // focusedOutlineStyle: FFocusedOutlineStyle(color:const Color.fromRGBO(53, 124, 247, 1) , borderRadius: BorderRadius.circular(5)), 
                    // contentStyle: FButtonContentStyle(enabledTextStyle: TextStyle(color: Colors.white), 
                    // disabledTextStyle:TextStyle(color: const Color.fromARGB(255, 154, 154, 154)), 
                    // enabledIconColor: Colors.white, disabledIconColor:const Color.fromARGB(255, 154, 154, 154) ), 
                    // iconContentStyle: FButtonIconContentStyle(enabledColor: Colors.white, disabledColor: const Color.fromARGB(255, 154, 154, 154)), 
                    // spinnerStyle: FButtonSpinnerStyle(enabledSpinnerColor: Colors.white, disabledSpinnerColor: Color.fromARGB(255, 154, 154, 154))),
                    )
           
          ],),
        )),
    );
  }
}