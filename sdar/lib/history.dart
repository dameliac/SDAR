import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/home.dart';
import 'package:sdar/widgets/appNavBar.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateHistory();
  }
}

class _StateHistory extends State<History> {
  @override
  void initState() {
    // Fetch history when page loads
    // Provider.of<AppProvider>(context, listen: false).getTravelHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, child) {
        final grouped = groupHistory(app.travelHistory);

        return FScaffold(
          header: FHeader(
            actions: [
              FTappable(
                autofocus: false,
                focusNode: FocusNode(),
                behavior: HitTestBehavior.translucent,
                builder: (context, state, child) => child!,
                onPress: () {
                 
                  app.getTravelHistory();
                  // print(app.travelHistory.length);
                },
                child: FIcon(FAssets.icons.folderSync),
              ),
            ],
            title: Text(
                    "Travel History",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

          content:
              app.travelHistory.isEmpty
                  ? const Center(child: Text('No travel history available'))
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar (existing code)...
                        const SizedBox(height: 20),

                        ...grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4,
                                ),
                                child: Text(
                                  entry.key,
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: entry.value.length,
                                itemBuilder: (context, index) {
                                  final history = entry.value[index];
                                  return HistoryCard(
                                    start: history.start,
                                    destination: history.destination,
                                    date: history.date,
                                    cost: history.cost,
                                    distance: history.distance,
                                    emissions: history.emissions,
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}

///Group Travel History by Date
Map<String, List<TravelHistory>> groupHistory(
  List<TravelHistory> travelhistory,
) {
  final Map<String, List<TravelHistory>> grouped = {};

  for (var item in travelhistory) {
    final String key = '${DateFormat('MMMM yyyy').format(item.date)}';
    grouped.putIfAbsent(key, () => []).add(item);
  }

  return grouped;
}

//Resuable layout for Travel History
class HistoryCard extends StatelessWidget {
  final String destination;
  final DateTime date;
  final double cost;
  final double distance;
  final double emissions;
  final String start;

  const HistoryCard({
    Key? key,
    required this.destination,
    required this.date,
    required this.cost,
    required this.distance,
    required this.start,
    required this.emissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side icon + vertical line
          Column(
            children: [
              Icon(
                Icons.radio_button_checked,
                color: Color.fromRGBO(34, 81, 221, 1),
                size: 20,
              ),
              Container(
                width: 0.5,
                height: 100,

                color: Color.fromRGBO(198, 198, 198, 1),
              ),
              Icon(
                Icons.radio_button_checked,

                color: Color.fromRGBO(1, 24, 95, 1),
                size: 20,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Right side text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    Text(
                  'From: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                      Expanded(
            child: Text(
              start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(DateFormat('MMM d').format(date)),
                Text('JMD \$${cost.toStringAsFixed(2)}'),
                Text('${distance.toStringAsFixed(2)} km'),
                Text('${(emissions / 1000).toStringAsFixed(2)} kg CO₂'),
                Row(
                  children: [
                     Text(
                  'To: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                    Text(
                      destination,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
