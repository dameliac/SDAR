import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/profile.dart';
import 'package:sdar/widgets/appNavBar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _workAddressController = TextEditingController();

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

    return FScaffold(
      header: FHeader(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilePage())),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            const Text("Edit Profile", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      footer: AppNavbar(index: 4),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 140,
                height: 45,
                child: FButton(
                  onPress: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  ),
                  label: const Text('Cancel'),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                  const Text('Upload Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: _removePhoto,
                    child: const Text('Remove Photo', style: TextStyle(color: Colors.red, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'Enter your name'),
            const SizedBox(height: 10),
            _buildTextField(_priorityController, 'Optimization Priority'),
            const SizedBox(height: 10),
            _buildTextField(_homeAddressController, 'Enter your home address'),
            const SizedBox(height: 10),
            _buildTextField(_workAddressController, 'Enter your work address'),
            const SizedBox(height: 30),
            FButton(
              label: const Text('Save Changes'),
              onPress: () {
                // Handle save logic here (e.g., send data to backend)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Material(
      color: const Color.fromRGBO(243, 246, 243, 1),
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priorityController.dispose();
    _homeAddressController.dispose();
    _workAddressController.dispose();
    super.dispose();
  }
}
