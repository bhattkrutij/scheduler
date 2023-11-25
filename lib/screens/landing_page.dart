import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/screens/schedule_page.dart';
import 'package:scheduler/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/prefs_utils.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  SharedPreferences? prefs;
  String textValue = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intiSharedPref();
  }

  void intiSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    textValue = getPrefTitle(prefs);
    print("textvalue ${textValue}");
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  textValue,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final results = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SchedulePage(),
                    ),
                  );

                  if (results != null && results is String) {
                    setState(() {
                      textValue = results;
                    });
                  }
                },
                child: Text(textValue.isEmpty
                    ? StringUtils.ADD_SCHEDULE
                    : StringUtils.EDIT_SCHEDULE))
          ],
        ),
      ),
    ));
  }
}
