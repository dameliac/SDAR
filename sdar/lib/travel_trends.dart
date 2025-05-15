import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/widgets/scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:sdar/bar%20graph/bar_graph.dart';
import 'package:sdar/bar%20graph/stackedbar_graph.dart';
import 'package:sdar/line graph/line_graph.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';
import 'package:intl/intl.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

//IMPROVED USING CLAUDE AI
class TravelTrendsPage extends StatefulWidget {
  const TravelTrendsPage({super.key});

  @override
  State<TravelTrendsPage> createState() => _StateTravelTrendsPage();
}

class _StateTravelTrendsPage extends State<TravelTrendsPage> {
  int selectedGraphIndex = 0;
  int selectedWeekIndex = 0;
  
  List<String> routeIDs = [];
  List<double> distances = [];
  List<double> durations = [];
  List<DateTime> executionDates = [];
  List<double> fuelConsumptions = [];
  List<double> evConsumptions = [];
  List<List<double>> distanceTime = [];
  List<double> totalCosts = [];
  
  // Constants
  final double avgGasPrice = 127.0512;
  final double evPrice = 90.0;
  
  // Vehicle info
  List<Map<String, dynamic>> vehicles = [];
  double? combE;
  double chargeTime120 = 0.0;
  double chargeTime240 = 0.0;
  bool isElectricVehicle = false;
  
  // Weekly data
  List<Map<String, dynamic>> weeklyData = [];
  List<String> weekLabels = [];
  bool isLoading = true;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      await fetchTravelHistory();
      if (routeIDs.isNotEmpty) {
        await fetchRoutes();
        await fetchVehicleModel();
        await determineVehicleType();
        await costCalculations();
        await organizeWeeklyData();
        
        setState(() {
          hasData = distances.isNotEmpty;
          isLoading = false;
        });
      } else {
        setState(() {
          hasData = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        hasData = false;
        isLoading = false;
      });
    }
  }

  // Organize data by weeks
  Future<void> organizeWeeklyData() async {
    if (executionDates.isEmpty) return;
    
    // Sort data by date
    final List<int> indices = List.generate(executionDates.length, (index) => index);
    indices.sort((a, b) => executionDates[a].compareTo(executionDates[b]));
    
    // Reorder all data lists based on sorted dates
    executionDates = indices.map((i) => executionDates[i]).toList();
    distances = indices.map((i) => distances[i]).toList();
    durations = indices.map((i) => durations[i]).toList();
    fuelConsumptions = indices.map((i) => fuelConsumptions[i]).toList();
    evConsumptions = indices.map((i) => isElectricVehicle && i < evConsumptions.length ? evConsumptions[i] : 0.0).toList();
    totalCosts = indices.map((i) => i < totalCosts.length ? totalCosts[i] : 0.0).toList();
    
    // Group data by week
    Map<String, Map<String, dynamic>> weeks = {};
    
    for (int i = 0; i < executionDates.length; i++) {
      final date = executionDates[i];
      // Get start of week (Monday)
      final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
      final weekKey = DateFormat('yyyy-MM-dd').format(startOfWeek);
      final weekLabel = '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d').format(startOfWeek.add(const Duration(days: 6)))}';
      
      if (!weeks.containsKey(weekKey)) {
        weeks[weekKey] = {
          'label': weekLabel,
          'distances': <double>[],
          'durations': <double>[],
          'fuelConsumptions': <double>[],
          'evConsumptions': <double>[],
          'totalCosts': <double>[],
          'distanceTime': <List<double>>[],
          'dates': <DateTime>[],
        };
      }
      
      weeks[weekKey]!['distances']!.add(distances[i]);
      weeks[weekKey]!['durations']!.add(durations[i]);
      weeks[weekKey]!['fuelConsumptions']!.add(fuelConsumptions[i]);
      weeks[weekKey]!['evConsumptions']!.add(i < evConsumptions.length ? evConsumptions[i] : 0.0);
      weeks[weekKey]!['totalCosts']!.add(i < totalCosts.length ? totalCosts[i] : 0.0);
      weeks[weekKey]!['distanceTime']!.add([distances[i], durations[i]]);
      weeks[weekKey]!['dates']!.add(executionDates[i]);
    }
    
    // Convert to list and sort by date
    weeklyData = weeks.entries.map((entry) => entry.value).toList();
    weeklyData.sort((a, b) {
      final DateTime dateA = a['dates'][0];
      final DateTime dateB = b['dates'][0];
      return dateB.compareTo(dateA); // Sort in descending order (newest first)
    });
    
    weekLabels = weeklyData.map((week) => week['label'] as String).toList();
    
    // Make sure selected week is valid
    if (weeklyData.isNotEmpty && selectedWeekIndex >= weeklyData.length) {
      selectedWeekIndex = 0;
    }
  }

  // USING TRAVEL HISTORY TO GET THE ROUTES THAT HAVE BEEN COMPLETED
  Future<void> fetchTravelHistory() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    PocketBase pb = appProvider.pb;

    final userId = appProvider.userdata?.record.id;
    if (userId == null) return;

    try {
      // Get the driver's record using the user ID
      final driverInfo = await pb.collection('Driver').getFirstListItem('userID = "$userId"');
      final driverID = driverInfo.id;

      // Fetch all travel history records for this driver
      final result = await pb.collection('Travel_History').getFullList(
        filter: 'driverID = "$driverID"',
      );
      
      // Extract routeID from each result
      routeIDs = result.map((record) => record.data['routeID'] as String).toList();
      print("Route IDs: $routeIDs");
    } catch (e) {
      print('Error fetching travel history: $e');
    }
  }

  // USING ROUTE ID TO GET THE TRIP INFORMATION
  Future<void> fetchRoutes() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    PocketBase pb = appProvider.pb;

    if (routeIDs.isEmpty) return;

    try {
      for (String routeId in routeIDs) {
        // Fetch route details
        final route = await pb.collection('Route').getOne(routeId);
        
        // Extract data
        distances.add(route.data['Distance'] as double);
        durations.add(route.data['Duration'] as double);
        executionDates.add(DateTime.parse(route.data['Execution_Date']));
        fuelConsumptions.add(route.data['fuelConsump'] as double);
        
        // Add distance and time pair
        distanceTime.add([
          route.data['Distance'] as double,
          route.data['Duration'] as double
        ]);
      }
      
      print('Distances: $distances');
      print('Durations: $durations');
      print('Execution dates: $executionDates');
      print('Fuel consumption: $fuelConsumptions');
    } catch (e) {
      print('Error fetching route information: $e');
    }
  }

  // USING VEHICLE TO GET THE MODEL OF THE CAR FOR FUEL AND EV CONSUMPTION - Damelia Coleman
  Future<void> fetchVehicleModel() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    PocketBase pb = appProvider.pb;

    final userId = appProvider.userdata?.record.id;
    if (userId == null) return;

    try {
      // Get the driver's record using the user ID
      final driverInfo = await pb.collection('Driver').getFirstListItem('userID = "$userId"');
      final driverID = driverInfo.id;

      // Fetch all vehicle records for this driver
      final result = await pb.collection('Vehicle').getFullList(
        filter: 'driverID = "$driverID"',
      );
      
      // Extract vehicle details
      vehicles = result.map((record) {
        return {
          'VehicleMake': record.data['VehicleMake'],
          'VehicleYear': record.data['VehicleYear'],
          'VehicleModel': record.data['VehicleModel'],
        };
      }).toList();
      
      print("Vehicles: $vehicles");
    } catch (e) {
      print('Error fetching vehicles: $e');
    }
  }

  Future<void> determineVehicleType() async {
    if (vehicles.isEmpty) return;
    
    try {
      // Use the first vehicle for simplicity
      final vehicle = vehicles[0];
      final fuelType = await getVehicleFuelType(
        vehicle['VehicleMake'], 
        vehicle['VehicleModel'], 
        vehicle['VehicleYear']
      );
      
      setState(() {
        isElectricVehicle = fuelType == 'Electric';
      });
    } catch (e) {
      print('Error determining vehicle type: $e');
    }
  }

  //USING FUEL ECONOMY API TO GET INFORMATION ABOUT THE CAR -Damelia Coleman
  Future<String> getVehicleFuelType(String make, String model, int year) async {
    try {
      // Step 1: Get vehicle ID
      final optionsUrl = 'https://www.fueleconomy.gov/ws/rest/vehicle/menu/options?year=$year&make=$make&model=$model';
      final optionsRes = await http.get(Uri.parse(optionsUrl));
      final optionsXml = XmlDocument.parse(optionsRes.body);
      final vehicleId = optionsXml.findAllElements('value').first.innerText;

      // Step 2: Get vehicle details
      final detailsUrl = 'https://www.fueleconomy.gov/ws/rest/vehicle/$vehicleId';
      final detailsRes = await http.get(Uri.parse(detailsUrl));
      final detailsXml = XmlDocument.parse(detailsRes.body);

      final fuelType1 = detailsXml.findAllElements('fuelType1').firstOrNull?.innerText;
      final fuelType2 = detailsXml.findAllElements('fuelType2').firstOrNull?.innerText;
      
      // Parse efficiency values
      final combEElement = detailsXml.findAllElements('combE').firstOrNull;
      if (combEElement != null) {
        combE = double.tryParse(combEElement.innerText);
      }
      
      final charge120Element = detailsXml.findAllElements('charge120').firstOrNull;
      if (charge120Element != null) {
        chargeTime120 = double.tryParse(charge120Element.innerText) ?? 0.0;
      }
      
      final charge240Element = detailsXml.findAllElements('charge240').firstOrNull;
      if (charge240Element != null) {
        chargeTime240 = double.tryParse(charge240Element.innerText) ?? 0.0;
      }

      // Determine vehicle type
      if (fuelType1 == 'Electricity' || fuelType2 == 'Electricity') {
        return 'Electric';
      } else if (fuelType2 != null) {
        return 'Hybrid';
      } else {
        return 'Gasoline';
      }
    } catch (e) {
      print('Error getting vehicle fuel type: $e');
      return 'Gasoline'; // Default to gasoline
    }
  }

  //CALCULATING TOTAL COST FOR ELECTRIC CARS, HYBRID (EXCLUDING PLUGIN HYBRID) AND GASOLINE - Damelia Coleman
  Future<void> costCalculations() async {
    if (vehicles.isEmpty || distances.isEmpty) return;
    
    try {
      totalCosts = [];
      evConsumptions = [];
      
      if (isElectricVehicle && combE != null) {
        // Calculate EV consumption and cost
        for (var dist in distances) {
          final evUsed = (combE! / 100) * dist;
          evConsumptions.add(evUsed);
          
          // Use charge time for cost calculation
          final chargeTime = chargeTime240 > 0 ? chargeTime240 : chargeTime120;
          totalCosts.add(chargeTime * evPrice);
        }
      } else {
        // Calculate gas cost
        for (var usage in fuelConsumptions) {
          totalCosts.add(usage * avgGasPrice);
        }
      }
    } catch (e) {
      print('Error calculating costs: $e');
    }
  }

  // Get chart data for the selected week
  List<FlSpot> getWeeklyCostLineData() {
    if (!hasData || weeklyData.isEmpty) return [];
    
    final weekCosts = weeklyData[selectedWeekIndex]['totalCosts'] as List<double>;
    return weekCosts.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  List<BarChartGroupData> getWeeklyConsumptionBarGroups() {
    if (!hasData || weeklyData.isEmpty) return [];
    
    final List<double> weekConsumption = isElectricVehicle 
      ? (weeklyData[selectedWeekIndex]['evConsumptions'] as List<double>)
      : (weeklyData[selectedWeekIndex]['fuelConsumptions'] as List<double>);
    
    return weekConsumption.asMap().entries.map((entry) {
      int index = entry.key;
      double consumption = entry.value;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
          toY: consumption,
          width: 25,
          color: isElectricVehicle ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(2),
        ),
      ]);
    }).toList();
  }

  List<List<double>> getWeeklyDistanceTime() {
    if (!hasData || weeklyData.isEmpty) return [];
    return (weeklyData[selectedWeekIndex]['distanceTime'] as List<dynamic>)
        .cast<List<double>>();
  }

  // Generate weekly summary text
  String getWeeklySummary() {
    if (!hasData || weeklyData.isEmpty) return "No weekly data available";
    
    final weekData = weeklyData[selectedWeekIndex];
    final distances = weekData['distances'] as List<double>;
    final durations = weekData['durations'] as List<double>;
    final costs = weekData['totalCosts'] as List<double>;
    
    final totalDistance = distances.fold(0.0, (sum, item) => sum + item);
    final totalDuration = durations.fold(0.0, (sum, item) => sum + item);
    final totalCost = costs.fold(0.0, (sum, item) => sum + item);
    final tripCount = distances.length;
    
    final formatter = NumberFormat("#,##0.00");
    
    return "Week Summary: $tripCount trips\n"
           "Total Distance: ${formatter.format(totalDistance)} km\n"
           "Total Duration: ${formatter.format(totalDuration)} minutes\n"
           "Total Cost: \$${formatter.format(totalCost)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  // Your onPressed logic here
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'SDAR')),
                  );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                "Travel Trends",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
                
              ),
            ),
          ],
        )),
      bottomNavigationBar: AppNavbar(index: 0),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : !hasData 
          ? const Center(child: Text("No Trends available", style: TextStyle(fontSize: 18)))
          : Column(
              children: [
                // Week selector
                if (weekLabels.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedWeekIndex,
                      items: weekLabels.asMap().entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedWeekIndex = value;
                          });
                        }
                      },
                    ),
                  ),
                  
                  // Weekly summary
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 246, 243, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getWeeklySummary(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
                
                // Graph type toggle buttons
                ToggleButtons(
                  isSelected: [0, 1, 2].map((i) => i == selectedGraphIndex).toList(),
                  onPressed: (index) {
                    setState(() {
                      selectedGraphIndex = index;
                    });
                  },
                  children: const [
                    Padding(padding: EdgeInsets.all(8), child: Text('Distance and Time')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Cost')),
                    Padding(padding: EdgeInsets.all(8), child: Text('Consumption')),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Display the selected graph
                Expanded(
                  child: weeklyData.isEmpty
                    ? const Center(child: Text("No Trends available"))
                    : IndexedStack(
                        index: selectedGraphIndex,
                        children: [
                          // Stacked bar graph for Distance and Time
                          MyStackedBarGraph(tripSegments: getWeeklyDistanceTime()),
                          
                          // Line graph for Total Cost
                          MyLineGraph(
                            dataPoints: getWeeklyCostLineData(),
                            maxY: (weeklyData[selectedWeekIndex]['totalCosts'] as List<double>)
                                .fold(0.0, (max, cost) => cost > max ? cost : max),
                          ),
                          
                          // Bar graph for Fuel/EV Consumption
                          MyBarGraph(barGroups: getWeeklyConsumptionBarGroups())
                        ],
                      ),
                ),
              ],
            ),
    );
  }
}