
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constants.dart';

final GetIt getIt = GetIt.instance;

initLocatorService() {
  getIt.registerLazySingleton<SharedPreferenceHelper>(
          () => SharedPreferenceHelper());
}

class SharedPreferenceHelper {
  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
    loadDefault();
  }


  Object? readData({required StorageKey key}) {
    final result = _prefs.get(keyToStringConversion(key));
    return result;
  }

  bool? getBool(StorageKey  key) {
    final value = _prefs.get(keyToStringConversion(key));
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }


  Future<bool> storeStringData(
      {required StorageKey key,
        required String value,
        String? dummyKey}) async {
    return _prefs.setString(dummyKey ?? keyToStringConversion(key), value);
  }


  Future<bool> storeIntData(
      {required StorageKey key, required int value}) async {
    return _prefs.setInt(keyToStringConversion(key), value);
  }

  Future<bool> storeDoubleData(
      {required StorageKey key, required double value}) async {
    return _prefs.setDouble(keyToStringConversion(key), value);
  }

  Future<bool> storeBoolData(
      {required StorageKey key, required bool value}) async {
    return _prefs.setBool(keyToStringConversion(key), value);
  }

  Future<bool> removeData({required StorageKey key}) {
    return _prefs.remove(keyToStringConversion(key));
  }

  Future<Set<String>> getKeys() async {
    return _prefs.getKeys();
  }

  Future<bool> clearAll() {
    return _prefs.clear();
  }

  String keyToStringConversion(StorageKey key) {
    switch (key) {
      case StorageKey.loginToken:
        return "loginToken";
      case StorageKey.isIntroSeen:
        return 'isIntroSeen';
      case StorageKey.isLoggedIn:
        return 'isLoggedIn';
      case StorageKey.dineInOption:
        return 'dineInOption';
      case StorageKey.isTakeAway:
        return "isTakeAway";
    }
  }



  void loadDefault() {
    Constants.loginAccessToken = readData(key: StorageKey.loginToken) as String?;
  }
}

enum StorageKey {
  loginToken,
  isIntroSeen,
  isLoggedIn,
  dineInOption,
  isTakeAway,
}
