import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:forui/forui.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/frompage.dart';
import 'package:sdar/planned_trips.dart';
import 'package:provider/provider.dart';
import 'package:sdar/topage.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateTrips();
  }
}

class _StateTrips extends State<Trips> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  bool _notifyMe = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder : (context,app,child)=>
      FScaffold(
        contentPad: false,
        header: FHeader(
          title: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    // Your onPressed logic here
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  "Trips",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // Specify explicit dimensions for the map
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .4,
                  child: FlutterMap(
                    options: MapOptions(
                      initialZoom: 15,
                      interactionOptions: const InteractionOptions(
                        flags: ~InteractiveFlag.doubleTapZoom,
                      ),
                      // Note: LatLng coordinates are (latitude, longitude), not (longitude, latitude)
                      initialCenter: LatLng(
                        18.003654,
                        -76.748053,
                      ), // Corrected coordinates order
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: //From OPENSTREETMAP
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.yourcompany.sdar',
                      ),
                    ],
                  ),
                ),
                //Text("Hello World")
                const SizedBox(height: 10),
      
                /// 🟩 Overlay form container
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(193, 240, 169, 1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              size: 30,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Route',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
      
                        /// From Field
                        //TODO : Add a location picker for the "From" field
                        FTextField(
                          onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Frompage()));
                          },
                          onChange: (value) {
                            print(value);
                            //TODO add a location picker for the "From" field
                          },
                          readOnly: true,
                          hint: app.selectedFromLocation == null? "" : app.selectedFromLocation!.name,
                          controller: _fromController,
                          clearable: (value) => value.text.isNotEmpty,
                          enabled: true,
                          label: const Text(
                            'From:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          maxLines: 1,
                          style: FTextFieldStyle.inherit(
                            colorScheme: FColorScheme(
                              brightness: Brightness.light, // Light theme
                              barrier:
                                  Colors
                                      .transparent, // Transparent barrier color (usually for focus or overlay)
                              background:
                                  Colors
                                      .white, // White background for the TextField
                              foreground:
                                  Colors
                                      .black, // Text color (black for visibility)
                              primary:
                                  Colors.blue, // Primary color (blue for example)
                              primaryForeground:
                                  Colors
                                      .white, // Text color for primary actions (white on blue)
                              secondary:
                                  Colors
                                      .green, // Secondary color (green for example)
                              secondaryForeground:
                                  Colors
                                      .white, // Text color for secondary actions (white on green)
                              muted:
                                  Colors
                                      .grey, // Muted color for less important content
                              mutedForeground:
                                  Colors
                                      .black, // Muted text color (black for visibility)
                              destructive:
                                  Colors
                                      .red, // Destructive action color (red for example)
                              destructiveForeground:
                                  Colors
                                      .white, // Text color for destructive actions (white on red)
                              error: Colors.red, // Error color (red for example)
                              errorForeground:
                                  Colors
                                      .white, // Text color for error (white on red)
                              border:
                                  Colors
                                      .blueGrey, // Border color for the TextField (blue-grey for a subtle look)
                            ),
                            typography:
                                FTypography(), // Default typography style for the text
                            style: FStyle.inherit(
                              colorScheme: FColorScheme(
                                brightness: Brightness.light, // Light theme
                                barrier:
                                    Colors
                                        .transparent, // Transparent barrier color (usually for focus or overlay)
                                background:
                                    Colors
                                        .white, // White background for the TextField
                                foreground:
                                    Colors
                                        .black, // Text color (black for visibility)
                                primary:
                                    Colors
                                        .blue, // Primary color (blue for example)
                                primaryForeground:
                                    Colors
                                        .white, // Text color for primary actions (white on blue)
                                secondary:
                                    Colors
                                        .green, // Secondary color (green for example)
                                secondaryForeground:
                                    Colors
                                        .white, // Text color for secondary actions (white on green)
                                muted:
                                    Colors
                                        .grey, // Muted color for less important content
                                mutedForeground:
                                    Colors
                                        .black, // Muted text color (black for visibility)
                                destructive:
                                    Colors
                                        .red, // Destructive action color (red for example)
                                destructiveForeground:
                                    Colors
                                        .white, // Text color for destructive actions (white on red)
                                error:
                                    Colors.red, // Error color (red for example)
                                errorForeground:
                                    Colors
                                        .white, // Text color for error (white on red)
                                border:
                                    Colors
                                        .blueGrey, // Border color for the TextField (blue-grey for a subtle look)
                              ),
                              typography: FTypography(),
                            ), // Text style (standard size and weight)
                          ),
                        ),
      
                        const SizedBox(height: 10),
      
                        /// To Field
                        FTextField(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Topage()));
                          },
                          readOnly: true,
                          controller: _toController,
                          clearable: (value) => value.text.isNotEmpty,
                          enabled: true,
                          hint: app.selectedToLocation == null? "": app.selectedToLocation!.name,
                          label: const Text(
                            'To:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          maxLines: 1,
                          style: FTextFieldStyle.inherit(
                            colorScheme: FColorScheme(
                              brightness: Brightness.light, // Light theme
                              barrier:
                                  Colors
                                      .transparent, // Transparent barrier color (usually for focus or overlay)
                              background:
                                  Colors
                                      .white, // White background for the TextField
                              foreground:
                                  Colors
                                      .black, // Text color (black for visibility)
                              primary:
                                  Colors.blue, // Primary color (blue for example)
                              primaryForeground:
                                  Colors
                                      .white, // Text color for primary actions (white on blue)
                              secondary:
                                  Colors
                                      .green, // Secondary color (green for example)
                              secondaryForeground:
                                  Colors
                                      .white, // Text color for secondary actions (white on green)
                              muted:
                                  Colors
                                      .grey, // Muted color for less important content
                              mutedForeground:
                                  Colors
                                      .black, // Muted text color (black for visibility)
                              destructive:
                                  Colors
                                      .red, // Destructive action color (red for example)
                              destructiveForeground:
                                  Colors
                                      .white, // Text color for destructive actions (white on red)
                              error: Colors.red, // Error color (red for example)
                              errorForeground:
                                  Colors
                                      .white, // Text color for error (white on red)
                              border:
                                  Colors
                                      .blueGrey, // Border color for the TextField (blue-grey for a subtle look)
                            ),
                            typography:
                                FTypography(), // Default typography style for the text
                            style: FStyle.inherit(
                              colorScheme: FColorScheme(
                                brightness: Brightness.light, // Light theme
                                barrier:
                                    Colors
                                        .transparent, // Transparent barrier color (usually for focus or overlay)
                                background:
                                    Colors
                                        .white, // White background for the TextField
                                foreground:
                                    Colors
                                        .black, // Text color (black for visibility)
                                primary:
                                    Colors
                                        .blue, // Primary color (blue for example)
                                primaryForeground:
                                    Colors
                                        .white, // Text color for primary actions (white on blue)
                                secondary:
                                    Colors
                                        .green, // Secondary color (green for example)
                                secondaryForeground:
                                    Colors
                                        .white, // Text color for secondary actions (white on green)
                                muted:
                                    Colors
                                        .grey, // Muted color for less important content
                                mutedForeground:
                                    Colors
                                        .black, // Muted text color (black for visibility)
                                destructive:
                                    Colors
                                        .red, // Destructive action color (red for example)
                                destructiveForeground:
                                    Colors
                                        .white, // Text color for destructive actions (white on red)
                                error:
                                    Colors.red, // Error color (red for example)
                                errorForeground:
                                    Colors
                                        .white, // Text color for error (white on red)
                                border:
                                    Colors
                                        .blueGrey, // Border color for the TextField (blue-grey for a subtle look)
                              ),
                              typography: FTypography(),
                            ), // Text style (standard size and weight)
                          ),
                        ),
      
                        const SizedBox(height: 10),
      
                        FTextField(
                          controller: _toController,
                          clearable: (value) => value.text.isNotEmpty,
                          enabled: true,
                          label: const Text(
                            'Estimated Time of Arrival',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          maxLines: 1,
                          style: FTextFieldStyle.inherit(
                            colorScheme: FColorScheme(
                              brightness: Brightness.light, // Light theme
                              barrier:
                                  Colors
                                      .transparent, // Transparent barrier color (usually for focus or overlay)
                              background:
                                  Colors
                                      .white, // White background for the TextField
                              foreground:
                                  Colors
                                      .black, // Text color (black for visibility)
                              primary:
                                  Colors.blue, // Primary color (blue for example)
                              primaryForeground:
                                  Colors
                                      .white, // Text color for primary actions (white on blue)
                              secondary:
                                  Colors
                                      .green, // Secondary color (green for example)
                              secondaryForeground:
                                  Colors
                                      .white, // Text color for secondary actions (white on green)
                              muted:
                                  Colors
                                      .grey, // Muted color for less important content
                              mutedForeground:
                                  Colors
                                      .black, // Muted text color (black for visibility)
                              destructive:
                                  Colors
                                      .red, // Destructive action color (red for example)
                              destructiveForeground:
                                  Colors
                                      .white, // Text color for destructive actions (white on red)
                              error: Colors.red, // Error color (red for example)
                              errorForeground:
                                  Colors
                                      .white, // Text color for error (white on red)
                              border:
                                  Colors
                                      .blueGrey, // Border color for the TextField (blue-grey for a subtle look)
                            ),
                            typography:
                                FTypography(), // Default typography style for the text
                            style: FStyle.inherit(
                              colorScheme: FColorScheme(
                                brightness: Brightness.light, // Light theme
                                barrier:
                                    Colors
                                        .transparent, // Transparent barrier color (usually for focus or overlay)
                                background:
                                    Colors
                                        .white, // White background for the TextField
                                foreground:
                                    Colors
                                        .black, // Text color (black for visibility)
                                primary:
                                    Colors
                                        .blue, // Primary color (blue for example)
                                primaryForeground:
                                    Colors
                                        .white, // Text color for primary actions (white on blue)
                                secondary:
                                    Colors
                                        .green, // Secondary color (green for example)
                                secondaryForeground:
                                    Colors
                                        .white, // Text color for secondary actions (white on green)
                                muted:
                                    Colors
                                        .grey, // Muted color for less important content
                                mutedForeground:
                                    Colors
                                        .black, // Muted text color (black for visibility)
                                destructive:
                                    Colors
                                        .red, // Destructive action color (red for example)
                                destructiveForeground:
                                    Colors
                                        .white, // Text color for destructive actions (white on red)
                                error:
                                    Colors.red, // Error color (red for example)
                                errorForeground:
                                    Colors
                                        .white, // Text color for error (white on red)
                                border:
                                    Colors
                                        .blueGrey, // Border color for the TextField (blue-grey for a subtle look)
                              ),
                              typography: FTypography(),
                            ), // Text style (standard size and weight)
                          ),
                        ),
      
                        const SizedBox(height: 5),
                        //NOTIFY ME
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Notify me to leave:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Switch(
                                value: _notifyMe,
                                activeColor: Colors.green[700],
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _notifyMe = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
      
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Travel Estimate:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //TRAVEL ESTIMATE VALUES
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(109, 217, 120, 1),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color.fromRGBO(4, 98, 28, 1),
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "1hr 5 mins • 20 km",
                                    style: TextStyle(
                                      color: Color.fromRGBO(4, 98, 28, 1),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(109, 217, 120, 1),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.co2,
                                    color: Color.fromRGBO(4, 98, 28, 1),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "20 g/km",
                                    style: TextStyle(
                                      color: Color.fromRGBO(4, 98, 28, 1),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
      
                        const SizedBox(height: 30),
      
                        /// Optimise button
                        FButton(
                          onPress: () {
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PlannedTripsPage()));
                          },
                          label: const Text('Save Trip'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


