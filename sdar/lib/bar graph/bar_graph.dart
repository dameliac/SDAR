import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sdar/bar%20graph/bar_data.dart';

class MyBarGraph extends StatelessWidget{
  final List tripSummary;
  final double maxY;
  const MyBarGraph({super.key, required this.tripSummary, required this.maxY});

  @override
  Widget build (BuildContext context) {
    BarData myBarData = BarData(
      Trip1: tripSummary[0], 
      Trip2: tripSummary[1], 
      Trip3: tripSummary[2], 
      Trip4: tripSummary[3], 
      Trip5: tripSummary[4], 
      Trip6: tripSummary[5], 
      Trip7: tripSummary[6], 
      Trip8: tripSummary[7], 
      Trip9: tripSummary[8], 
      Trip10: tripSummary[9]
      );

      myBarData.initialiseBarData();

    return BarChart(
      BarChartData(
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        maxY: maxY,
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 500, // Adjust to fit your range
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Cost (JMD)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            axisNameSize: 30,
            
            sideTitles: SideTitles(
              showTitles: true,
              interval: 500,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              ),
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Trip', style: TextStyle(fontSize: 12)),
            axisNameSize: 30,
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final labels = [
                  'Trip 1', 'Trip 2', 'Trip 3', 'Trip 4', 'Trip 5',
                  'Trip 6', 'Trip 7', 'Trip 8', 'Trip 9', 'Trip 10'
                ];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Text(labels[value.toInt()], style: const TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: myBarData.barData.map((data) => BarChartGroupData(
          x: data.x,
          barRods: [
            BarChartRodData(
              toY: data.y,
              color: Colors.red,
              width: 20,
              borderRadius: BorderRadius.circular(2),
            )
          ],
        )).toList(),
      ),
    );

  }
}