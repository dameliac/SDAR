import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

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

class Commute {
  String startLoc = "";
        String destination = ""; 
    String date = "";
    List<dynamic> days = [];
    String time = "";
    bool notification = true;
}


class AppProvider extends ChangeNotifier {
  int index = 0;
  final dio = Dio();
  late PocketBase pb;
  RecordAuth? userdata;
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
  List<Commute> commutes = [];
  
  SearchLocation? selectedFromLocation;
  SearchLocation? selectedToLocation;
  SearchLocation? selectedToC;
  SearchLocation? selectedFromC;

  List<Map<String, dynamic>> estimate = [];
Timer? _commuteCheckTimer;

void stopCommuteChecks() {
    if (_commuteCheckTimer != null && _commuteCheckTimer!.isActive) {
      _commuteCheckTimer!.cancel();
      print("Commute checks stopped.");
    }
    _commuteCheckTimer = null;
  }

  Future<void> getCommutes() async {
    commutes.clear();
      try {
          final records = await pb.collection('Commute').getFullList(
              filter: 'userID="${store.record!.id}"',
            );

          for(var record in records){
            final start = record.getStringValue('start_location');
            final end = record.getStringValue('end_location');
            final arrival = record.getStringValue('arrival_time');
            final days = record.getListValue('days');

            commutes.add(Commute()..startLoc = start
            ..destination = end
            ..time = arrival
            ..days = days
            );

          }

          notifyListeners();
      } catch(e){
        print(e);
      }
  }

  void startCommuteChecks() {
    print("Started");
    if (!isInitialized || !isLoggedIn || store.record == null) {
      print("Commute checks cannot start: App not initialized, user not logged in, or user record is null.");
      return;
    }

    final String currentUserID = store.record!.id;

    if (_commuteCheckTimer != null && _commuteCheckTimer!.isActive) {
      print("Commute checks already running for user $currentUserID.");
      return; // Already running
    }
    
    print("Starting commute checks for user $currentUserID...");
    _commuteCheckTimer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      print("Going again");
      if (!isLoggedIn || store.record == null) { // Re-check login status
        print("User logged out or session expired. Stopping commute checks.");
        stopCommuteChecks();
        return;
      }
      try {
        final records = await pb.collection('Commute').getFullList(
              filter: 'userID="$currentUserID"',
            );
        // print(records);

        DateTime now = DateTime.now();
        String todayDayName = DateFormat('EEEE').format(now); // e.g., "Monday", "Tuesday"

        for (var record in records) {
          try {
            List<String> commuteDays = [];
            final dynamic daysValue = record.data['days']; // Access raw data
            if (daysValue is List) {
                commuteDays = List<String>.from(daysValue.map((item) => item.toString()));
            }


            // Check if the commute is scheduled for today
            if (!commuteDays.contains(todayDayName)) {
              // print('Commute ID ${record.id}: Not for today (${todayDayName}). Skipping.');
              continue;
            }

            String arrivalTimeString = record.getStringValue('arrival_time'); // Expects "HH:mm"
            double durationInSeconds = record.getDoubleValue('duration');


            List<String> timeParts = arrivalTimeString.split(':');
            if (timeParts.length != 2) {
              print('Commute ID ${record.id}: Invalid arrival_time format: $arrivalTimeString. Skipping.');
              continue;
            }

            int hour = int.parse(timeParts[0]);
            int minute = int.parse(timeParts[1]);

            DateTime scheduledArrivalTimeToday = DateTime(now.year, now.month, now.day, hour, minute);

            // Time if user starts now and travels for 'durationInSeconds'
            DateTime estimatedArrivalIfStartingNow = now.add(Duration(seconds: durationInSeconds.toInt()));

            // print("$estimatedArrivalIfStartingNow , $scheduledArrivalTimeToday");
            // Condition: scheduled_arrival_time >= (current_time + duration_from_record)
            if (estimatedArrivalIfStartingNow.isAfter(scheduledArrivalTimeToday)) {
              toastification.show(
                title: Text('Leave Now To Make Trip'),
                description: Text('To: ${record.getStringValue('end_location')}'),
                autoCloseDuration: Duration(seconds: 2)
              );
              print('Commute ID ${record.id} (Scheduled: $arrivalTimeString, Duration: ${durationInSeconds}s, Day: $todayDayName): true');
            } else {
              // Optional: print false if needed for debugging
              // print('Commute ID ${record.id} (Scheduled: $arrivalTimeString, Duration: ${durationInSeconds}s, Day: $todayDayName): false');
            }
          } catch (e) {
            print('Error processing commute record ${record.id}: $e. Record data: ${record.data}');
          }
        }
      } catch (e) {
        print('Error fetching commutes: $e');
        if (e is ClientException && (e.statusCode == 401 || e.statusCode == 403)) {
            print("Authentication error during commute check. Stopping timer.");
            stopCommuteChecks();
        }
      }
    });
  }

  Future<void> getEstimates () async{

    estimate.clear();

    final records = await pb.collection('Route').getFullList(
  // sort: '-someField',
);

  // 'startLoc':'Home',
  //   'destination': 'Alligator Pond, St Elizabeth',
  //   'distance': 30.5,
  //   'date': DateTime(2025,6,23),
  //   'timelength': 1.5,
  //   'Make': 'Toyota',
  //   'Model': 'CR-V',
  //   'Price': 143.4,
  //   'Usage': '75 litres/100 km',
  //   'cost':3217.50

   String startLoc = '';
    String destination = '';
    final double avgGasPrice = 127.0512;
    final DateTime date = DateTime.now();
    double  duration = 0.0;
     String make = '';
     String model = '';
     double usage = 0.0; //fuel or ev usage
    double cost = 0.0;
     double EVchargePrice = 90;



  for(var record in records){
    startLoc = record.getStringValue('Start_Location');
    destination = record.getStringValue('End_Location');
    duration = record.getDoubleValue('Duration');
    final fuelComsump = record.getDoubleValue('fuelConsump');
    cost = fuelComsump * avgGasPrice;

    final driver = await getDriverID();
    final vehicle = await pb.collection('Vehicle').getFirstListItem(
  'driverID="$driver"',

);

make = vehicle.getStringValue('VehicleMake');
model = vehicle.getStringValue('VehicleModel');

  estimate.add(
    {
      'startLoc':startLoc,
    'destination': destination,
    'distance': duration,
    'date': DateTime(2025,6,23),
    'timelength': duration,
    'Make': make,
    'Model': model,
    'Price': avgGasPrice,
    'Usage': '75 litres/100 km',
    'cost': cost
    }
  );
  }

  notifyListeners();
  }
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

  Future<bool> addCommute(time , day) async {

    await getDistanceTime();

      final body = <String, dynamic>{
  "userID": store.record!.id,
  "start_location":  selectedFromLocation!.name,
  "end_location": selectedToLocation!.name,
  "days": day,
  "arrival_time": time,
  "remind_me": true,
  "duration" : duration
};

  try {
final record = await pb.collection('Commute').create(body: body);
return true;
  } catch(e){
  return false;

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
            stopCommuteChecks();

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
    print("Called on a reload");
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

  void clearAppData() {
    stopCommuteChecks();

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
    driverName = null;
    driverID = '';
    userID = '';

    // Clear search-related data
    distance = 0.0;
    duration = 0.0;
    searchResults.clear();
    selectedFromLocation = null;
    selectedToLocation = null;
    selectedToC = null;
    selectedFromC = null;

    // Clear lists
    trips.clear();
    tmp.clear();
    travelHistory.clear();
    commutes.clear();
    estimate.clear();

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
    startCommuteChecks();

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
