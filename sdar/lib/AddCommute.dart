import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/commute.dart';
import 'package:sdar/widgets/appNavBar.dart';
import 'package:sdar/functions/CommuteService.dart';


class AddCommutePage extends StatefulWidget {
  
  const AddCommutePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateAddCommutePage();
  }
}

class _StateAddCommutePage extends State<AddCommutePage>{
  List<bool> _selectedDays = List.filled(7, false);
  bool _RemindMe = true;
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
  TextEditingController _timeController = TextEditingController();
  TextEditingController _startLocationController = TextEditingController();
  TextEditingController _endLocationController = TextEditingController();
  TextEditingController _daysController = TextEditingController();

  @override
  void dispose(){
    _startLocationController.dispose();
    _endLocationController.dispose();
    _timeController.dispose();
    _daysController.dispose();
    super.dispose();
  }
  @override
  Widget build (BuildContext context){
    return FScaffold(
      header:FHeader( 
       title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  // Your onPressed logic here
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CommutePage()));
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            const Center(
              child: Text(
                "Add a Commute",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),),
      footer: AppNavbar(index: 0),
      content:SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Material(
              color: Color.fromRGBO(243, 246, 243, 1),
              borderRadius: BorderRadius.circular(5),
              child:Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                    controller: _startLocationController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                      hintText: 'Enter a starting location',
                      border: UnderlineInputBorder(borderSide: BorderSide.none)
                    ),
                 
                ) ,
              )
            ),
            const SizedBox(height: 20,),
            Material(
              color: Color.fromRGBO(243, 246, 243, 1),
              borderRadius: BorderRadius.circular(5),
              child:Container(
                padding: EdgeInsets.all(5),
                child: TextField(
                  controller: _endLocationController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                      hintText: 'Enter your destination',
                      border: UnderlineInputBorder(borderSide: BorderSide.none)
                    ),
                 
                ) ,
              )
            ),
            const SizedBox(height: 40,),
            Material(
              color: Color.fromRGBO(243, 246, 243, 1),
              borderRadius: BorderRadius.circular(5),
              child:Container(
                padding: EdgeInsets.all(5),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const 
                    Text('Turn Notifications On', style: TextStyle(fontSize: 14),),
                    const SizedBox(height: 15,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: 
                      Switch(
                        value: _RemindMe,
                        activeColor: Colors.green[700],
                        onChanged: (bool newValue) {
                        setState(() {
                        _RemindMe = newValue;
                        });
                        },
                      ) 
                    ),
                  ],
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
                    controller: _timeController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                      hintText: 'Tap to enter drop-off time',
                      border: UnderlineInputBorder(borderSide: BorderSide.none)
                    ),
                    showCursor: false,
                    onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: const Color.fromRGBO(53, 124, 247, 1),        // Dial + OK button
                            onPrimary: Colors.white,                                // Text on primary
                            surface: Colors.white,                                  // Picker background
                            onSurface: Colors.black,                                // Default text
                            error: Colors.red,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(53, 124, 247, 1), // Cancel button
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    );
                    if (pickedTime != null) {
                      _timeController.text = pickedTime.format(context);
                    }
                  },
           
                ) ,
              )
            ),
            const SizedBox(height: 20,),
            Align(alignment: Alignment.centerLeft,
            child:Text('Select Commute Day/s', style: TextStyle(fontWeight: FontWeight.bold),),),
            const SizedBox(height: 10,),
            Material(
              child: DaySelectorChips(onSelectionChanged: (List<bool>selection){
                setState(() {
                  _selectedDays=List.from(selection);
                });
              },)
            ),
             const SizedBox(height: 50,),
            FButton(onPress: ()async{
              final List<String> allDays = ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'];
              final List<String> selectedDays = [
              for (int i = 0; i < allDays.length; i++)
                if (_selectedDays[i]) allDays[i]
            ];
        
              final commuteService = CommuteService();
              await commuteService.saveCommute(
                  start: _startLocationController.text,
                  end: _endLocationController.text,
                  days: selectedDays,
                  arriveByTime: _timeController.text,
                  remindMe: _RemindMe,
                );
        
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CommutePage()));
            }, label: Text('Save', style: TextStyle(fontWeight: FontWeight.bold),), style: 
                  FButtonStyle(enabledBoxDecoration: enabledBoxDecoration, enabledHoverBoxDecoration: enabledHoverBoxDecoration, 
                  disabledBoxDecoration: disabledBoxDecoration, 
                  focusedOutlineStyle: FFocusedOutlineStyle(color:const Color.fromRGBO(53, 124, 247, 1) , borderRadius: BorderRadius.circular(5)), 
                  contentStyle: FButtonContentStyle(enabledTextStyle: TextStyle(color: Colors.white), 
                  disabledTextStyle:TextStyle(color: const Color.fromARGB(255, 154, 154, 154)), 
                  enabledIconColor: Colors.white, disabledIconColor:const Color.fromARGB(255, 154, 154, 154) ), 
                  iconContentStyle: FButtonIconContentStyle(enabledColor: Colors.white, disabledColor: const Color.fromARGB(255, 154, 154, 154)), 
                  spinnerStyle: FButtonSpinnerStyle(enabledSpinnerColor: Colors.white, disabledSpinnerColor: Color.fromARGB(255, 154, 154, 154))))
          ],
        ),
      ))
      ;
  }}

//From ChatGPT

class DaySelectorChips extends StatefulWidget {
  final void Function(List<bool>) onSelectionChanged;

  const DaySelectorChips({super.key, required this.onSelectionChanged});

  @override
  State<DaySelectorChips> createState() => _DaySelectorChipsState();
}

class _DaySelectorChipsState extends State<DaySelectorChips> {
  final List<String> days = ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'];
  final List<bool> selected = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(days.length, (index) {
        return InputChip(
          label: Text(days[index]),
          selected: selected[index],
          onSelected: (bool value) {
            setState(() {
              selected[index] = value;
            });
            widget.onSelectionChanged(selected);
          },
          selectedColor: Theme.of(context).colorScheme.primary,
          checkmarkColor: Theme.of(context).colorScheme.primary,
        );
      }),
    );
  }
}
