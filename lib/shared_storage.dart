import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future saveStringData(key, value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future getData(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? 'no record';
}

Future removeData(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future saveObjectData(key, jsonString) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String user = jsonEncode(jsonString);
  pref.setString(key, user);
}

Future reSaveObjectData(key, jsonString) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String user = jsonEncode(jsonDecode(jsonString));
  pref.setString(key, user);
}

Future getObjectData(jsonString) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var userDa = pref.getString(jsonString);
  return jsonDecode(jsonEncode(userDa));
}
