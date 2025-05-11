import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/widgets/scaffold.dart';
import 'package:sdar/bar%20graph/bar_graph.dart';
import 'package:sdar/bar%20graph/stackedbar_graph.dart';
import 'package:sdar/line graph/line_graph.dart';
import 'package:fl_chart/fl_chart.dart';

class TravelTrendsPage extends StatefulWidget {
  const TravelTrendsPage({super.key});

  @override
  State<TravelTrendsPage> createState() => _StateTravelTrendsPage();
}

class _StateTravelTrendsPage extends State<TravelTrendsPage> {
  final List<List<double>> tripDistanceTimeRaw = [
    [50.0, 120.0],   // Moderate distance, long time
    [110.0, 40.0],   // Long distance, short time
    [30.0, 80.0],    // Short distance, moderate time
    [90.0, 150.0],   // Long distance and long time
    [10.0, 20.0],    // Very short trip
    [65.0, 110.0],   // Mid-range trip
    [85.0, 60.0],    // Longish distance, mid time
    [25.0, 180.0],   // Short distance, very long time
    [120.0, 70.0],   // Max distance, reasonable time
    [40.0, 55.0],    // Modest distance and time
  ];

  
  @override
  Widget build(BuildContext context) {
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
    507.5
  ];

    final spots = List.generate(
      tripEstimatedCost.length,
      (index) => FlSpot(index.toDouble(), tripEstimatedCost[index]),
    );

    return FScaffold(
      header: FHeader(title: const Text('Travel Trends')),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),  // Adjust spacing if necessary
            SizedBox(
              height: 400,  // Adjust the height of the stacked bar graph
              child: MyStackedBarGraph(
                tripSegments: tripDistanceTimeRaw,
              ),
            ),
            const SizedBox(height: 30),  // Add some space between the graphs
            SizedBox(
              height: 200,  // Adjust the height of the bar graph
              child: MyLineGraph(dataPoints: spots, maxY: tripEstimatedCost.reduce((a, b) => a > b ? a : b) + 200),
            ),
          ],
        ),
      ),
    );
  }
}
