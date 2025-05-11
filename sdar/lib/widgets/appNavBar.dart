import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/history.dart';
import 'package:sdar/home.dart';
import 'package:sdar/notification.dart';
import 'package:sdar/profile.dart';
import 'package:sdar/trips.dart';
import 'package:sdar/main.dart';

class AppNavbar extends StatelessWidget {
  final int index;

  const AppNavbar({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return FBottomNavigationBar(
      index: index,
      onChange: (newIndex) {
        app.index = newIndex;

        // Navigate accordingly
        Widget nextPage;
        switch (newIndex) {
          case 0:
            nextPage = const MyHomePage(title: 'SDAR');
            break;
          case 1:
            nextPage = const Messages();
            break;
          case 2:
            nextPage = const Trips();
            break;
          case 3:
            nextPage = const History();
            break;
          case 4:
            nextPage = const ProfilePage();
            break;
          default:
            nextPage = const MyHomePage(title: 'SDAR');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => nextPage),
        );
      },
      children: [
        FBottomNavigationBarItem(
          icon: FIcon(FAssets.icons.house),
          label: const Text('Home'),
        ),
        FBottomNavigationBarItem(
          icon: FIcon(FAssets.icons.mail),
          label: const Text('Notification'),
        ),
        FBottomNavigationBarItem(
          icon: FIcon(FAssets.icons.circlePlus),
          label: const Text('Trips'),
        ),
        FBottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/lets-icons--ticket-alt.svg', width: 24, height: 24),
          label: const Text('History'),
        ),
        FBottomNavigationBarItem(
          icon: FIcon(FAssets.icons.user),
          label: const Text('Profile'),
        ),
      ],
    );
  }
}
