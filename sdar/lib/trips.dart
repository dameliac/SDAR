import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:forui/forui.dart';
import 'package:latlong2/latlong.dart';

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

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      contentPad: false,
      header: FHeader(title: const Text("Trips")),
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
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.yourcompany.sdar',
                    ),
                  ],
                ),
              ),
              Text("Hello World"),
              FTextField(
                controller: _fromController, // TextEditingController
                clearable: (value) => value.text.isNotEmpty,
                enabled: true,
                label: const Text('From:'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              FTextField(
                controller: _fromController, // TextEditingController
                clearable: (value) => value.text.isNotEmpty,
                enabled: true,
                label: const Text('To:'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
              ),

              const Text(
                "Estimated Arrival Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const Text(
                "Travel Estimates",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              FButton(onPress: () {}, label: const Text('Optimize')),
            ],
          ),
        ),
      ),
    );
  }
}
