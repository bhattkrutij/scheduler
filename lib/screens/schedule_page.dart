import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/slot.dart';
import 'package:scheduler/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/prefs_utils.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> days = [
    StringUtils.SUN,
    StringUtils.MON,
    StringUtils.TUE,
    StringUtils.WED,
    StringUtils.THU,
    StringUtils.FRI,
    StringUtils.SAT
  ];
  List<String> daysFullName = [
    StringUtils.SUNDAY,
    StringUtils.MONDAY,
    StringUtils.TUESDAY,
    StringUtils.WEDNESDAY,
    StringUtils.THURSDAY,
    StringUtils.FRIDAY,
    StringUtils.SATURDAY
  ];
  Set<String> selectedDays = Set<String>();
  SharedPreferences? prefs;
  List<Map<String, List<dynamic>>> selectedSlots = [];
  List<List> slots = List.generate(7, (_) => List.generate(3, (_) => false));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intiSharedPref();
  }

  void intiSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    selectedDays = getSelectedDaysPref(prefs);
    slots = getPrefSlots(prefs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                StringUtils.SET_HRS,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    print("selected days in builder${selectedDays}");
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          color: Colors.white,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  print("selected days ${selectedDays}");
                                  setState(() {
                                    if (selectedDays.contains(days[index])) {
                                      selectedDays.remove(days[index]);
                                      slots[index][0] = false;
                                      slots[index][1] = false;
                                      slots[index][2] = false;
                                      setState(() {});
                                    } else {
                                      selectedDays.add(days[index]);
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      selectedDays.contains(days[index])
                                          ? Colors.green
                                          : Colors.grey,
                                  child: Container(
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(
                                        CupertinoIcons.check_mark,
                                        color: Colors.white,
                                        size: 20,
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                days[index],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              selectedDays.contains(days[index])
                                  ? Row(
                                      children: [
                                        _buildSlotbox(
                                            index, 0, StringUtils.MORNING),
                                        _buildSlotbox(
                                            index, 1, StringUtils.AFTERNOON),
                                        _buildSlotbox(
                                            index, 2, StringUtils.EVENING),
                                      ],
                                    )
                                  : const Text(
                                      StringUtils.UNAVAILABLE,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                    )
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        )
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    // side: BorderSide(color: Colors.yellow, width: 5),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.normal),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    shadowColor: Colors.lightBlue,
                  ),
                  onPressed: () {
                    String result = '';
                    setSelectedDaysPref(prefs, selectedDays);
                    selectedSlots.clear();
                    for (int i = 0; i < days.length; i++) {
                      Map<String, List<dynamic>> dayData = {
                        daysFullName[i]: slots[i]
                      };
                      selectedSlots.add(dayData);
                    }

                    print("slots before pref ::${selectedSlots}");
                    setPrefSlots(prefs, selectedSlots);
                    result = StringUtils.AVIALBLE_TEXT;
                    for (var dayMap in selectedSlots) {
                      print(dayMap);

                      dayMap.forEach((day, values) {
                        for (int i = 0; i < values.length; i++) {
                          bool isMorning = false;
                          bool isAfterNoon = false;
                          bool isEvening = false;
                          if (values[0] && values[1] && values[2]) {
                            result += day;
                            result += StringUtils.WHOLE_DAY;
                            break;
                          } else {
                            if (values[i]) {
                              result += day;
                              if (i == 0) {
                                result += StringUtils.MORNING;
                                isMorning = true;
                              } else if (i == 1) {
                                result +=
                                    StringUtils.AFTERNOON + StringUtils.COMMA;
                                isAfterNoon = true;
                              } else if (i == 2) {
                                result +=
                                    StringUtils.EVENING + StringUtils.COMMA;
                                isEvening = true;
                              }
                              (values[i] == values.length - 1)
                                  ? result += StringUtils.AND
                                  : ".";
                            }
                          }
                        }
                      });
                    }
                    print(result);
                    setPrefTitle(prefs, result);
                    Navigator.pop(context, getPrefTitle(prefs));
                  },
                  child: const Text(StringUtils.SAVE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlotbox(int dayIndex, int slotIndex, String slotName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              slots[dayIndex][slotIndex] = !slots[dayIndex][slotIndex];
              print(slots[dayIndex][slotIndex]);
              print("slots $slots");
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: slots[dayIndex][slotIndex]
                      ? Colors.blueAccent
                      : Colors.grey,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                  child: Text(
                slotName,
                style: TextStyle(
                    color: slots[dayIndex][slotIndex]
                        ? Colors.blueAccent
                        : Colors.grey),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
