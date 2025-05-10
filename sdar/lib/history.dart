import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sdar/widgets/appNavBar.dart';



class History extends StatefulWidget {
  const History({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateHistory();
  }
}

class _StateHistory extends State<History> {
  final List<HistoryCard> travelhistory =[ //MODIFY THIS TO COMMODATE MULTIPLE HISTORY
    HistoryCard(
      destination: 'Hope Gardens', 
      date: DateTime(2025, 5, 25), 
      cost:double.parse('3500.00'), 
      distance: double.parse('8'), 
      emissions: double.parse('8.79')),
    
    HistoryCard(
      destination: 'Sovereign North', 
      date: DateTime(2025, 2, 10), 
      cost:double.parse('1000.00'), 
      distance: double.parse('10'), 
      emissions: double.parse('5')),

    HistoryCard(
      destination: 'AC Hotel', 
      date: DateTime(2025, 5, 5), 
      cost:double.parse('1500.00'), 
      distance: double.parse('4'), 
      emissions: double.parse('2.67')),
    
    HistoryCard(
      destination: 'Destiny Rink', 
      date: DateTime(2025, 6, 28), 
      cost:double.parse('5500.00'), 
      distance: double.parse('220'), 
      emissions: double.parse('28.90')),
  ];

    @override
  Widget build(BuildContext context) {
    final grouped = groupHistory(travelhistory);
    return FScaffold(
      header: FHeader(title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  // Your onPressed logic here
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                "Travel History",
                textAlign: TextAlign.center,
                style:  GoogleFonts.inter(
                        textStyle: TextStyle(fontSize: 30, fontWeight:FontWeight.w700 , color: Colors.black)),
              ),
            ),
          ],
        )),
      
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      Row(
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 246, 243, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(fontSize: 15)),
                        decoration: const InputDecoration(
                          hintText: 'Search History...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FIcon(FAssets.icons.search,
                        color: const Color.fromRGBO(53, 124, 247, 1))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.sort)
        ],
      ),
      const SizedBox(height: 20),

      // Iterate over the grouped history
      ...grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(entry.key, // e.g., "March 2025"
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18))),
            ),
            ...entry.value, // list of HistoryCards
          ],
        );
      }).toList(),
    ],
          ),
        ),

    );

  
  }
}

//Resuable layout for Travel History
class HistoryCard extends StatelessWidget{
  final String destination;
  final DateTime date;
  final double cost;
  final double distance;
  final double emissions;

  const HistoryCard({
    Key? key,
    required this.destination,
    required this.date,
    required this.cost,
    required this.distance,
    required this.emissions
  }):super(key: key);

  @override
 Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side icon + vertical line
          Column(
            children: [
              Icon(Icons.radio_button_checked,
                  color: Color.fromRGBO(34, 81, 221, 1), size: 20),
              Container(
                width: 0.5,
                height: 100,
                
                color: Color.fromRGBO(198, 198, 198, 1),
              ),
              Icon(Icons.radio_button_checked,
              
                  color: Color.fromRGBO(1, 24, 95, 1), size: 20),
            ],
          ),
          const SizedBox(width: 12),
          // Right side text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(DateFormat('MMM d').format(date)),
                Text('JMD \$${cost}'),
                Text('${distance} km'),
                Text('${emissions} CO2'),
                 
              ],
            ),
          ),

          
        ],
      ),
    );
  }
}

//Group Travel History by Date
Map<String, List<HistoryCard>> groupHistory(List<HistoryCard> travelhistory) {
  final Map<String, List<HistoryCard>> grouped = {};

  for (var item in travelhistory) {
    final String key = '${DateFormat('MMMM yyyy').format(item.date)}';
    grouped.putIfAbsent(key, () => []).add(item);
  }

  return grouped;
}