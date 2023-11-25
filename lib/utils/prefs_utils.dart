import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void setPrefTitle(SharedPreferences? prefs, String title) {
  prefs?.setString('title', title);
}

String getPrefTitle(SharedPreferences? prefs) {
  return prefs?.getString("title") ?? "";
}

void setPrefSlots(
    SharedPreferences? prefs, List<Map<String, List<dynamic>>> data) {
  String jsonData = jsonEncode(data);
  print(jsonData);
  prefs?.setString('data', jsonData);
}

List<List> getPrefSlots(SharedPreferences? prefs) {
  List<List<dynamic>> slots = [];
  String savedJsonString = prefs?.getString('data') ?? "";
  List<dynamic> data = jsonDecode(savedJsonString);
  List<List> temp = [];
  for (var dayMap in data) {
    print(dayMap);

    dayMap.forEach((day, values) {
      List<bool> b = [];
      for (int i = 0; i < values.length; i++) {
        b.add(values[i]);
      }
      temp.add(b);
    });
  }
  print("sllll${temp}");
  slots = temp;
  // setState(() {});
  return slots;
}

void setSelectedDaysPref(SharedPreferences? prefs, Set<String> data) {
  List<String> dataList = data.toList();
  String jsonData = jsonEncode(dataList);
  prefs?.setString('selectedDays', jsonData);
}

Set<String> getSelectedDaysPref(SharedPreferences? prefs) {
  String savedJsonString = prefs?.getString('selectedDays') ?? "";
  if (savedJsonString.isNotEmpty) {
    List<dynamic> dataList = jsonDecode(savedJsonString);
    Set<String> data = Set.from(dataList);
    print("get selected days in days method ${data}");
    return data;
  } else {
    return Set<String>();
  }
}
