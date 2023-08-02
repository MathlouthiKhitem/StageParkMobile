import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'AnimatedProgressBar.dart';
import 'SleekCircularSlider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final String _baseUrl = "10.0.2.2:8080";


  @override
  void initState() {
    super.initState();
    int hour = _progressValue.floor().toInt();
    DateTime currentTime = DateTime.now();
    endTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      hour,
    );
  }



  int _progressValue = 0;
  late DateTime endTime;
  late String durationString;

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingControllervoiture = TextEditingController();
  FocusNode _focusNode = FocusNode();
  FocusNode _focusNodevoitre = FocusNode();
  Future<void> _saveLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = _textEditingController.text;
    await prefs.setString('location', location);
  }
  Future<void> _savevoiture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String voiture = _textEditingControllervoiture.text;
    await prefs.setString('voiture', voiture);

  }

  void _showLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Dismiss the modal when tapping outside the content
            Navigator.pop(context);
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Center(
                    child: Image.asset(
                      'lib/images/undraw_navigation_re_wxx4 1.png',
                      width: 170,
                      height: 160,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  child: const Center(
                    child: Text(
                      "Add location",
                      style: TextStyle(
                        color: Color(0xFF4448AE),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Image.asset(
                    'lib/images/icône-de-violet-location-119002249.webp',
                    width: 70,
                    height: 70,
                  ),
                  title: Text('Location entre manuellement'),
                  onTap: () {
                    Navigator.pop(context);
                    _focusNode.requestFocus(); // Set focus to the text field
                  },
                ),
                SizedBox(height: 29),
                ListTile(
                  leading: Image.asset(
                    'lib/images/download.png',
                    width: 70,
                    height: 70,
                  ),
                  title: Text('Recherché par map'),
                  onTap: () {
                    // Handle location 3 selection
                    //  Navigator.pop(context); // Close the modal
                  },
                ),
                SizedBox(height: 29),
                ListTile(
                  leading: Image.asset(
                    'lib/images/download (1).png',
                    width: 70,
                    height: 70,
                  ),
                  title: Text('Recherché par map'),
                  onTap: () {
                    // Handle location 3 selection
                    //  Navigator.pop(context); // Close the modal
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }




  SfRangeValues _values = SfRangeValues(
    DateTime(2010, 01, 01, 12, 00, 00),
    DateTime(2010, 01, 01, 15, 30, 00),
  );

  late int minHour;
  late int minMinute;
  late int maxHour;
  late int maxMinute;
  String _restText = '';
  void _handleSliderChange(SfRangeValues newValues) {
    setState(() {
      _values = newValues;
    });

    DateTime minValue = _values.start;
    DateTime maxValue = _values.end;

    Duration duration = maxValue.difference(minValue);

    int hours = duration.inHours; // Nombre total d'heures
    int minutes = duration.inMinutes.remainder(60); // Nombre total de minutes restantes après les heures

    print('Durée : $hours heures et $minutes minutes');


    minHour = minValue.hour;
    minMinute = minValue.minute;

     maxHour = maxValue.hour;
     maxMinute = maxValue.minute;

    print('Valeur minimale : $minHour:$minMinute');
    print('Valeur maximale : $maxHour:$maxMinute');
     durationString = '$hours:$minutes';
    print('Valeur durationString : $durationString');
  }



  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Dismiss the modal when tapping outside the content
            Navigator.pop(context);
          },
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  child: Center(
                    child: SvgPicture.asset(
                      'lib/images/undraw_order_ride_re_372k.svg',
                      width: 100,
                      height: 90,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  child: const Center(
                    child: Text(
                      "Add Car!",
                      style: TextStyle(
                        color: Color(0xFF4448AE),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  child: const Center(
                    child: Text(
                      "Ajouter le matricule voiture",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 27),
                ListTile(
                  leading: Image.asset(
                    'lib/images/symbole-de-voiture-icone-png-violet.png',
                    width: 70,
                    height: 70,
                  ),
                  title: Text('Ajouter Matricule voiture '),
                  onTap: () {
                    Navigator.pop(context);
                    _focusNodevoitre.requestFocus();
                    // Set focus to the text field
                  },
                ),
                SizedBox(height: 29),
                ListTile(
                  leading: Image.asset(
                    'lib/images/images (1).png',
                    width: 70,
                    height: 70,
                  ),
                  title: Text('scanner matricule voiture'),
                  onTap: () {
                    // Handle location 3 selection
                    //  Navigator.pop(context); // Close the modal
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  String extractTextAfterSpace(TextEditingController controller) {
    String fullText = controller.text;
    int spaceIndex = fullText.indexOf(' ');
    _restText = spaceIndex != -1 ? fullText.substring(spaceIndex + 1) : '';
    return _restText;
  }
  String extractTextBeforeSpace(TextEditingController controller) {
    String fullText = controller.text;
    int spaceIndex = fullText.indexOf(' ');
    String beforeSpace = spaceIndex != -1 ? fullText.substring(0, spaceIndex) : fullText;
    return beforeSpace;
  }


  @override

  Widget build(BuildContext context) {
    String formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ").format(endTime);
    print("yoyoy$formattedDateTime");

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.center,
              child: Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      labelText: 'Parking Zone',
                      labelStyle: const TextStyle(
                        fontSize: 25,
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.bold,
                      ),

                      prefixIcon: IconButton(
                        icon: const Icon(Icons.location_on, color: Color(0xFF4448AE)),
                        onPressed: () => _showLocationModal(context),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 50.0),
                      border: InputBorder.none,
                    ),
                  )
              ),
            ),


            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.all(0),
                child: GestureDetector(
                  onTap: () {
                    _showModal(context);
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Center(
                          child: Image.asset(
                            'lib/images/auto 1.png',
                            width: 170,
                            height: 160,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textEditingControllervoiture,
                            focusNode: _focusNodevoitre,
                            decoration: const InputDecoration(
                              labelText: 'licensePlateNumber',
                              contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF212121),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: SizedBox(
                  height: 200, // Set the desired height
                  child: SfRangeSlider(
                    min: DateTime(2010, 01, 01, 9, 00, 00),
                    max: DateTime(2010, 01, 01, 21, 05, 00),
                    values: _values,
                    interval: 3,
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
                ),
              ),
            ),






            const SizedBox(
                height: 50,
              ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 30, 30, 10),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF999CF0),
                  ),
                  child: const Text("PRIX"),
                  onPressed: () async {


                  },
                ),
              ),
            ),

            const SizedBox(height: 15),
            Container(
              padding: EdgeInsets.fromLTRB(15, 0, 60, 0),
              child: const SizedBox(
                width: 200,
                height: 50,
                child: Text(
                  "Total: 8.00 dt",
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,

                  ),
                ),
              ),
            ),


            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: SizedBox(
                width: 348,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF999CF0),
                  ),
                  child: const Text("NEXT"),

                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                   String? clientId= prefs.getString("userId");
                    final DateTime now = DateTime.now();
                    final DateTime formattedDateTime = DateTime(now.year, now.month, now.day, maxHour, maxMinute);
                    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
                    final String durationString1 = formatter.format(formattedDateTime);
                    print("durationString1: $durationString1");


                    Map<String, dynamic> userData = {

                        "clientId":clientId,
                        "zoneTitle":extractTextBeforeSpace(_textEditingController),
                        "numeroParking":extractTextAfterSpace(_textEditingController),
                     "matricule" :_textEditingControllervoiture.text,
                        "duree": durationString.toString(),
                      "endTime":durationString1.toString(),



                    };
                    print(_restText);
                    prefs.setString("clientId", userData["clientId"]);
                    prefs.setString("zoneTitle", userData["zoneTitle"]);
                    prefs.setString("numeroParking", userData["numeroParking"]);
                    prefs.setString("matricule", userData["matricule"]);
                    prefs.setString("duree", userData["duree"]);
                    prefs.setString("endTime",  durationString1.substring(11, 19));

                    Map<String, String> headers = {
                      "Content-Type": "application/json; charset=UTF-8"
                    };
                    http.post(Uri.http(_baseUrl, "/Backend/users/add-parking-session"),
                        headers: headers,
                        body: json.encode(userData))

                        .then((http.Response response) async {
                      if (response.statusCode == 200) {
                        print('API Response Body: ${response.body}');
                        Navigator.pushReplacementNamed(context, "/homeTab");
                        //
                        // Map<String, dynamic> userData = json.decode(response.body);
                        //
                        // // Shared preferences
                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("sessionId", response.body);
                        String? sessionId = prefs.getString("sessionId");
                        print("sessdionId: $sessionId");


                      }





                      else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text("Information"),
                                content: Text("Une erreur s'est produite. Veuillez réessayer !"),
                              );
                            });
                      }
                    });
                    // Handle button press
                  },
                ),
              ),
            ),
          ],
        ),
      ),


    );
  }
}


class Data {
  /// Initialize the instance of the [Data] class.
  Data({required this.x, required this.y});

  /// Spline series x points.
  final DateTime x;

  /// Spline series y points.
  final double y;
}
