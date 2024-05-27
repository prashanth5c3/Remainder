import 'dart:math';

import 'package:alaram/Provider/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  String? dateTime;
  bool repeat = false;
  DateTime? notificationtime;
  String? name = "none";
  int? milliseconds;

  // Add a list of label options
  final List<String> labels = [
    "Day of the week",
    "Wake up",
    "Go to gym",
    "Breakfast",
    "Meetings",
    "Lunch",
    "Quick nap",
    "Go to library",
    "Dinner",
    "Go to sleep"
  ];

  // Add a selected label variable
  String selectedLabel = "Day of the week";

  @override
  void initState() {
    context.read<alarmprovider>().GetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check),
          )
        ],
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Alarm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CupertinoDatePicker(
                showDayOfWeek: true,
                minimumDate: DateTime.now(),
                dateOrder: DatePickerDateOrder.dmy,
                onDateTimeChanged: (va) {
                  dateTime = DateFormat().add_jms().format(va);
                  milliseconds = va.microsecondsSinceEpoch;
                  notificationtime = va;
                  print(dateTime);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonFormField<String>(
                value: selectedLabel,
                items: labels.map((String label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLabel = newValue!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add Label',
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Repeat daily"),
              ),
              CupertinoSwitch(
                value: repeat,
                onChanged: (bool value) {
                  repeat = value;
                  if (repeat == false) {
                    name = "none";
                  } else {
                    name = "Everyday";
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Random random = new Random();
              int randomNumber = random.nextInt(100);

              context.read<alarmprovider>().SetAlaram(
                  selectedLabel, dateTime!, true, name!, randomNumber, milliseconds!);
              context.read<alarmprovider>().SetData();

              context.read<alarmprovider>().SecduleNotification(notificationtime!, randomNumber);

              Navigator.pop(context);
            },
            child: Text("Set Alarm"),
          ),
        ],
      ),
    );
  }
}
