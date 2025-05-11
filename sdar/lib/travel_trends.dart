import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/widgets/scaffold.dart';
import 'package:sdar/bar%20graph/bar_graph.dart';
import 'package:sdar/bar%20graph/stackedbar_graph.dart';
import 'package:sdar/line graph/line_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';

class TravelTrendsPage extends StatefulWidget {
  const TravelTrendsPage({super.key});

  @override
  State<TravelTrendsPage> createState() => _StateTravelTrendsPage();
}

class _StateTravelTrendsPage extends State<TravelTrendsPage> {
  String selectedVehicleType = 'Gas';

  final List<List<double>> tripDistanceTimeRaw = [
    [50.0, 120.0],
    [110.0, 40.0],
    [30.0, 80.0],
    [90.0, 150.0],
    [10.0, 20.0],
    [65.0, 110.0],
    [85.0, 60.0],
    [25.0, 180.0],
    [120.0, 70.0],
    [40.0, 55.0],
  ];

  final List<double> tripEstimatedCost = [
    1697.5,
    752.5,
    1715,
    647.5,
    805,
    2117.5,
    367.5,
    1925,
    1995,
    507.5,
  ];

  final List<double> gasFuelUsed = [4.2, 5.1, 3.8, 6.0];
  final List<double> evEnergyUsed = [12.0, 10.5, 13.2, 11.7];
  final List<Map<String, double>> hybridData = [
    {'fuel': 2.1, 'electric': 6.0},
    {'fuel': 1.8, 'electric': 7.0},
    {'fuel': 2.5, 'electric': 5.5},
    {'fuel': 2.0, 'electric': 6.2},
  ];

  List<BarChartGroupData> getBarGroups() {
    if (selectedVehicleType == 'Gas') {
      return gasFuelUsed.asMap().entries.map((entry) {
        return BarChartGroupData(x: entry.key, barRods: [
          BarChartRodData(toY: entry.value, color: Colors.green, borderRadius: BorderRadius.circular(2),  width: 25),
        ]);
      }).toList();
    } else if (selectedVehicleType == 'EV') {
      return evEnergyUsed.asMap().entries.map((entry) {
        return BarChartGroupData(x: entry.key, barRods: [
          BarChartRodData(toY: entry.value, color: Colors.blue,borderRadius: BorderRadius.circular(2),  width: 25),
        ]);
      }).toList();
    } else {
      return hybridData.asMap().entries.map((entry) {
        final fuel = entry.value['fuel']!;
        final electric = entry.value['electric']!;
        return BarChartGroupData(x: entry.key, barRods: [
          BarChartRodData(toY: fuel + electric, color: Colors.transparent, rodStackItems: [
            BarChartRodStackItem(0, fuel, Colors.orange),
            BarChartRodStackItem(fuel, fuel + electric, Colors.purple),
          ], borderRadius: BorderRadius.circular(2), width: 25),
        ]);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(
      tripEstimatedCost.length,
      (index) => FlSpot(index.toDouble(), tripEstimatedCost[index]),
    );

    return FScaffold(
      header: FHeader(title: Stack(
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
            Center(
              child: Text(
                "Travel Trends",
                textAlign: TextAlign.center,
                
              ),
            ),
          ],
        )),
        footer: AppNavbar(index: 0),
      content: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1.6,
                child: MyStackedBarGraph(tripSegments: tripDistanceTimeRaw),
              ),
              const SizedBox(height: 20),

              const Text(
                'Trip Estimated Costs (Line Graph)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.6,
                  child: MyLineGraph(
                    dataPoints: spots,
                    maxY: tripEstimatedCost.reduce((a, b) => a > b ? a : b) + 200,
                  ),
                ),

              const SizedBox(height: 5),

              const Text(
                'Energy Usage by Vehicle Type',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ToggleButtons(
                isSelected: [
                  selectedVehicleType == 'Gas',
                  selectedVehicleType == 'EV',
                  selectedVehicleType == 'Hybrid',
                ],
                onPressed: (index) {
                  setState(() {
                    selectedVehicleType = ['Gas', 'EV', 'Hybrid'][index];
                  });
                },
                children: const [
                  Padding(padding: EdgeInsets.all(8), child: Text('Gas')),
                  Padding(padding: EdgeInsets.all(8), child: Text('EV')),
                  Padding(padding: EdgeInsets.all(8), child: Text('Hybrid')),
                ],
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.6,
                child:MyBarGraph(
                    barGroups: getBarGroups(),
                    maxY: getBarGroups()
                            .expand((g) => g.barRods)
                            .map((r) => r.toY)
                            .fold(0.0, (prev, curr) => curr > prev ? curr : prev) + 2,
                    leftAxisLabel: selectedVehicleType == 'EV' ? 'kWh Used' : 'Fuel (L)',
                    bottomAxisLabel: 'Trip',
                  ),

              ),
              const SizedBox(height: 40),
              
            ],
          ),
        ),
      ),
    );
  }
}
