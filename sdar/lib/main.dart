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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
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
              (context, child) => FTheme(data: FThemeData(
                colorScheme: const FColorScheme(
                          primary: Color.fromRGBO(53, 124, 247, 1),
                          secondary: Color.fromRGBO(193, 240, 169, 1),
                          background: Colors.white,
                          foreground: Colors.black,
                          primaryForeground: Colors.white,
                          secondaryForeground: Colors.black,
                          brightness: Brightness.light,
                          barrier: Colors.black54,
                          muted: Color(0xFFE0E0E0),
                          mutedForeground: Color(0xFF616161),
                          destructive: Color(0xFFFF5A5F),
                          destructiveForeground: Colors.white,
                          error: Colors.red,
                          errorForeground: Colors.white,
                          border: Color(0xFFD1D5DB),
                        )
                      ), 
                      child: child!),
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
      //NAVIGATION BAR
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
              icon: SvgPicture.asset('assets/images/lets-icons--ticket-alt.svg',width: 24, height: 24,),
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
