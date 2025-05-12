import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';

class NearbyStationsMap extends StatefulWidget {
  const NearbyStationsMap({super.key});

  @override
  State<NearbyStationsMap> createState() => _NearbyStationsMapState();
}

class _NearbyStationsMapState extends State<NearbyStationsMap> {
  LatLng? _currentLocation;
  String? _error;
  List<Marker> _stationMarkers = [];
  DateTime? _lastFetchTime;
  final Duration _fetchInterval = const Duration(seconds: 30);
  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _positionStream?.drain();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _error = "Location services disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          setState(() => _error = "Location permission required");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() => _currentLocation = latLng);
      _fetchNearbyStations(latLng.latitude, latLng.longitude);
      _listenToLocationChanges();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  void _listenToLocationChanges() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      ),
    ).listen((Position position) {
      final now = DateTime.now();
      final latLng = LatLng(position.latitude, position.longitude);
      setState(() => _currentLocation = latLng);

      if (_lastFetchTime == null || now.difference(_lastFetchTime!) >= _fetchInterval) {
        _lastFetchTime = now;
        _fetchNearbyStations(position.latitude, position.longitude);
      }
    }) as Stream<Position>?;
  }

  Future<void> _fetchNearbyStations(double lat, double lon) async {
    final query = '''
    [out:json];
    (
      node["amenity"="fuel"](around:10000,$lat,$lon);
      way["amenity"="fuel"](around:10000,$lat,$lon);
      relation["amenity"="fuel"](around:10000,$lat,$lon);
      node["amenity"="charging_station"](around:10000,$lat,$lon);
      way["amenity"="charging_station"](around:10000,$lat,$lon);
      relation["amenity"="charging_station"](around:10000,$lat,$lon);
    );
    out center;
    ''';

    final url = Uri.https(
      'overpass-api.de',
      '/api/interpreter',
      {'data': query},
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;

        final markers = elements.map((e) {
          final lat = e['lat'] ?? e['center']?['lat'];
          final lon = e['lon'] ?? e['center']?['lon'];
          final amenity = e['tags']?['amenity'];

          if (lat == null || lon == null) return null;

          return Marker(
            point: LatLng(lat, lon),
            width: 40,
            height: 40,
            child: Icon(
              amenity == 'charging_station'
                  ? Icons.electrical_services
                  : Icons.local_gas_station,
              color: amenity == 'charging_station'
                  ? const Color.fromARGB(255, 7, 197, 35)
                  : Colors.red,
              size: 30,
            ),
          );
        }).whereType<Marker>().toList();

        setState(() => _stationMarkers = markers);
      } else {
        setState(() => _error = 'Failed to fetch stations');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'SDAR')));
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            const Center(
              child: Text(
                "Nearby Services",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavbar(index: 0),
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
                MarkerLayer(markers: [
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
                ]),
              ],
            ),
    );
  }
}
