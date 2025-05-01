import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:sdar/auth/login.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateProfilePage();
  }
}

class _StateProfilePage extends State<ProfilePage> {

    @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader(title: const Text("Profile")),
      content: Column(
        children: [
          Text('Hello World'),
          FButton(
  label: const Text('Logout'),
  onPress: () {
    Provider.of<AppProvider>(context,listen: false).clearAppData();
    Provider.of<AppProvider>(context,listen:false).logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  },
) ,
        ],
      )
    );
  }
}