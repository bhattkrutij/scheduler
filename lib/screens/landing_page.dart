import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/screens/schedule_page.dart';
import 'package:scheduler/utils/string_utils.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String textValue = "";
  @override
  Widget build(BuildContext context) {
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
                child: Text(textValue),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SchedulePage(),
                    ),
                  );

                  if (result != null && result is String) {
                    setState(() {
                      textValue = result;
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
