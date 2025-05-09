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
            header: FHeader(title: Row(children: [Image.asset('assets/images/logo.png', height: 50,)],)),
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
                      "Where to?",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      //elevation: 2,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 236, 236),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Plan Trips...',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // Perform search logic
                                },
                              ),
                            ),
                          const SizedBox(width: 10),
                          FIcon(FAssets.icons.search, color: const Color.fromRGBO(53, 124, 247, 1))
                          ],
                        ),
                      ),
                    )

                    ,
                    const SizedBox(height: 10),
                    const Text(
                      "Features",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    //USE INKWELL FOR FUNCTIONALITY
                    const SizedBox(height: 20),
                    GridView.count(crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.0,
                    children: [
                      //FIRST TILE
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(123, 189, 255, 1),//first tile colour
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Planned Trips'),
                            const SizedBox(height: 5,),
                            Flexible(child: Image.asset("assets/images/vecteezy_elegant-rustic-map-with-marked-route-folded-transparent_57155239.png", 
                            width: 60, height: 60, fit: BoxFit.contain,),
                            )
                          ],
                        ),
                      ),
                      //SECOND TILE
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 107, 107, 1),//second tile colour
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Commute Alerts'),
                            const SizedBox(height: 5,),
                            Flexible(child:Image.asset("assets/images/vecteezy_3d-icon-notification-bell-a-ringing-bell-indicating-alerts_60511166.png",
                            width: 60, height: 60, fit: BoxFit.contain,),
                            )

                          ],
                        ),
                      ),
                      //THIRD TILE
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(249, 234, 104, 1),//third tile colour
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Travel Trends'),
                            const SizedBox(height: 5,),
                            Flexible(child:Image.asset("assets/images/vecteezy_vibrant-modern-financial-graph-chart-upward-trend-isolated_57435486.png", 
                            width: 60, height: 60,fit: BoxFit.contain,),
                            )
                          ],
                        ),
                      ),
                      //FOURTH TILE
                      Container(
                        decoration: BoxDecoration(
                      
                          color: Color.fromRGBO(109, 217, 120, 1),//forth tile colour
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Estimated Trip Cost'),
                            const SizedBox(height: 5,),
                            Flexible(child:Image.asset("assets/images/vecteezy_extraordinary-abstract-d-stack-of-coins-with-financial_57411371.png", 
                            width: 60, height: 60, fit: BoxFit.contain,),
                            )

                          ],
                        ),
                      ),
                      // FTile(
                      //   title: const Text('Planned Trips'),
                      //   suffixIcon: Image.asset("assets/images/vecteezy_elegant-rustic-map-with-marked-route-folded-transparent_57155239.png", width: 60, height: 60,),
                      //   // subtitle: const Text('subtitle'),
                      //   // details: const Text('View'),
                      //   //suffixIcon: FIcon(FAssets.icons.chevronRight),
                      //   semanticLabel: 'Label',
                      //   enabled: true,
                      //   onPress: () {
                      //     app.setIndex(3);
                      //   },
                      //   onLongPress: () {},
                      // ),
                      // //const SizedBox(height: 10),
                      // FTile(
                      //   //prefixIcon: FIcon(FAssets.icons.megaphone),
                      //   title: const Text('Commute Alerts'),
                      //   // subtitle: const Text('subtitle'),
                      //   // details: const Text('Set'),
                      //   suffixIcon: Image.asset("assets/images/vecteezy_3d-icon-notification-bell-a-ringing-bell-indicating-alerts_60511166.png",width: 60, height: 60),
                      //   semanticLabel: 'Label',
                      //   enabled: true,
                      //   onPress: () {},
                      //   onLongPress: () {},
                      // ),
                      // FTile(
                      //   title: const Text('Travel Trends'),
                      //   suffixIcon: Image.asset("assets/images/vecteezy_vibrant-modern-financial-graph-chart-upward-trend-isolated_57435486.png",width: 60, height: 60),
                      //   // subtitle: const Text('subtitle'),
                      //   // details: const Text('View'),
                      //   //suffixIcon: FIcon(FAssets.icons.chevronRight),
                      //   semanticLabel: 'Label',
                      //   enabled: true,
                      //   onPress: () {},
                      //   onLongPress: () {},
                      // ),
                      // //const SizedBox(height: 10),
                      
                      // //const SizedBox(height: 10),
                      // FTile(
                      //   prefixIcon: FIcon(FAssets.icons.circleDollarSign),
                      //   title: const Text('Estimated Trip Cost'),
                      //   // subtitle: const Text('subtitle'),
                      //   // details: const Text('Set'),
                      //   suffixIcon: FIcon(FAssets.icons.chevronRight),
                      //   semanticLabel: 'Label',
                      //   enabled: true,
                      //   onPress: () {},
                      //   onLongPress: () {},
                      // ),
                      // //const SizedBox(height: 20),
                    ],),
                    const SizedBox(height: 10),
                    const Text(
                      "Recommendations",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    FTile(
                      prefixIcon: FIcon(FAssets.icons.star, color: const Color.fromARGB(255, 217, 217, 217)),
                      title: const Text('Nearby Travel Services'),
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
                      prefixIcon: FIcon(FAssets.icons.star, color: const Color.fromARGB(255, 217, 217, 217)),
                      title: const Text('Eco-friendly Travel Tips'),
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
                      prefixIcon: FIcon(FAssets.icons.star, color: const Color.fromARGB(255, 217, 217, 217)),
                      title: const Text('Report Hazards'),
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
                      prefixIcon: FIcon(FAssets.icons.star, color: const Color.fromARGB(255, 217, 217, 217)),
                      title: const Text('Alternative Route'),
                      // subtitle: const Text('subtitle'),
                      // details: const Text('Set'),
                      suffixIcon: FIcon(FAssets.icons.chevronRight),
                      semanticLabel: 'Label',
                      enabled: true,
                      onPress: () {},
                      onLongPress: () {},
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              
            ),
          ),
    );
  }
}

