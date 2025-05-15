import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:sdar/app_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Frompage extends StatefulWidget {
  const Frompage({super.key});

  @override
  State<Frompage> createState() => _FrompageState();
}

class _FrompageState extends State<Frompage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;


@override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

 


  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

     void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      // Only search if query has 3 or more characters
      if (query.length >= 3) {
       Provider.of<AppProvider>(context,listen: false).getSearchOptions(query);
        // Perform your search here
        // Example: await context.read<AppProvider>().searchPlaces(query);
      }
    });
  }

    return Consumer<AppProvider>(
      builder:
          (context, app, child) => FScaffold(
            header: FHeader(
              title: FTextField(
                prefixBuilder: (context, value, child) {
                  return FButton.icon(
                    onPress: () {
                      Navigator.pop(context);
                    },
                    child: FIcon(FAssets.icons.arrowLeft),
                  );
                },
                onChange: (value) async{
                  
                  _onSearchChanged(value);
                },
                controller: _controller, // TextEditingController
                clearable: (value) => value.text.isNotEmpty,
                enabled: true,
                hint: 'Search Here',
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                maxLines: 1,
              ),
            ),
            content: FTileGroup.builder(
              count: app.searchResults.length,
              scrollController: ScrollController(),
              tileBuilder:
                  (context, index) => FTile(
                    onPress: (){
                      //TOdo set the selected from location
                      app.setFromLocation(app.searchResults[index]);
                      Navigator.pop(context);
                    },
                    title: Text('${app.searchResults[index].name}')),
            ),
          ),
    );
  }
}
