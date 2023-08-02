import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class CountdownProgressIndicator extends StatefulWidget {
  final int durationInSeconds;
  final Function() onTimerComplete;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  CountdownProgressIndicator({
    required this.durationInSeconds,
    required this.onTimerComplete,
    required this.flutterLocalNotificationsPlugin,
  });

  @override
  _CountdownProgressIndicatorState createState() =>
      _CountdownProgressIndicatorState();
}

class _CountdownProgressIndicatorState extends State<CountdownProgressIndicator> {
  late Timer _timer;
  bool _showSlider = false; // Define the _showSlider variable
  int _remainingSeconds = 0;
  final String _baseUrl = "10.0.2.2:8080";
  DateTime _value = DateTime(2010, 01, 01, 15, 00, 00);
  String clientId = "";
  String zoneTitle = "";
  String numeroParking = "";
  String matricule = "";
  String duree = "";
  String endTime = "";
  String sessionId ="";
  String  price ="" ;
  @override
  void initState() {
    super.initState();

    _getDurationInSeconds().then((durationInSeconds) {
      setState(() {
        _remainingSeconds = durationInSeconds;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_remainingSeconds > 0) {
              _remainingSeconds--;
              int hours = _remainingSeconds ~/ 3600;
              int minutes = (_remainingSeconds % 3600) ~/ 60;
              int seconds = _remainingSeconds % 60;

              print('Remaining Time: $hours:$minutes:$seconds');

              if (_remainingSeconds == 10) {
                final AndroidNotificationDetails androidPlatformChannelSpecifics =
                AndroidNotificationDetails(
                  'your_channel_id',
                  'your_channel_name',
                  importance: Importance.max,
                  priority: Priority.high,
                  ticker: 'ticker',
                );
                final NotificationDetails platformChannelSpecifics =
                NotificationDetails(android: androidPlatformChannelSpecifics);

                widget.flutterLocalNotificationsPlugin.show(
                  0, // Notification ID
                  'Notification Time', // Title of the notification
                  'The Time is Coming to an end', // Body of the notification
                  platformChannelSpecifics, // Notification details
                );
              }
            } else {
              _timer.cancel();
              widget.onTimerComplete();
            }
          });
        });
      });
    });
  }

  Future<int> _getDurationInSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String duree = prefs.getString("duree") ?? "";
    List<String> timeParts = duree.split(':');
    if (timeParts.length == 2) {
      int hours = int.tryParse(timeParts[0]) ?? 0;
      int minutes = int.tryParse(timeParts[1]) ?? 0;
      int durationInSeconds = hours * 3600 + minutes * 60;
      print('Parsed duration: $durationInSeconds seconds');
      return durationInSeconds;
    } else {
      print('Invalid value for duree: $duree');
      return 0;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _retrieveData();
    super.dispose();
  }

  SfRangeValues _values = SfRangeValues(
    DateTime(2010, 01, 01, 12, 00, 00),
    DateTime(2010, 01, 01, 15, 30, 00),
  );

  late int minHour;
  late int minMinute;
  late int maxHour;
  late int maxMinute;
  late String durationString;
  late String updateTime = '';

  void _handleSliderChange(SfRangeValues newValues) {
    setState(() {
      _values = newValues;
    });

    DateTime minValue = _values.start;
    DateTime maxValue = _values.end;

    // Duration calculation
    Duration duration = maxValue.difference(minValue);
    int hours = duration.inHours; // Total number of hours
    int minutes = duration.inMinutes.remainder(60); // Total number of remaining minutes after hours

    print('Duration: $hours hours and $minutes minutes');

    minHour = minValue.hour;
    minMinute = minValue.minute;

    maxHour = maxValue.hour;
    maxMinute = maxValue.minute;

    print('Minimum value: $minHour:$minMinute');
    print('Maximum value: $maxHour:$maxMinute');
    durationString = '$hours:$minutes';
    print('Duration string: $durationString');

    _updateTime(); // Update the time values
  }

  void _updateTime() {
    setState(() {
      updateTime = '$maxHour:$maxMinute';
    });
    print("Update: $updateTime");
  }

  int _calculateRemainingSeconds(int hour, int minute) {
    final now = DateTime.now();
    final targetTime = DateTime(now.year, now.month, now.day, hour, minute);
    final difference = targetTime.difference(now);
    final remainingSeconds = difference.inSeconds;
    return remainingSeconds > 0 ? remainingSeconds : 0;
  }
  Future<void> _retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clientId = prefs.getString("clientId") ?? "";
      zoneTitle = prefs.getString("zoneTitle") ?? "";
      numeroParking = prefs.getString("numeroParking") ?? "";
      matricule = prefs.getString("matricule") ?? "";
      duree = prefs.getString("duree") ?? "";
      endTime = prefs.getString("endTime") ?? "";
      price=  prefs.getString("price") ?? "";
      sessionId= prefs.getString("sessionId") ?? "";


    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SleekCircularSlider(
            appearance: CircularSliderAppearance(
              customColors: CustomSliderColors(
                progressBarColors: [
                  Colors.deepPurpleAccent,
                  _remainingSeconds <= 10 ? Colors.redAccent : Colors.lightBlueAccent,
                ],
                trackColor: Colors.grey,
              ),
              infoProperties: InfoProperties(
                modifier: (double value) {
                  // Convert the remaining seconds to hours, minutes, and seconds
                  int hours = _remainingSeconds ~/ 3600;
                  int minutes = (_remainingSeconds % 3600) ~/ 60;
                  int seconds = _remainingSeconds % 60;

                  // Display the remaining time in the center of the slider
                  return '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
                },
                mainLabelStyle: const TextStyle(fontSize: 20),
              ),
            ),
            min: 0,
            max: widget.durationInSeconds.toDouble(),
            initialValue: widget.durationInSeconds.toDouble(),
            onChange: (double value) {},
          ),
        ),
          Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Parking Area :',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Parking Lot of San Manolia',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 19),
              Row(
                children: [
                  Text(
                    'Address :',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 80),
                  Text(
                    '9569, Trantow Courts',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 19),
              Row(
                children: [
                  Text(
                    'Car',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 100),
                  Text(
                    ' (AF 4793 JU)',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 19),
              Row(
                children: [
                  Text(
                    'Duration :',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 80),
                  Text(
                    '4 hours',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 19),
              Row(
                children: [
                  Text(
                    'Hours :',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 80),
                  Text(
                    '09.00 AM - 13.00 PM',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 90),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF999CF0), // Set the background color
              // Set the text color
            ),
            child: const Text("Extend Parking Time"),
            onPressed: () {
              setState(() {
                _showSlider = true; // Set a boolean flag to show the slider
              });
            },
          ),
        ),
        if (_showSlider)
          SfRangeSlider(
            min: DateTime(2010, 01, 01, 9, 00, 00),
            max: DateTime(2010, 01, 01, 21, 05, 00),
            values: _values,
            interval: 4,
            showTicks: true,
            showLabels: true,
            enableTooltip: true,
            activeColor: Color(0xFF4448AE), // Set the desired color
            dateFormat: DateFormat('h:mm'),
            dateIntervalType: DateIntervalType.hours,
            tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
              return DateFormat('h:mm a').format(actualValue);
            },
            onChanged: _handleSliderChange,
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF999CF0), // Set the background color
            // Set the text color
          ),
          child: const Text('OK'),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? sessionId = prefs.getString("sessionId");
            _updateTime(); // Update the time values
            Map<String, String> headers = {"Content-Type": "application/json; charset=UTF-8"};
            http
                .post(Uri.http(_baseUrl, "/Backend/users/updateParkingDuration/$sessionId/$updateTime"), headers: headers)
                .then((http.Response response) async {
              if (response.statusCode == 200) {
                print('API Response Body: ${response.body}');
                setState(() {
                  _showSlider = false; // Reset the flag to hide the slider
                  // Update the remaining seconds based on the new time value
                  _remainingSeconds = _calculateRemainingSeconds(maxHour, maxMinute);
                });
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("Information"),
                      content: Text("Une erreur s'est produite. Veuillez réessayer !"),
                    );
                  },
                );
              }
            });
          },
        ),
      ],
    );
  }
}
