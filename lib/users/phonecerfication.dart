import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/countries.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'codeverfication.dart';
class PhoneVerfiavtion extends StatefulWidget {
  const PhoneVerfiavtion({Key? key}) : super(key: key);

  @override
  State<PhoneVerfiavtion> createState() => _MailVerficationState();
}

class _MailVerficationState extends State<PhoneVerfiavtion> {
  final String _baseUrl = "10.0.2.2:8080";
  late PhoneNumber? _codephone;
  String? _codephoneText;
   late final String responseBody;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [


            Container(
                margin: const EdgeInsets.fromLTRB(30, 69, 40, 15),

                child: Image.asset('lib/images/flech.png',)

            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),

                child: Image.asset('lib/images/Forgot password-rafiki 1.png',
                    width: 460, height: 215)
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                initialCountryCode: 'US', // Set the initial country code (optional)
                onChanged: (PhoneNumber? number) {
                },
                onSaved: (PhoneNumber? number) {
                  if (number != null) {
                    _codephoneText = number.countryCode! + number.number!;
                  }
                },
                validator: (PhoneNumber? value) {
                  // Perform phone number validation
                  if (value == null ) {
                    return 'Phone number is required';
                  }
                  // Additional validation if needed
                  return null; // Return null for no validation errors
                },

              ),
            ),




            SizedBox(
              height: 20,
            ),


            Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 30),

                // width: 348,
                // height: 50,
                child: SizedBox(
                  width: 348,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF999CF0), // Set the background color
                      // Set the text color
                    ),
                    child: const Text("Next"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Map<String, String> headers = {
                          "Content-Type": "text/plain; charset=UTF-8"
                        };

                        Map<String, dynamic> userData = {
                          "phone": _codephoneText ?? '', // Use _codephoneText as the email value
                        };

                        String rawText = userData['phone'] ?? '';
                        print(rawText); // Print the raw data in text format
                        print("rawTextrawTextrawText ID: $rawText");
                        http.post(Uri.http(_baseUrl, "/Backend/users/send-verification-code"), headers: headers,body: rawText)
                            .then((http.Response response) {

                          if(response.statusCode == 200) {
                            responseBody = response.body;
                            // Display or process the response here
                            print(responseBody);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CodeVerfication(responseBody: responseBody)),
                            );


                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => CreatNewPassword()),
                            // );



                          }

                        });

                      }
                    },
                  ),
                )
            ),
            // if (isResponse200)
            //   TextFormField(
            //     decoration: const InputDecoration(
            //       filled: true,
            //       fillColor: Color(0xFFF8F7FD),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(10.0),
            //         ),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(10.0),
            //         ),
            //         borderSide: BorderSide(color: Color(0xFF999CF0)),
            //       ),
            //       labelText: "Code",
            //       prefixIcon: Icon(Icons.password, color: Color(0xFF9E9E9E)),
            //       labelStyle: TextStyle(
            //         color: Color(0xFF9E9E9E),
            //         fontSize: 14,
            //         fontFamily: "UrbNIST",
            //       ),
            //     ),
            //     onSaved: (String? value) {
            //       code = value!;
            //     },
            //   ),
            // if (isResponse200)  ElevatedButton(
            //   onPressed: () {
            //     if (code == responseBody) {
            //       print(code == responseBody);
            //       print( responseBody);
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => CreatNewPassword()),
            //       );
            //     } else {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             title: Text("Incorrect Code"),
            //             content: Text("The entered code is incorrect."),
            //             actions: <Widget>[
            //               TextButton(
            //                 child: Text("OK"),
            //                 onPressed: () {
            //                   Navigator.of(context).pop();
            //                 },
            //               ),
            //             ],
            //           );
            //         },
            //       );
            //     }
            //   },
            //   child: Text('Test Code'),
            // ),



          ],
        ),
      ),
    );
  }
}


