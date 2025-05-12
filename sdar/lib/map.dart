import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/home.dart';
import 'package:toastification/toastification.dart';


class MapScreen extends StatefulWidget {
  final List<double> start;
  final List<double> end;
  final String routeid; 
  const MapScreen({
    required this.start,
    required this.end,
    required this.routeid
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Future<List<LatLng>> _routePointsFuture;
  double _zoom = 17;
  final MapController _mapController = MapController();
  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    _routePointsFuture = Provider.of<AppProvider>(context, listen: false)
        .getPolyline(widget.start, widget.end);
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: FIcon(FAssets.icons.arrowLeft),
          )
        ],
        title: Text('Trip'),
      ),
      content: Stack(
        children: [
          FutureBuilder<List<LatLng>>(
            future: _routePointsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final routePoints = snapshot.data ?? [];
              if (routePoints.isEmpty) {
                return const Center(
                  child: Text('No route found'),
                );
              }

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialZoom: _zoom,
                  initialCenter: routePoints.first,
                  
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: routePoints.first,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                      Marker(
                        point: routePoints.last,
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          // Mark Complete Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              width: double.infinity,
              child: FButton(
                onPress: () async{
                  // TODO: Implement mark complete functionality and add to travel history
                  print('Trip marked as complete');
                  final success = await Provider.of<AppProvider>(context,listen: false).markTripComplete(widget.routeid, '100');
                  if(success){
                    toastification.show(
                      title: Text('Success'),
                      type: ToastificationType.success,
                      autoCloseDuration: Duration(seconds: 1)
                    );
                    Navigator.pop(context);
                  } else {
                    toastification.show(
                      title: Text('Failed to save route'),
                      type: ToastificationType.error,
                      autoCloseDuration: Duration(seconds: 2)
                    );
                  }
                },
                label: Text('Mark Complete'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}