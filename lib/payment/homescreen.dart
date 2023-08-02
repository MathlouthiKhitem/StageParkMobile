import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navigations/nav_tab.dart';
import '../parking/CountdownProgressIndicator.dart';
import '../parking/info.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Map<String, dynamic>? paymentIntent;
//   String price = "";
//   String duree = "";
//   String sessionId="";
//   int durationInSeconds = 0; // Declare the variable here
//   FlutterLocalNotificationsPlugin notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> _retrieveData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       duree = prefs.getString("duree") ?? "";
//       sessionId= prefs.getString("sessionId") ?? "";
//       List<String> timeParts = duree.split(':');
//       if (timeParts.length == 2) {
//         int hours = int.tryParse(timeParts[0]) ?? 0;
//         int minutes = int.tryParse(timeParts[1]) ?? 0;
//         durationInSeconds = hours * 3600 + minutes * 60;
//         print('Parsed duration: $durationInSeconds seconds');
//         print('Parsed sessionId: $sessionId ');
//       } else {
//         print('Invalid value for duree: $duree');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextButton(
//               child: const Text('Make Payment'),
//               onPressed: () async {
//                 await makePayment();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> makePayment() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       price = prefs.getString("price") ?? "";
//       print("price$price");
//
//       paymentIntent = await createPaymentIntent(price, 'TND');
//
//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret:
//               paymentIntent!['client_secret'],
//               style: ThemeMode.dark,
//               merchantDisplayName: 'Ikay'))
//           .then((value) {});
//
//       //STEP 3: Display Payment sheet
//       displayPaymentSheet();
//     } catch (err) {
//       throw Exception(err);
//     }
//   }
//
//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         // Navigate to CountdownScreen after payment is successful
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>     CountdownProgressIndicator(
//                durationInSeconds: durationInSeconds,
//                onTimerComplete: () {
//                  // Handle timer completion
//                },
//         flutterLocalNotificationsPlugin: notificationsPlugin,
//
//       ),
//           ),
//         );
//
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.check_circle,
//                   color: Colors.green,
//                   size: 100.0,
//                 ),
//                 SizedBox(height: 10.0),
//                 Text("Payment Successful!"),
//               ],
//             ),
//           ),
//         );
//
//         paymentIntent = null;
//       }).onError((error, stackTrace) {
//         throw Exception(error);
//       });
//     } on StripeException catch (e) {
//       print('Error is:---> $e');
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: const [
//                   Icon(
//                     Icons.cancel,
//                     color: Colors.red,
//                   ),
//                   Text("Payment Failed"),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     } catch (e) {
//       print('$e');
//     }
//   }
//
//
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       // Request body
//       Map<String, dynamic> body = {
//         'amount': (int.parse(price) * 100).toString(),
//         'currency': currency,
//       };
//
//       // Make post request to Stripe
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }
// }


class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin { // Move SingleTickerProviderStateMixin here
  Map<String, dynamic>? paymentIntent;

  String price = "";
  String duree = "";
  String sessionId="";
  int durationInSeconds = 0;
  late TabController _tabController;
  FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool status = false; // Declare a variable to store the payment status

  Future<void> _retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      duree = prefs.getString("duree") ?? "";
      sessionId= prefs.getString("sessionId") ?? "";
      List<String> timeParts = duree.split(':');
      if (timeParts.length == 2) {
        int hours = int.tryParse(timeParts[0]) ?? 0;
        int minutes = int.tryParse(timeParts[1]) ?? 0;
        durationInSeconds = hours * 3600 + minutes * 60;
        print('Parsed duration: $durationInSeconds seconds');
        print('Parsed sessionId: $sessionId ');
      } else {
        print('Invalid value for duree: $duree');
      }
    });
  }
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _retrieveData();
    super.initState();
  }
  void _navigateToTimeTab() {
    _tabController.animateTo(2); // 2 is the index of the "Time" tab
    setState(() {
      _tabController.index = 2;
    });
  }
  Future<void> updateSessionStatus() async {
    print('sessiom: $sessionId ');
    final String _baseUrl = "http://10.0.2.2:8080";
    final response = await http.get(Uri.parse("$_baseUrl/Backend/users/updateSessionStatus/$sessionId"));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      // Handle the response here, you can update UI or show a success message.
    } else {
      print("Error: ${response.statusCode}");
      // Handle the error response, you can show an error message to the user.
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text('Make Payment'),
              onPressed: () async {
                await makePayment();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'USD');
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {

      await Stripe.instance.presentPaymentSheet().then((value) {
        void navigateToTimeTabAfterPayment() {
          _navigateToTimeTab();
        }
        setState(() {
          status = true;
        });
        updateSessionStatus();
        // Create an instance of the Info class
        Info infoInstance = Info();
        // Call the method in the Info class and pass the "status" value
        infoInstance.updateStatus(status);
        // Navigate to CountdownScreen after payment is successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  NavigationTab(

            ),
          ),

          // MaterialPageRoute(
          //   builder: (context) =>     CountdownProgressIndicator(
          //     durationInSeconds: durationInSeconds,
          //     onTimerComplete: () {
          //       // Handle timer completion
          //     },
          //     flutterLocalNotificationsPlugin: notificationsPlugin,
          //
          //   ),
          // ),
        );
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
