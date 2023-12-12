import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final String _userKey = 'currentUser';
  late SharedPreferences prefs;

  SharedPrefs._privateConstructor();

  static final SharedPrefs _instance = SharedPrefs._privateConstructor();

  factory SharedPrefs() {
    return _instance;
  }

  initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? getCurrentUser() {
    return prefs.getString(_userKey);
  }


  Future<void> setCurrentUser(String value) async {
    await prefs.setString(_userKey, value);
  }

  Future<void> removeCurrentUser() async {
    await prefs.remove(_userKey);
  }
}
