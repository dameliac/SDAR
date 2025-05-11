import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyLineGraph extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final double maxY;

  const MyLineGraph({
    super.key,
    required this.dataPoints,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black),
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: const Text('Cost (JMD)', style: TextStyle(fontSize: 12)),
                  axisNameSize: 30,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: maxY / 5,
                    getTitlesWidget: (value, _) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Trips', style: TextStyle(fontSize: 12)),
                  axisNameSize: 30,
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final labels = [
                        'T1', 'T2', 'T3', 'T4', 'T5',
                        'T6', 'T7', 'T8', 'T9', 'T10'
                      ];
                      if (value.toInt() >= 0 && value.toInt() < labels.length) {
                        return Text(labels[value.toInt()], style: const TextStyle(fontSize: 10));
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 32,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Manual Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12, height: 12, color: Colors.blue),
            const SizedBox(width: 8),
            const Text('Cost per Trip'),
          ],
        ),
      ],
    );
  }
}
