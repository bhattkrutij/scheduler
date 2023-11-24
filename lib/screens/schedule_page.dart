import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  List<String> daysFullName = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thusday',
    'Friday',
    'Saturday'
  ];
  Set<String> selectedDays = Set<String>();
  List<Map<String, List<bool>>> selectedSlots = [];
  List<List<bool>> slots =
      List.generate(7, (_) => List.generate(3, (_) => false));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Set your Weekly hours",
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
                                  setState(() {
                                    if (selectedDays.contains(days[index])) {
                                      selectedDays.remove(days[index]);
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
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        CupertinoIcons.check_mark,
                                        color: Colors.white,
                                        size: 20,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                days[index],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              selectedDays.contains(days[index])
                                  ? Row(
                                      children: [
                                        _buildSlotCheckbox(index, 0, 'Morning'),
                                        _buildSlotCheckbox(
                                            index, 1, 'Afternoon'),
                                        _buildSlotCheckbox(index, 2, 'Evening'),
                                      ],
                                    )
                                  : Text(
                                      "Unavailable",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                    )
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  child: Text('Save'),
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
                    print(selectedDays);

                    for (int i = 0; i < days.length; i++) {
                      Map<String, List<bool>> dayData = {
                        daysFullName[i]: slots[i]
                      };
                      selectedSlots.add(dayData);
                    }
                    print(selectedSlots);
                    result = "Hi you are available in ";
                    for (var dayMap in selectedSlots) {
                      print(dayMap);

                      dayMap.forEach((day, values) {
                        for (int i = 0; i < values.length; i++) {
                          bool isMorning = false;
                          bool isAfterNoon = false;
                          bool isEvening = false;
                          if (values[0] && values[1] && values[2]) {
                            result += day;
                            result += " whole day and";
                            break;
                          } else {
                            if (values[i]) {
                              result += day;
                              if (i == 0) {
                                result += " Morning, ";
                                isMorning = true;
                              } else if (i == 1) {
                                result += " Afternoon, ";
                                isAfterNoon = true;
                              } else if (i == 2) {
                                result += " Evening, ";
                                isEvening = true;
                              }
                              (values[i] == values.length - 1)
                                  ? result += "and "
                                  : ".";
                            }
                          }
                        }
                      });
                    }
                    print(result);
                    Navigator.pop(context, result);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlotCheckbox(int dayIndex, int slotIndex, String slotName) {
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
        // Checkbox(
        //   value: slots[dayIndex][slotIndex],
        //   onChanged: (value) {
        //     setState(() {
        //       slots[dayIndex][slotIndex] = value!;
        //       print(slots);
        //     });
        //   },
        // ),
      ],
    );
  }
}
