import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateHome();
  }
}

class _StateHome extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder:
          (context, app, child) => FScaffold(
            header: FHeader(title: const Text("Home")),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FIcon(FAssets.icons.mapPin),
                        Text(
                          "Current User Location",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Where To:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    FButton(
                      onPress: () {
                        app.setIndex(2);
                      },
                      label: const Text(
                        "Plan Trips ?",
                        textAlign: TextAlign.left,
                      ),
                      suffix: FIcon(FAssets.icons.arrowRight),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Features",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    FTile(
                      prefixIcon: FIcon(FAssets.icons.globe),
                      title: const Text('Saved Places'),
                      // subtitle: const Text('subtitle'),
                      // details: const Text('View'),
                      suffixIcon: FIcon(FAssets.icons.chevronRight),
                      semanticLabel: 'Label',
                      enabled: true,
                      onPress: () {
                        app.setIndex(3);
                      },
                      onLongPress: () {},
                    ),
                    const SizedBox(height: 10),

                    FTile(
                      prefixIcon: FIcon(FAssets.icons.trendingUp),
                      title: const Text('Travel Trends'),
                      // subtitle: const Text('subtitle'),
                      // details: const Text('View'),
                      suffixIcon: FIcon(FAssets.icons.chevronRight),
                      semanticLabel: 'Label',
                      enabled: true,
                      onPress: () {},
                      onLongPress: () {},
                    ),
                    const SizedBox(height: 10),
                    FTile(
                      prefixIcon: FIcon(FAssets.icons.megaphone),
                      title: const Text('Commute Alerts'),
                      // subtitle: const Text('subtitle'),
                      // details: const Text('Set'),
                      suffixIcon: FIcon(FAssets.icons.chevronRight),
                      semanticLabel: 'Label',
                      enabled: true,
                      onPress: () {},
                      onLongPress: () {},
                    ),
                    const SizedBox(height: 10),
                    FTile(
                      prefixIcon: FIcon(FAssets.icons.circleDollarSign),
                      title: const Text('Estimated Trip Cost'),
                      // subtitle: const Text('subtitle'),
                      // details: const Text('Set'),
                      suffixIcon: FIcon(FAssets.icons.chevronRight),
                      semanticLabel: 'Label',
                      enabled: true,
                      onPress: () {},
                      onLongPress: () {},
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Recommendations",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
