import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  int index = 0;
  late PocketBase pb;
  late RecordAuth? userdata;
  late AuthStore store;
  bool isLoggedIn = false;
  bool isInitialized = false;

  void setIndex(int i) {
    index = i;
    notifyListeners();
  }

  void test() {
    print("Hello ");
  }

  void logout() {
    pb.authStore.clear();
    isLoggedIn = false;
    notifyListeners();
  }

   Future<bool> login(String username , String password) async {
    try {
      userdata = await pb
          .collection('users')
          .authWithPassword(username, password);
      // Logger().e(userdata);

      if (store.isValid) {
        isLoggedIn = true;
        // Logger().e(userdata);
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

  Future<bool> createUser(
    password,
    passwordConfirm,
    email,
    name,
    vehicle_type,
    optimization,
  ) async {
    final body = <String, dynamic>{
      "password": password,
      "passwordConfirm": passwordConfirm,
      "email": email,
      "emailVisibility": true,
      // "verified": true,
      "name": name,
      "vehicle_type": vehicle_type,
      "optimization": optimization,
    };

    RecordModel? record;
    try {
      final record = await pb.collection('users').create(body: body);
      print(record);
      final success = await login(email, password);

      return success;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
