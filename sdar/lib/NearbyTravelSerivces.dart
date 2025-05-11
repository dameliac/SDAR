import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NearbyStationsMap extends StatefulWidget {
  const NearbyStationsMap({super.key});

  @override
  State<NearbyStationsMap> createState() => _NearbyStationsMapState();
}

class _NearbyStationsMapState extends State<NearbyStationsMap> {
  LatLng? _currentLocation;
  String? _error;
  List<Marker> _stationMarkers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _error = "Location services disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() => _error = "Location permission required");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      setState(() => _currentLocation = latLng);
      _fetchNearbyStations(latLng.latitude, latLng.longitude);
    } catch (e) {
      setState(() => _error = "Failed to get location: $e");
    }
  }

  Future<void> _fetchNearbyStations(double lat, double lon) async {
    final rawQuery = '''
[out:json];
(
  node["amenity"="fuel"](around:5000,$lat,$lon);
  node["amenity"="charging_station"](around:5000,$lat,$lon);
);
out;
''';

    final encodedQuery = Uri.encodeQueryComponent(rawQuery);
    final url = Uri.parse("https://overpass-api.de/api/interpreter?data=$encodedQuery");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        final markers = elements.map((e) {
          final lat = e['lat'] as double;
          final lon = e['lon'] as double;
          final amenity = e['tags']?['amenity'];

          return Marker(
            point: LatLng(lat, lon),
            width: 40,
            height: 40,
            child: Icon(
              amenity == 'charging_station'
                  ? Icons.electrical_services
                  : Icons.local_gas_station,
              color: amenity == 'charging_station' ? Colors.green : Colors.red,
              size: 30,
            ),
          );
        }).toList();

        setState(() => _stationMarkers = markers);
      } else {
        setState(() => _error = 'Failed to fetch stations (${response.statusCode})');
      }
    } catch (e) {
      setState(() => _error = "Station fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Stations')),
      body: _currentLocation == null
          ? Center(
              child: _error != null
                  ? Text(_error!, style: const TextStyle(color: Colors.red))
                  : const CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: _currentLocation!,
                minZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.yourapp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 35,
                      ),
                    ),
                    ..._stationMarkers,
                  ],
                ),
              ],
            ),
    );
  }
}
