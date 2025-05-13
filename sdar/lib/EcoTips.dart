import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateTips();
  }
}

class _StateTips extends State<Tips> {
  final List<String> ecoTips = const [
    "Plan trips to avoid heavy traffic.",
    "Carpool when possible.",
    "Avoid rapid acceleration and hard braking.",
    "Keep your tires properly inflated.",
    "Turn off your engine when parked.",
    "Use cruise control on the highway.",
    "Remove unnecessary weight from your vehicle.",
    "Use navigation apps to find efficient routes.",
    "Maintain your vehicle regularly.",
    "Drive at steady, moderate speeds."
  ];

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(
        title: Stack(
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
                "Eco-friendly Travel Tips",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      footer: AppNavbar(index: 0),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ecoTips.map((tip) {
            return EcoTipCard(tip: tip);
          }).toList(),
        ),
      ),
    );
  }
}

class EcoTipCard extends StatelessWidget {
  final String tip;

  const EcoTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50], // Light green background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green[700], // Green icon background
            ),
            child: const Icon(
              Icons.eco,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Text content
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
