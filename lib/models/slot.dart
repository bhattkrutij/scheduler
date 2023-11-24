import 'dart:convert';

class Slot {
  List<bool>? title;

  Slot({this.title});
  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(title: json["title"]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    return data;
  }
}

List<Slot> slotFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Slot>.from(data.map((item) => Slot.fromJson(item)));
}

String slotToJson(Slot data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
