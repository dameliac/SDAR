import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:sdar/auth/login.dart';
import 'package:sdar/commute.dart';
import 'package:sdar/main.dart';
import 'package:sdar/profile.dart';
import 'package:sdar/trips.dart';
import 'package:sdar/widgets/appNavBar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _StateEditProfilePage();
}

class _StateEditProfilePage extends State<EditProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _removePhoto() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final enabledBoxDecoration = BoxDecoration(
      color: const Color.fromRGBO(53, 124, 247, 1),
      borderRadius: BorderRadius.circular(5),
    );

    final enabledHoverBoxDecoration = BoxDecoration(
      color: const Color.fromRGBO(45, 110, 220, 1),
      borderRadius: BorderRadius.circular(5),
    );

    final disabledBoxDecoration = BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(5),
    );

    return FScaffold(
      header: FHeader(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            const Center(
              child: Text(
                "Edit Profile",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      content: Column(
        children: [
          // Cancel Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 140,
                height: 45,
                child: FButton(
                  onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  label: const Text('Cancel'),
                  style: FButtonStyle(
                    enabledBoxDecoration: enabledBoxDecoration,
                    enabledHoverBoxDecoration: enabledHoverBoxDecoration,
                    disabledBoxDecoration: disabledBoxDecoration,
                    focusedOutlineStyle: FFocusedOutlineStyle(
                      color: const Color.fromRGBO(53, 124, 247, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentStyle: FButtonContentStyle(
                      enabledTextStyle: const TextStyle(color: Colors.white),
                      disabledTextStyle: const TextStyle(
                        color: Color.fromARGB(255, 154, 154, 154),
                      ),
                      enabledIconColor: Colors.white,
                      disabledIconColor: const Color.fromARGB(255, 154, 154, 154),
                    ),
                    iconContentStyle: FButtonIconContentStyle(
                      enabledColor: Colors.white,
                      disabledColor: const Color.fromARGB(255, 154, 154, 154),
                    ),
                    spinnerStyle: FButtonSpinnerStyle(
                      enabledSpinnerColor: Colors.white,
                      disabledSpinnerColor: const Color.fromARGB(255, 154, 154, 154),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Profile Image & Email
          
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(193, 240, 169, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage("assets/images/b45fff6b8e9ca09258e544c7bd3e6cd00180d427.png") as ImageProvider,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Upload Photo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: _removePhoto,
                  child: const Text(
                    'Remove Photo',
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Starting Location Text Field
          Material(
            color: const Color.fromRGBO(243, 246, 243, 1),
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                onSubmitted: (value) {},
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Destination Text Field
          Material(
            color: const Color.fromRGBO(243, 246, 243, 1),
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: 'Enter your destination',
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                onSubmitted: (value) {},
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Destination Text Field
          Material(
            color: const Color.fromRGBO(243, 246, 243, 1),
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: 'Enter your home address',
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                onSubmitted: (value) {},
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Destination Text Field
          Material(
            color: const Color.fromRGBO(243, 246, 243, 1),
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: 'Enter your work address',
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                onSubmitted: (value) {},
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Save Button
          FButton(
            label: const Text('Save Changes'),
            onPress: () {
              Provider.of<AppProvider>(context, listen: false).clearAppData();
              Provider.of<AppProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            style: FButtonStyle(
              enabledBoxDecoration: enabledBoxDecoration,
              enabledHoverBoxDecoration: enabledHoverBoxDecoration,
              disabledBoxDecoration: disabledBoxDecoration,
              focusedOutlineStyle: FFocusedOutlineStyle(
                color: const Color.fromRGBO(53, 124, 247, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              contentStyle: FButtonContentStyle(
                enabledTextStyle: const TextStyle(color: Colors.white),
                disabledTextStyle: const TextStyle(
                  color: Color.fromARGB(255, 154, 154, 154),
                ),
                enabledIconColor: Colors.white,
                disabledIconColor: const Color.fromARGB(255, 154, 154, 154),
              ),
              iconContentStyle: FButtonIconContentStyle(
                enabledColor: Colors.white,
                disabledColor: const Color.fromARGB(255, 154, 154, 154),
              ),
              spinnerStyle: FButtonSpinnerStyle(
                enabledSpinnerColor: Colors.white,
                disabledSpinnerColor: const Color.fromARGB(255, 154, 154, 154),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
