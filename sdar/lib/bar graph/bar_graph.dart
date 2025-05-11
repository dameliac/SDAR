import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final double? maxY;
  final String leftAxisLabel;
  final String bottomAxisLabel;
  final List<String>? bottomTitles;

  const MyBarGraph({
    super.key,
    required this.barGroups,
    this.maxY,
    this.leftAxisLabel = 'Cost (JMD)',
    this.bottomAxisLabel = 'Trip',
    this.bottomTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Fuel or Energy Usage by Trip',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        const SizedBox(height: 12),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              minY: 0,
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: (maxY ?? 1000) / 5,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    leftAxisLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  axisNameSize: 30,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxY ?? 1000) / 5,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    bottomAxisLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                  axisNameSize: 30,
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      bottomTitles != null && value.toInt() < bottomTitles!.length
                          ? bottomTitles![value.toInt()]
                          : 'Trip ${value.toInt() + 1}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    reservedSize: 30,
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              barGroups: barGroups,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Fuel or Energy', style: TextStyle(fontSize: 10, color:Colors.green ),),
            
          ],
        ),
      ],
    );
  }
}
