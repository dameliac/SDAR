import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:sdar/auth/login.dart';
import 'package:sdar/auth/signup.dart';
import 'package:sdar/history.dart';
import 'package:sdar/home.dart';
import 'package:sdar/notification.dart';
import 'package:sdar/profile.dart';
import 'package:sdar/trips.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {

  final Future<bool>? _isloggedin = null;
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder:
              (context, child) => FTheme(data: FThemes.zinc.light, child: child!),
          home:  AuthWrapper(),
        ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        return FutureBuilder(
          // Initialize app and check auth state
          future: appProvider.ensureInitialized(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Error initializing app'),
                ),
              );
            }

            // Check if user is logged in
            if (appProvider.isLoggedIn) {
              return const MyHomePage(title: 'SDAR');
            }

            // Not logged in, show login page
            return const LoginPage();
          },
        );
      },
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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context,app,child)=>
      FScaffold(
        content: IndexedStack(
          index: app.index,
          children: [Home(), Messages(), Trips(), History(), ProfilePage()],
        ),
      
        footer: FBottomNavigationBar(
          index: app.index,
          onChange: (index) => setState(() => app.index = index),
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
      ),
    );
  }
}
