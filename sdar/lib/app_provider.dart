import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class SearchLocation {
  String name = "";
  List<dynamic> coord = [];
}

class Trip {
  String startName = "";
  String endName = "";
  double duration = 0.0;
  String routeID = "";
  List<double> startCoord = [];
  List<double> endCoord = [];
}

class TravelHistory {
  String destination;
  String start;
  DateTime date;
  double cost;
  double distance;
  double emissions;

  TravelHistory({
    required this.start,
    required this.destination,
    required this.date,
    required this.cost,
    required this.distance,
    required this.emissions,
  });
}

class Directions {
  String instruction = "";
  double distance = 0.0;
}


class AppProvider extends ChangeNotifier {
  int index = 0;
  final dio = Dio();
  late PocketBase pb;
  late RecordAuth? userdata;
  late AuthStore store;
  bool isLoggedIn = false;
  bool isInitialized = false;
  String? driverName;
  String userID = "";
  double distance = 0.0;
  double duration = 0.0;
  String driverID = '';
  var searchResults = [];

  List<Trip> trips = [];
  List<Directions> tmp = [];
  List<TravelHistory> travelHistory = [];
  SearchLocation? selectedFromLocation;
  SearchLocation? selectedToLocation;

  void setIndex(int i) {
    index = i;
    notifyListeners();
  }

  void test() {
    print("Hello ");
  }

   Future<void> getTravelHistory() async {

    travelHistory.clear();


    try {
      final records = await pb.collection('Travel_History').getFullList(
        expand: 'routeID'
      );

      travelHistory.clear();
      
      for (var record in records) {
        // final data


        final emm = record.getStringValue('co2_emissions');
        final distance = record.get<double>('expand.routeID.Distance');
        final fuel = record.get<double>('expand.routeID.fuelConsump');
        final destination = record.get<String>('expand.routeID.End_Location');
        final start = record.get<String>('expand.routeID.Start_Location');

        final driver = await getDriverID();
        // print(driver);

        final vehicle = await pb.collection('Vehicle').getFirstListItem(
  'driverID="$driver"',
);

// print(vehicle);

final co2 = vehicle.getDoubleValue('co2');

        // print(ex);
        // print(route);
        

         travelHistory.add(
            TravelHistory(
              start: start,
              destination: destination,
              date: DateTime.now(),
              cost: fuel * 187.26, // Assuming fuel cost
              distance: distance / 1000,
              emissions: (distance * 0.0006213712) * co2,
            ),
          );
        // final route = record.expand['routeID']?[0];
        // if (route != null) {
         
        // }
        // print(travelHistory.length);
      }
     notifyListeners();
    } catch (e) {
      print('Error fetching travel history: $e');
      travelHistory.clear();
    }
  }

  Future<void> getTrips() async {
    trips.clear();
    try {
      final records = await pb.collection('Route').getFullList(
        // filter: 'completed = "${true}"',
      );

      for (var record in records) {

        // print(record.getDoubleValue('duration'));
        final start = record.getStringValue('Start_Location');
        final end = record.getStringValue('End_Location');
        final st_lat  = record.getDoubleValue('start_lat');
        final st_lng  = record.getDoubleValue('start_long');

        final stop_lng  = record.getDoubleValue('stop_long');
        final stop_lat  = record.getDoubleValue('stop_lat');
        final id = record.id;

        Trip trip = Trip()
        ..startName = start
        ..endName = end
        ..startCoord = [st_lat,st_lng]
        ..endCoord = [stop_lat,stop_lng]
        ..routeID = id
        ..duration = record.getDoubleValue('Duration');

        print(trip.startCoord);

        trips.add(trip);
      }

      notifyListeners();
    } catch (e) {
      trips.clear();
      print(e);
    }
  }

  Future<bool> markRouteComplete(route) async {
    final body = <String, dynamic>{
  "completed": true
};

try {
final record = await pb.collection('Route').update(route, body: body);
return true;
} catch(e){
  print(e);
  return false;
}

  }

  Future<bool> markTripComplete(route,co2) async {
    print(route);
    final id = await getDriverID();
//       final driver = await getDriverID();
//       final body = <String, dynamic>{
//     "driverID": driver,
//     "vehicle_VIN": "test",
//     "routeID": route,
//     "co2_emissions": 123
// };
final body = <String, dynamic>{
  "driverID": id,
  "vehicle_VIN": "test",
  "co2_emissions": 123,
  "routeID": route
};

try {
final record = await pb.collection('Travel_History').create(body: body);
final success = await markRouteComplete(route);
return success;
} catch (e){
  print(e);
  return false;
}

  }

  Future<void> getSearchOptions(String value) async {
    searchResults.clear();
    final response = await dio.get('http://localhost:9002/autocomplete/$value');
    // print(response.data["data"]);
    for (var data in response.data["data"]) {
      SearchLocation l = SearchLocation();
      l.name = data["name"];

      l.coord = data["coords"];

      searchResults.add(l);
    }
    notifyListeners();
  }

  Future<void> getDistanceTime() async {
    // final response = await dio.get('http://localhost:9002/distance');
    final response = await dio.post(
      'http://localhost:9002/distance',
      data: {
        'start': selectedFromLocation!.coord,
        'end': selectedToLocation!.coord,
      },
    );
    // print(response.data['data']['distance']);
    print(response.data['data']['geometry']['coordinates']);

    distance = response.data['data']['distance'];
    duration = response.data['data']['duration'];

    notifyListeners();
  }

   Future <List<LatLng>> getPolyline(start, end) async {
    print("$start , $end");
    try {
      final response = await dio.post(
        'http://localhost:9002/distance',
        data: {
          'start': start,
          'end': end,
        },
      );

      List<Directions> steps = [];
      List<LatLng> points = [];
      List<dynamic> coordinates = response.data['data']['geometry']['coordinates'];
      final lsteps = response.data['data']['steps'];
      
      for (var coord in coordinates) {
       
        points.add(LatLng(coord[1], coord[0]));
        // print(points);
      }

      for(var step in lsteps){
        steps.add(
          Directions()
          ..distance = step['distance']
          ..instruction = step['instruction']
        );
      }

      // print(steps.length);
      tmp = steps;
      
      return points;
    } catch (e) {
      print('Error getting polyline: $e');
      return [];
    }
  }

  Future<void> createTrip() async {
    final body = <String, dynamic>{
      "Duration": duration,
      "ETA": "2022-01-01 10:00:00.123Z",
      "Start_Location":
          selectedFromLocation == null ? "" : selectedFromLocation!.name,
      "End_Location":
          selectedToLocation == null ? "" : selectedToLocation!.name,
      "Execution_Date": "2022-01-01 10:00:00.123Z",
      "Distance": distance,
      "fuelConsump": 123,
    };

    final record = await pb.collection('Route').create(body: body);

    print(record);
  }

  void setFromLocation(SearchLocation location) {
    selectedFromLocation = location;
    notifyListeners();
  }

  void setToLocation(SearchLocation location) async {
    selectedToLocation = location;
    if (selectedFromLocation != null && selectedToLocation != null) {
      //TODO
      print('${selectedFromLocation!.coord},${selectedToLocation!.coord}');
      getDistanceTime();
    }
    notifyListeners();
  }

  void logout() {
    pb.authStore.clear();
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> loadDriverName() async {
    driverName = await fetchUserName();
    notifyListeners();
  }

  //TO DISPLAY USER NAME
  Future<String?> fetchUserName() async {
    try {
      final userID = userdata?.record.id;
      if (userID == null) return null;

      final driver = await pb
          .collection('Driver')
          .getFirstListItem('userID="$userID"');

      print(driver);

      driverID = driver.id;

      final firstName = driver.getStringValue('FirstName');
      final lastName = driver.getStringValue('LastName');

      return '$firstName $lastName';
    } catch (e) {
      print("Error fetching driver's name: $e");
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      userdata = await pb
          .collection('users')
          .authWithPassword(username, password);
      // Logger().e(userdata);

      if (store.isValid) {
        isLoggedIn = true;
        // Logger().e(userdata);
        final record = await pb
            .collection('Driver')
            .getFirstListItem('userID="${store.record!.id}"');

        // print(record);
        await loadDriverName();
        return true;
      }
    } catch (e) {
      // Logger().e(e);
      return false;
    }

    return false;
  }

  // Add this method to your AppProvider class
  void clearAppData() {
    // Reset index
    index = 0;

    // Clear authentication state
    if (isInitialized) {
      pb.authStore.clear();
    }

    // Reset auth-related variables
    isLoggedIn = false;
    isInitialized = false;

    // Clear user data
    userdata = null;

    // Notify listeners of the changes
    notifyListeners();

    print("App data cleared successfully");
  }

  Future<bool> ensureInitialized() async {
    if (isInitialized) return true;

    try {
      final prefs = await SharedPreferences.getInstance();

      store = AsyncAuthStore(
        save: (String data) async => prefs.setString('pb_auth', data),
        initial: prefs.getString('pb_auth'),
      );

      pb = PocketBase('http://localhost:8090', authStore: store);
      isLoggedIn = store.isValid;
      isInitialized = true;
      notifyListeners();
      return true;
    } catch (e) {
      print("Initialization error: $e");
      return false;
    }
  }

  Future<bool> createDriver(
    String firstname,
    String lastname,
    String opp,
    String record,
  ) async {
    final body = <String, dynamic>{
      "userID": record,
      "FirstName": firstname,
      "LastName": lastname,
      "OptimisationPriority": opp,
    };

    try {
      final record = await pb.collection('Driver').create(body: body);
      print(record);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createVehicle(make, model, year) async {
    final response = await dio.get(
      'http://localhost:9002/getvehicle/$make/$model/$year',
    );
    // print(response.data);
    // print(store.record!.id);
    final body = <String, dynamic>{
      "VIN": "Test",
      "VehicleRegis": "Test",
      "VehicleType": "test",
      "MPG": response.data['data']['cityMPG'],
      "EVConsump": 123,
      "GasConsump": 123,
      "driverID": driverID,
      "VehicleMake": make,
      "VehicleModel": model,
      "VehicleYear": int.parse(year),
      "co2": response.data['data']['co2']
    };

    try {
      final record = await pb.collection('Vehicle').create(body: body);
      print(record);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createUser(
    password,
    passwordConfirm,
    email,
    firstname,
    lastname,
    opp,
    // name,
    // vehicle_type,
    // optimization,
  ) async {
    final body = <String, dynamic>{
      "password": password,
      "passwordConfirm": passwordConfirm,
      "email": email,
      "emailVisibility": true,
      // "verified": true,
      // "name": name,
      // "vehicle_type": vehicle_type,
      // "optimization": optimization,
    };

    RecordModel? record;
    try {
      final record = await pb.collection('users').create(body: body);
      print(record);
      userID = record.id;

      //TODO , create a drvier
      final success = await createDriver(firstname, lastname, opp, record.id);

      final loggedin = await login(email, password);

      if (loggedin == true) {
        return success;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> getDriverID () async {
    try {
       final record = await pb.collection('Driver').getFirstListItem(
  'userID="${store.record!.id}"'
  // expand: 'relField1,relField2.subRelField',
  
);
    return record.id;

    } catch(e){
      print(e);
    }


return "";
  }
  Future<int> getMPG() async {
    final id = await getDriverID();
    try {
      final record = await pb
          .collection('Vehicle')
          .getFirstListItem('driverID="$id"');
      return record.getIntValue('MPG');
    } catch (e) {
      print("Error mpg $e");
      return 0;
    }
  }

  Future<bool> saveTrip() async {

    final mpg = await getMPG();
    print(mpg);

    final meters = mpg * 1.60934;
    final fuelConsomption = (3.78541 / meters) * (distance/1000);

    final body = <String, dynamic>{
      "Duration": duration,
      "ETA": "2022-22-22",
      "Start_Location": selectedFromLocation!.name,
      "End_Location": selectedToLocation!.name,
      "Execution_Date": "2022-01-01 10:00:00.123Z",
      "Distance": distance,
      "start_coords": selectedFromLocation!.coord.toString(),
      "start_lat": selectedFromLocation!.coord[0],
      "start_long" :selectedFromLocation!.coord[1],
      "stop_lat": selectedToLocation!.coord[0],
      "stop_long": selectedToLocation!.coord[1],
      "end_coords": selectedToLocation!.coord.toString(),
      "fuelConsump": fuelConsomption,
    };

    // print(body);
    try {
      final record = await pb.collection('Route').create(body: body);
      return true;
    } catch (e) {
      print(e);
      print("ERRRRRRRRRRRRRRRR");
      return false;
    }
  }
}
