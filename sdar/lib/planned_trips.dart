import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:sdar/auth/login.dart';
import 'package:sdar/main.dart';
import 'package:sdar/map.dart';
import 'package:sdar/trips.dart';
import 'package:intl/intl.dart';
import 'package:sdar/widgets/appNavBar.dart';

class PlannedTripsPage extends StatefulWidget {
  final String origin;
  const PlannedTripsPage({super.key, required this.origin});

  @override
  State<StatefulWidget> createState() => _StatePlannedTripsPage();
}

class _StatePlannedTripsPage extends State<PlannedTripsPage> {
  late final int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.origin == 'home' ? 0 : 2;
    // Fetch trips when page loads
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<AppProvider>().getTrips();
    // });
    Provider.of<AppProvider>(context,listen: false).getTrips();
    print("Hello");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, child) => FScaffold(
        header: FHeader(
          title: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'SDAR'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              const Center(
                child: Text(
                  "Planned Trips",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        footer: AppNavbar(index: currentIndex),
        content: Column(
          children: [
            // New Trip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 140,
                    child: FButton(
                      onPress: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Trips()),
                        );
                      },
                      label: const Text('New'),
                      // style: FButtonStyle(
                      //   enabledBoxDecoration: BoxDecoration(
                      //     color: const Color.fromRGBO(53, 124, 247, 1),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   enabledHoverBoxDecoration: BoxDecoration(
                      //     color: const Color.fromRGBO(45, 110, 220, 1),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   contentStyle: FButtonContentStyle(
                      //     enabledTextStyle: TextStyle(color: Colors.white),
                      //     disabledTextStyle: TextStyle(color: Colors.grey),
                      //     enabledIconColor: Colors.white,
                      //     disabledIconColor: Colors.grey,
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Trips ListView
            Expanded(
              child: app.trips.isEmpty
                  ? const Center(
                      child: Text('No planned trips yet'),
                    )
                  : ListView.builder(
                      itemCount: app.trips.length,
                      itemBuilder: (context, index) {
                        final trip = app.trips[index];
                        // return TripCard(
                        //   destination: trip.endName,
                        //   date: DateTime.now(), // Replace with actual date from trip
                        //   time: trip.duration > 1000? "${(trip.duration / 60).toStringAsFixed(2)} secs" : "${trip.duration} mins", // Replace with actual time from trip
                        //   onDelete: () {
                        //     // Add delete functionality
                        //     // app.deleteTrip(trip.id);
                        //   },
                        //   onExecute: () {
                        //     // Add execute functionality
                        //     // app.executeTrip(trip.id);
                        //   },
                        // );
                        return TripCard2(
                          routeID: trip.routeID,
                          startCoord: trip.startCoord,
                          endCoord: trip.endCoord,
                          to: trip.endName,
                          from: trip.startName,
                          time: trip.duration > 1000? " ${(trip.duration / 60).toStringAsFixed(2)} mins" : " ${trip.duration} secs",
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


class TripCard2 extends StatelessWidget {
  final String to;
  final String from;
  final String time;
  final String routeID;
  final List<double> startCoord;
  final List<double> endCoord;

  TripCard2({required this.to,required this.from, required this.time,required this.startCoord,required this.endCoord , required this.routeID});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FTile(
            onPress: (){
              //TODO go to a map page
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MapScreen(routeid: routeID, start:startCoord,end:endCoord)));
            },
            subtitle: Row(
              children: [
                Text('To: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
                ),
                Text(
                  maxLines: 1,
                  softWrap: true,
                  to,
                  style: TextStyle(
                    fontSize: 14
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            title: Row(
              children: [
                Text('From: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
                ),
                Text(
                  maxLines: 1,
                  softWrap: true,
                  from,
                  style: TextStyle(
                    fontSize: 14
                  ),
                ),
              ],
            ),
            suffixIcon: FIcon(FAssets.icons.arrowRight),
          ),
    );
    
  }
}
class TripCard extends StatelessWidget {
  final String destination;
  final DateTime date;
  final String time;
  final VoidCallback onDelete;
  final VoidCallback onExecute;

  const TripCard({
    Key? key,
    required this.destination,
    required this.date,
    required this.time,
    required this.onDelete,
    required this.onExecute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(243, 246, 243, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(DateFormat('MMM d yyyy').format(date)),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'ETA: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: time,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 112,
                      child: FButton(
                        onPress: onExecute,
                        label: const Text('Execute'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}