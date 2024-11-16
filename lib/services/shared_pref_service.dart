import 'dart:convert';

import 'package:oil_solution/history/models/history_models.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<PrefUtils> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return this;
  }

  void clearPreferencesData() async {
    _sharedPreferences?.clear();
  }
  
  Future<void> i() async {
  final currentTime = DateTime.now().toIso8601String();
  await _sharedPreferences!.setString('lastSetTime', currentTime);
}

Future<void> addJsonToList(Map<String, dynamic> newJson, String key) async {
  if (_sharedPreferences == null) {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
  String? jsonString = _sharedPreferences!.getString(key);
  List<dynamic> currentList = jsonString != null ? jsonDecode(jsonString) : [];
  currentList.add(newJson);
  if (currentList.length > 10) {
    currentList.removeAt(0);
  }
  await _sharedPreferences!.setString(key, jsonEncode(currentList));
}


 Future<List<HistoryModels>> getListFromSharedPref(String key) async {
  if (_sharedPreferences == null) {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String? jsonString = _sharedPreferences!.getString(key);
  if (jsonString == null) return [];

  List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList
      .map((json) => HistoryModels.fromJson(json as Map<String, dynamic>))
      .toList();
}




}
