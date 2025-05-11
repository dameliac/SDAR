import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:sdar/estimated_trip.dart';
import 'package:sdar/main.dart';
import 'package:sdar/widgets/appNavBar.dart';

class EditEstimatedTripPage extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const EditEstimatedTripPage({super.key, required this.tripData});

  @override
  State<StatefulWidget> createState() => _StateEditEstimatedTripPage();
}

class _StateEditEstimatedTripPage extends State<EditEstimatedTripPage> {
  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController dateController;
  late TextEditingController makeController;
  late TextEditingController modelController;

  @override
  void initState() {
    super.initState();
    fromController = TextEditingController(text: widget.tripData['startLoc']);
    toController = TextEditingController(text: widget.tripData['destination']);
    dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.tripData['date']));
    makeController = TextEditingController(text: widget.tripData['Make']);
    modelController = TextEditingController(text: widget.tripData['Model']);
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    makeController.dispose();
    modelController.dispose();
    super.dispose();
  }

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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EstimatedTripPage()));
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            const Center(
              child: Text(
                "Edit Estimated Trip Cost",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      footer: AppNavbar(index: 0),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FButton(
                  onPress: (){ 
                    Navigator.pop(context);
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EstimatedTripPage()));
                    },
                  label: const Text('Cancel'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildTextField("From", fromController),
            _buildTextField("To", toController),
            _buildTextField("Date (YYYY-MM-DD)", dateController),
            _buildTextField("Make", makeController),
            _buildTextField("Model", modelController),

            const SizedBox(height: 24),
            FButton(
              onPress: () {
                // TODO: Save logic
                print("From: ${fromController.text}");
                print("Make: ${makeController.text}");
              },
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: const Color.fromRGBO(243, 246, 243, 1),
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
