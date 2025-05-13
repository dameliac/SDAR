import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/widgets/scaffold.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/bar%20graph/bar_graph.dart';
import 'package:sdar/bar%20graph/stackedbar_graph.dart';
import 'package:sdar/home.dart';
import 'package:sdar/line graph/line_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';
import 'package:intl/intl.dart';

class TravelTrendsPage extends StatefulWidget {
  const TravelTrendsPage({super.key});

  @override
  State<TravelTrendsPage> createState() => _StateTravelTrendsPage();
}

class _StateTravelTrendsPage extends State<TravelTrendsPage> {
  int selectedGraphIndex = 0;
  int selectedWeekIndex = 0; // Add a selected week index
  
  // List week1 = [];
  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }
  // Restructure data to include historical weeks (4 weeks per month, for 3 months)
  // Format: Vehicle -> Month -> Week -> Daily Trips (7 days per week)
  final Map<String, List<List<List<double>>>> vehicleModelCostsHistory = {
    'Prius': [
      // Current month
      [
        // Week 1 - Multiple trips per day (7 days)
        [245.5, 182.0, 310.5, 275.0, 295.5, 225.0, 164.0],
        // Week 2
        [128.5, 98.0, 115.5, 105.0, 132.5, 89.0, 84.0],
        // Week 3
        [220.0, 245.5, 212.0, 310.5, 278.0, 225.0, 224.0],
        // Week 4
        [82.5, 95.0, 112.0, 88.0, 105.0, 90.0, 75.0],
      ],
      // Last month
      [
        // Week 1
        [210.0, 175.0, 285.0, 260.0, 270.0, 180.0, 170.0],
        // Week 2
        [120.5, 108.0, 125.0, 115.0, 142.0, 110.0, 105.0],
        // Week 3
        [198.0, 215.0, 190.0, 280.0, 245.0, 165.0, 97.0],
        // Week 4
        [95.0, 115.0, 132.0, 98.0, 120.0, 105.0, 110.0],
      ],
      // Two months ago
      [
        // Week 1
        [175.0, 150.0, 210.0, 225.0, 180.0, 160.0, 100.0],
        // Week 2
        [140.0, 95.0, 138.5, 120.0, 153.0, 132.0, 112.0],
        // Week 3
        [222.0, 235.0, 208.0, 315.0, 245.0, 175.0, 110.0],
        // Week 4
        [88.0, 102.0, 124.0, 92.0, 115.0, 85.0, 89.0],
      ],
    ],
    'CR-V': [
      // Current month
      [
        // Week 1
        [115.0, 98.0, 125.0, 142.0, 105.0, 120.0, 100.0],
        // Week 2
        [310.0, 280.0, 345.0, 392.5, 315.0, 275.0, 200.0],
        // Week 3
        [52.5, 48.0, 55.0, 62.0, 50.0, 45.0, 55.0],
        // Week 4
        [275.0, 262.0, 310.0, 345.0, 298.0, 245.0, 190.0],
      ],
      // Last month
      [
        // Week 1
        [105.0, 92.0, 118.0, 135.0, 98.0, 112.0, 90.0],
        // Week 2
        [290.0, 265.0, 320.0, 380.0, 305.0, 250.0, 170.0],
        // Week 3
        [65.0, 55.0, 62.0, 75.0, 58.0, 50.0, 60.0],
        // Week 4
        [255.0, 242.0, 290.0, 325.0, 280.0, 208.0, 150.0],
      ],
      // Two months ago
      [
        // Week 1
        [120.0, 105.0, 132.0, 148.0, 110.0, 125.0, 85.0],
        // Week 2
        [298.0, 275.0, 335.0, 402.0, 310.0, 260.0, 170.0],
        // Week 3
        [58.0, 52.0, 59.0, 68.0, 55.0, 48.0, 55.0],
        // Week 4
        [268.0, 255.0, 302.0, 340.0, 292.0, 228.0, 165.0],
      ],
    ],
    'Probox': [
      // Current month
      [
        // Week 1
        [290.0, 275.0, 320.0, 345.0, 295.0, 270.0, 200.0],
        // Week 2
        [75.0, 68.0, 82.5, 95.0, 72.0, 60.0, 55.0],
        // Week 3
        [190.0, 175.0, 210.0, 230.0, 195.0, 170.0, 130.0],
        // Week 4
        [125.0, 118.0, 146.0, 158.0, 132.0, 110.0, 86.0],
      ],
      // Last month
      [
        // Week 1
        [270.0, 255.0, 298.0, 325.0, 285.0, 250.0, 167.0],
        // Week 2
        [80.0, 74.0, 88.0, 102.0, 78.0, 66.0, 62.0],
        // Week 3
        [205.0, 190.0, 225.0, 245.0, 210.0, 175.0, 170.0],
        // Week 4
        [135.0, 128.0, 156.0, 168.0, 138.0, 105.0, 85.0],
      ],
      // Two months ago
      [
        // Week 1
        [280.0, 265.0, 310.0, 338.0, 290.0, 260.0, 177.0],
        // Week 2
        [78.0, 70.0, 85.0, 98.0, 75.0, 64.0, 60.0],
        // Week 3
        [198.0, 182.0, 215.0, 235.0, 205.0, 180.0, 165.0],
        // Week 4
        [130.0, 122.0, 152.0, 162.0, 135.0, 108.0, 86.0],
      ],
    ],
  };

  final Map<String, List<List<List<double>>>> vehicleModelFuelHistory = {
    'Prius': [
      // Current month
      [
        // Week 1 (7 days)
        [1.2, 1.0, 1.4, 1.3, 1.2, 1.1, 0.9], 
        // Week 2
        [1.3, 1.1, 1.5, 1.2, 1.3, 1.2, 1.2],
        // Week 3
        [1.1, 1.3, 1.2, 1.4, 1.3, 0.9, 0.8],
        // Week 4
        [1.2, 1.0, 1.3, 1.2, 1.3, 1.1, 1.1],
      ],
      // Last month
      [
        // Week 1
        [1.1, 0.9, 1.3, 1.2, 1.2, 1.0, 1.1],
        // Week 2
        [1.2, 1.1, 1.4, 1.3, 1.2, 1.2, 1.1],
        // Week 3
        [1.0, 1.2, 1.1, 1.3, 1.2, 1.0, 0.9],
        // Week 4
        [1.1, 1.0, 1.2, 1.3, 1.2, 1.1, 1.1],
      ],
      // Two months ago
      [
        // Week 1
        [1.0, 0.9, 1.2, 1.2, 1.1, 1.0, 1.1],
        // Week 2
        [1.2, 1.0, 1.3, 1.2, 1.3, 1.1, 1.2],
        // Week 3
        [1.1, 1.2, 1.0, 1.3, 1.2, 1.0, 1.1],
        // Week 4
        [1.1, 0.9, 1.2, 1.2, 1.1, 1.1, 1.1],
      ],
    ],
    'CR-V': [
      // Current month
      [
        // Week 1
        [0.6, 0.5, 0.7, 0.6, 0.6, 0.7, 0.5],
        // Week 2
        [0.8, 0.7, 0.8, 0.7, 0.8, 0.7, 0.6],
        // Week 3
        [0.5, 0.6, 0.5, 0.7, 0.6, 0.5, 0.4],
        // Week 4
        [0.9, 0.8, 1.0, 0.9, 0.8, 0.9, 0.7],
      ],
      // Last month
      [
        // Week 1
        [0.5, 0.5, 0.6, 0.6, 0.5, 0.7, 0.6],
        // Week 2
        [0.7, 0.6, 0.7, 0.8, 0.7, 0.7, 0.6],
        // Week 3
        [0.5, 0.4, 0.6, 0.5, 0.6, 0.5, 0.4],
        // Week 4
        [0.8, 0.7, 0.9, 0.8, 0.8, 0.9, 0.8],
      ],
      // Two months ago
      [
        // Week 1
        [0.6, 0.5, 0.7, 0.7, 0.6, 0.6, 0.6],
        // Week 2
        [0.7, 0.8, 0.7, 0.7, 0.8, 0.7, 0.6],
        // Week 3
        [0.5, 0.5, 0.6, 0.6, 0.5, 0.5, 0.5],
        // Week 4
        [0.8, 0.8, 0.9, 0.9, 0.8, 0.8, 0.8],
      ],
    ],
    'Probox': [
      // Current month
      [
        // Week 1
        [1.8, 1.6, 1.9, 1.7, 1.8, 1.6, 1.6],
        // Week 2
        [1.5, 1.3, 1.6, 1.5, 1.6, 1.5, 1.5],
        // Week 3
        [2.0, 1.8, 2.1, 1.9, 2.0, 1.8, 1.6],
        // Week 4
        [1.7, 1.5, 1.8, 1.7, 1.7, 1.6, 1.7],
      ],
      // Last month
      [
        // Week 1
        [1.7, 1.5, 1.8, 1.6, 1.7, 1.5, 1.9],
        // Week 2
        [1.4, 1.3, 1.5, 1.4, 1.5, 1.6, 1.5],
        // Week 3
        [1.9, 1.7, 2.0, 1.8, 1.9, 1.7, 1.8],
        // Week 4
        [1.6, 1.5, 1.7, 1.6, 1.7, 1.5, 1.8],
      ],
      // Two months ago
      [
        // Week 1
        [1.8, 1.6, 1.9, 1.7, 1.8, 1.6, 1.5],
        // Week 2
        [1.5, 1.4, 1.6, 1.5, 1.5, 1.5, 1.4],
        // Week 3
        [2.0, 1.8, 2.1, 1.9, 2.0, 1.7, 1.5],
        // Week 4
        [1.7, 1.6, 1.8, 1.7, 1.7, 1.5, 1.5],
      ],
    ],
  };

  final Map<String, List<List<List<List<double>>>>> vehicleModelSegmentsHistory = {
    'Prius': [
      // Current month
      [
        // Week 1 - [Distance, Time] for each day of the week
        [
          [8.5, 100.0], // Monday
          [7.2, 15.0], // Tuesday
          [12.0, 22.0], // Wednesday
          [10.5, 20.0], // Thursday
          [11.0, 21.0], // Friday
          [9.0, 16.0], // Saturday
          [6.5, 12.0], // Sunday
        ],
        // Week 2
        [
          [5.0, 10.0],
          [4.0, 8.0],
          [4.5, 9.0],
          [4.2, 8.5],
          [5.5, 11.0],
          [3.5, 7.0],
          [3.3, 6.5],
        ],
        // Week 3
        [
          [9.0, 17.0],
          [10.0, 19.0],
          [8.5, 16.0],
          [12.5, 24.0],
          [11.0, 21.0],
          [9.0, 17.0],
          [8.0, 15.0],
        ],
        // Week 4
        [
          [3.0, 6.0],
          [3.5, 7.0],
          [4.5, 9.0],
          [3.2, 6.5],
          [4.0, 8.0],
          [3.3, 6.5],
          [2.5, 5.0],
        ],
      ],
      // Last month
      [
        // Week 1
        [
          [8.0, 16.0],
          [6.5, 13.0],
          [11.0, 20.0],
          [10.0, 19.0],
          [10.5, 20.0],
          [7.0, 14.0],
          [6.8, 13.5],
        ],
        // Week 2
        [
          [4.8, 9.5],
          [4.2, 8.5],
          [5.0, 10.0],
          [4.5, 9.0],
          [5.8, 11.5],
          [4.5, 9.0],
          [4.2, 8.5],
        ],
        // Week 3
        [
          [8.0, 15.0],
          [8.5, 16.0],
          [7.5, 14.0],
          [11.0, 21.0],
          [9.8, 19.0],
          [6.5, 13.0],
          [3.8, 7.5],
        ],
        // Week 4
        [
          [3.5, 7.0],
          [4.2, 8.5],
          [5.0, 10.0],
          [3.6, 7.2],
          [4.5, 9.0],
          [4.0, 8.0],
          [4.2, 8.5],
        ],
      ],
      // Two months ago
      [
        // Week 1
        [
          [7.0, 14.0],
          [6.0, 12.0],
          [8.5, 17.0],
          [9.0, 18.0],
          [7.2, 14.5],
          [6.5, 13.0],
          [4.0, 8.0],
        ],
        // Week 2
        [
          [5.5, 11.0],
          [3.8, 7.5],
          [5.5, 11.0],
          [4.8, 9.5],
          [6.0, 12.0],
          [5.2, 10.5],
          [4.5, 9.0],
        ],
        // Week 3
        [
          [9.0, 18.0],
          [9.5, 19.0],
          [8.5, 17.0],
          [12.5, 25.0],
          [10.0, 20.0],
          [7.0, 14.0],
          [4.5, 9.0],
        ],
        // Week 4
        [
          [3.5, 7.0],
          [4.0, 8.0],
          [5.0, 10.0],
          [3.7, 7.5],
          [4.6, 9.2],
          [3.5, 7.0],
          [3.7, 7.5],
        ],
      ],
    ],










    'CR-V': [
      // Current month
      [
        // Week 1
        [
          [2.0, 4.0],
          [1.8, 3.5],
          [2.2, 4.5],
          [2.5, 5.0],
          [2.0, 4.0],
          [2.0, 4.0],
          [1.6, 3.2],
        ],
        // Week 2
        [
          [10.5, 20.0],
          [9.5, 18.0],
          [11.5, 22.0],
          [13.0, 25.0],
          [10.5, 20.0],
          [9.0, 17.0],
          [6.5, 12.5],
        ],
        // Week 3
        [
          [1.5, 3.0],
          [1.3, 2.5],
          [1.6, 3.2],
          [1.8, 3.6],
          [1.4, 2.8],
          [1.3, 2.6],
          [1.6, 3.2],
        ],
        // Week 4
        [
          [4.0, 30.0],
          [3.8, 28.0],
          [4.5, 35.0],
          [5.0, 38.0],
          [4.2, 32.0],
          [3.5, 25.0],
          [2.8, 20.0],
        ],
      ],
      // Last month
      [
        // Week 1
        [
          [1.8, 3.6],
          [1.6, 3.2],
          [2.0, 4.0],
          [2.3, 4.6],
          [1.8, 3.6],
          [1.9, 3.8],
          [1.5, 3.0],
        ],
        // Week 2
        [
          [9.8, 19.0],
          [9.0, 17.0],
          [10.8, 21.0],
          [12.5, 24.0],
          [10.0, 19.0],
          [8.5, 16.0],
          [5.8, 11.0],
        ],
        // Week 3
        [
          [1.8, 3.6],
          [1.6, 3.2],
          [1.8, 3.6],
          [2.0, 4.0],
          [1.6, 3.2],
          [1.5, 3.0],
          [1.7, 3.4],
        ],
        // Week 4
        [
          [3.8, 28.0],
          [3.6, 26.0],
          [4.2, 32.0],
          [4.8, 36.0],
          [4.0, 30.0],
          [3.0, 22.0],
          [2.2, 16.0],
        ],
      ],
      // Two months ago
      [
        // Week 1
        [
          [2.0, 4.0],
          [1.8, 3.6],
          [2.2, 4.4],
          [2.5, 5.0],
          [2.0, 4.0],
          [2.0, 4.0],
          [1.4, 2.8],
        ],
        // Week 2
        [
          [10.0, 19.0],
          [9.2, 18.0],
          [11.2, 22.0],
          [13.2, 26.0],
          [10.2, 20.0],
          [8.5, 17.0],
          [5.6, 11.0],
        ],
        // Week 3
        [
          [1.6, 3.2],
          [1.5, 3.0],
          [1.7, 3.4],
          [1.9, 3.8],
          [1.5, 3.0],
          [1.4, 2.8],
          [1.6, 3.2],
        ],
        // Week 4
        [
          [3.9, 29.0],
          [3.7, 27.0],
          [4.4, 33.0],
          [4.9, 37.0],
          [4.1, 31.0],
          [3.3, 24.0],
          [2.4, 18.0],
        ],
      ],
    ],
    'Probox': [
      // Current month
      [
        // Week 1
        [
          [20.0, 12.0],
          [19.0, 11.0],
          [22.0, 13.0],
          [23.0, 14.0],
          [20.0, 12.0],
          [18.0, 10.5],
          [14.0, 8.0],
        ],
        // Week 2
        [
          [6.5,  5.0],
          [19.0, 16.0],
          [22.0, 11.0],
          [23.0, 12.0],
          [20.0, 19.0],
          [18.0, 3.5],
          [14.0, 2.0],]

      ]
    ]
  };

  final List<String> vehicleModels = ['Prius', 'CR-V', 'Probox'];
  String selectedModel = 'Prius';
  
  // Track the current viewing month (0 = current month, 1 = last month, etc.)
  int selectedMonthOffset = 0;
  
  // Maximum historical months to show
  final int maxMonths = 3;

  // Get date information for week navigation
  DateTime getStartDateForMonthOffset(int monthOffset) {
    final now = DateTime.now();
    return DateTime(now.year, now.month - monthOffset, 1);
  }

  String getMonthTitle() {
    final date = getStartDateForMonthOffset(selectedMonthOffset);
    return DateFormat('MMMM yyyy').format(date);
  }

  String getWeekTitle(int weekIndex) {
    final date = getStartDateForMonthOffset(selectedMonthOffset);
    final firstDay = DateTime(date.year, date.month, 1);
    final weekStart = firstDay.add(Duration(days: weekIndex * 7));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    // Format: "May 1 - May 7"
    return '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}';
  }

  void nextWeek() {
    setState(() {
      selectedWeekIndex++;
      if (selectedWeekIndex > 3) {
        selectedWeekIndex = 0;
        selectedMonthOffset = (selectedMonthOffset + 1) % maxMonths;
      }
    });
  }

  void previousWeek() {
    setState(() {
      selectedWeekIndex--;
      if (selectedWeekIndex < 0) {
        selectedWeekIndex = 3;
        selectedMonthOffset = (selectedMonthOffset - 1) % maxMonths;
        if (selectedMonthOffset < 0) selectedMonthOffset = maxMonths - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the selected data for the current week and month
    final selectedCost = vehicleModelCostsHistory[selectedModel]![selectedMonthOffset][selectedWeekIndex];
    final selectedFuel = vehicleModelFuelHistory[selectedModel]![selectedMonthOffset][selectedWeekIndex];
    final selectedSegments = vehicleModelSegmentsHistory[selectedModel]![selectedMonthOffset][selectedWeekIndex];
    
    final spots = List.generate(
      selectedCost.length,
      (index) => FlSpot(index.toDouble(), selectedCost[index]),
    );

    final List<Widget> graphWidgets = [
      MyStackedBarGraph(tripSegments: selectedSegments),
      MyLineGraph(
        dataPoints: spots,
        maxY: selectedCost.reduce((a, b) => a > b ? a : b) + 200,
      ),
      MyBarGraph(
        barGroups: selectedFuel.asMap().entries.map((entry) {
          return BarChartGroupData(x: entry.key, barRods: [
            BarChartRodData(toY: entry.value, width: 25, color: Colors.green, borderRadius: BorderRadius.circular(2)),
          ]);
        }).toList(),
        maxY: selectedFuel.reduce((a, b) => a > b ? a : b) + 2,
        leftAxisLabel: selectedModel == 'CR-V' ? 'kWh Used' : 'Fuel (L)',
        bottomAxisLabel: 'Week',
        bottomTitles: ['Wk1', 'Wk2', 'Wk3', 'Wk4'],
      )
    ];

    return Consumer<AppProvider>(
      builder: (builder , app , child)=>FScaffold(
        header: FHeader(
          actions: [
            FButton(onPress: () async{
              await app.trends();
            }, label: Text('Sync'))
          ],
          title: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    // Navigator.pop(context); //TODO chnage it back to replacement
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'SDAR')));
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              const Center(child: Text("Travel Trends")),
            ],
          ),
        ),
        footer: AppNavbar(index: 0),
        content: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Vehicle model selection
                Align(
                  alignment: Alignment.centerRight,
                  child: 
                ToggleButtons(
                  isSelected: vehicleModels.map((m) => m == selectedModel).toList(),
                  onPressed: (index) => setState(() => selectedModel = vehicleModels[index]),
                  children: vehicleModels.map((model) => Padding(padding: const EdgeInsets.all(8), child: Text(model))).toList(),
                ),
                ),
                const SizedBox(height: 20),
                
                // Graph type selection
                ToggleButtons(
                  isSelected: List.generate(3, (i) => i == selectedGraphIndex),
                  onPressed: (index) => setState(() => selectedGraphIndex = index),
                  children: const [
                    Padding(padding: EdgeInsets.all(8), child: Text('Distance and Time')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Estimated Cost')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Consumption')),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Week navigation controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: previousWeek,
                    ),
                    Column(
                      children: [
                        Text(
                          getMonthTitle(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getWeekTitle(selectedWeekIndex),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: nextWeek,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Graph display
                AspectRatio(aspectRatio: 1.6, child: graphWidgets[selectedGraphIndex]),
                
                const SizedBox(height: 16),
                
                // Additional weekly summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weekly Summary",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryItem("Total Distance", 
                          "${selectedSegments[0][0]} km", 
                          Icons.straighten),
                        _buildSummaryItem("Total Time", 
                          "${selectedSegments[0][1]} min", 
                          Icons.access_time),
                        _buildSummaryItem("Cost", 
                          "\$${selectedCost[0].toStringAsFixed(2)}", 
                          Icons.attach_money),
                        _buildSummaryItem(
                          selectedModel == 'CR-V' ? "Energy Used" : "Fuel Used", 
                          selectedModel == 'CR-V' 
                            ? "${selectedFuel[0].toStringAsFixed(1)} kWh" 
                            : "${selectedFuel[0].toStringAsFixed(1)} L", 
                          selectedModel == 'CR-V' ? Icons.battery_charging_full : Icons.local_gas_station),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}