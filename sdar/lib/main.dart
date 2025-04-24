import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder:
          (context, child) => FTheme(data: FThemes.zinc.light, child: child!),
      home: MyHomePage(title: 'Hello'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FHeader(
          title: Text("SDAR"),
          actions: [
            // FTappable.animated(
            //   semanticLabel: 'Label',
            //   semanticSelected: false,
            //   excludeSemantics: false,
            //   focusNode: FocusNode(),
            //   onFocusChange: (focused) {},
            //   touchHoverEnterDuration: const Duration(milliseconds: 200),
            //   touchHoverExitDuration: Duration.zero,
            //   behavior: HitTestBehavior.translucent,
            //   onPress: () {},
            //   onLongPress: () {},
            //   builder: (context, state, child) => child!,
            //   child: const Text('Tappable'),
            // ),
          ],
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("I sold my porche"),
          FButton(onPress: (){}, label: const Text("Click Me"))
        ],
      ),
      footer: FBottomNavigationBar(
        index: 0,
        // onChange: (index) => setState(() => this.index = index),
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
            icon: FIcon(FAssets.icons.libraryBig),
            label: const Text('History'),
          ),
          FBottomNavigationBarItem(
            icon: FIcon(FAssets.icons.user),
            label: const Text('Profile'),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
