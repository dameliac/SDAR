import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyStackedBarGraph extends StatelessWidget {
  final List<List<double>> tripSegments;

  const MyStackedBarGraph({super.key, required this.tripSegments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Total Travel Time and Distance Per Trip',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'Normalized Value (%)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _buildBarGroups(),
                    titlesData: FlTitlesData(
                     bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, _) {
                          return Text('T${value.toInt() + 1}', style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                     leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 20,
                        getTitlesWidget: (value, _) {
                          if (value % 10 != 0) return const SizedBox.shrink(); // cleaner scale
                          return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),

                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                        border: const Border(
                          left: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                        )),
                    gridData: FlGridData(show: true),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Trip Index',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
  // Find max values across all segments by index
  double maxDistance = tripSegments.map((e) => e[0]).reduce((a, b) => a > b ? a : b);
  double maxTime = tripSegments.map((e) => e[1]).reduce((a, b) => a > b ? a : b);

  return List.generate(tripSegments.length, (i) {
    final trip = tripSegments[i];

    // Normalise each segment to percentage of its type's maximum
    final normalisedDistance = (trip[0] / maxDistance) * 100;
    final normalisedTime = (trip[1] / maxTime) * 100;

    double runningTotal = 0;
    final barRods = [
      BarChartRodStackItem(
        runningTotal,
        runningTotal + normalisedDistance,
        _getColorForIndex(0),
      ),
      BarChartRodStackItem(
        runningTotal + normalisedDistance,
        runningTotal + normalisedDistance + normalisedTime,
        _getColorForIndex(1),
      ),
    ];

    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: normalisedDistance + normalisedTime,
          rodStackItems: barRods,
          width: 20,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  });
}



  Color _getColorForIndex(int index) {
    if (index == 0) return Colors.blue;
    if (index == 1) return Colors.orange;
    return Colors.grey;
  }
}
