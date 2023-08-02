import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:stripedemo/payment/TypePayment.dart';
import 'package:stripedemo/parking/payment.dart';
import 'dart:convert';
import '../navigations/nav_tab.dart';
import '../payment/homescreen.dart';
class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();

  void updateStatus(bool status) {
    // Do something with the status value, for example, store it in a variable
    // or update a property within the Info class.
    // You can also perform any other logic you need with the status value.
    // For demonstration purposes, let's just print it.
    print("Received status in Info class: $status");
  }

}

class _InfoState extends State<Info> {
  String clientId = "";
  String zoneTitle = "";
  String numeroParking = "";
  String matricule = "";
  String duree = "";
  String endTime = "";
  String sessionId ="";
  String  price ="" ;
  late final responseBody ;
  final String _baseUrl = "10.0.2.2:8080";
  String status = '';
  String functionContent = "";

  @override
  void initState() {
    getPriceFromAPI();
    super.initState();
    _retrieveData();





  }



  Future<double> getPriceFromAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("sessionId");
    print("sessionId: $sessionId");

    final response = await http.get(Uri.http(_baseUrl, "/Backend/users/calculate-total-price/$sessionId"));

    if (response.statusCode == 200) {
       responseBody = response.body;
      print('API Response: $responseBody');

      prefs.setString("price", responseBody.trim() );

      try {
        final priceString = responseBody.trim();
        return double.parse(priceString);
      } catch (e) {
        print('Error parsing price: $e'); // Log the parsing error
        throw Exception('Invalid price format');
      }
    } else {
      print('API Request failed: ${response.statusCode}'); // Log the request failure
      throw Exception('Failed to retrieve price from the API');
    }
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

      print("testid$price");
    });
  }

  Widget build(BuildContext context) {
    // Use the retrieved values in your widget's build method
    return Center(
      child: Container(
        width: 300, // Set the desired width
        height: 400, // Set the desired height
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use the retrieved values in your widget
                Text(
                  'Parking Area:  $zoneTitle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Numero Parking:  $numeroParking',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Matricule:  $matricule',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Durée:  $duree',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'EndTime:  $endTime',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Price:  $price TND',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green, // Custom color for the price text
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 10,
                ),

                Center(
                  child: SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF999CF0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Confirm Payment",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
