
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stripedemo/users/signin.dart';
class CreatNewPassword extends StatefulWidget {
  const CreatNewPassword({Key? key}) : super(key: key);

  @override
  State<CreatNewPassword> createState() => _CreatNewPasswordState();
}

class _CreatNewPasswordState extends State<CreatNewPassword> {

  late String? _passwordnew;
  late String? _password;
  bool rememberMe = false;

  final String _baseUrl = "10.0.2.2:8080";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
                margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),

                child: Image.asset('lib/images/Auto Layout Horizontal.png')

            ),
            Container(
                margin: const EdgeInsets.fromLTRB(10, 10,10 , 0),

                child: Image.asset('lib/images/Mobile login-bro 1.png',)

            ),

            Container(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(


                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF8F7FD),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Color(0xFF999CF0)),
                  ),
                  labelText: "New Password",

                  prefixIcon: Icon(Icons.password, color: Color(0xFF9E9E9E)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    color: Color(0xFF9E9E9E),
                    onPressed: () {},
                  ),
                ),
                onSaved: (String? value) {
                  _password = value;
                },

              ),
            ),

            Container(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF8F7FD),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Color(0xFF999CF0)),
                  ),
                  labelText: "New Password",

                  prefixIcon: Icon(Icons.password, color: Color(0xFF9E9E9E)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    color: Color(0xFF9E9E9E),
                    onPressed: () {},
                  ),
                ),
                onSaved: (String? value) {
                  _passwordnew = value;
                },

              ),
            ),


            Container(
              padding: EdgeInsets.fromLTRB(90, 10, 30, 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.transparent),
                    ),
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all<Color>(Color(0xFF4448AE)),
                      value: rememberMe,
                      onChanged: (bool? newValue) {
                        setState(() {
                          rememberMe = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 26,
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF212121),
                    ),
                  ),
                ],
              ),
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
                          'Content-Type': 'application/json',
                        };
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                     String? emailin=   prefs.getString("emailpassword");
                        http.get(Uri.http(_baseUrl, "/Backend/users/$emailin"), headers: headers)
                            .then((http.Response response) async {
                          if (response.statusCode == 200) {
                            List<String> userIds = List<String>.from(json.decode(response.body));

                            if (userIds.isNotEmpty) {
                              String userIdpassw = userIds[0];

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("userIdPassword", userIdpassw);

                              print("User ID: $userIdpassw");
                            } else {
                              // Handle case when the userIds list is empty
                            }
                          } else {
                            // Handle non-200 status code
                          }
                        }).catchError((error) {
                          // Handle any errors or exceptions
                        });
                        Map<String, dynamic> userDatapas = {

                          "password" : _password
                        };
                        Map<String, String> headerss = {
                          "Content-Type": "application/json; charset=UTF-8"
                        };


                        String? idUsers= prefs.getString("userIdPassword");
                        http.put(Uri.http(_baseUrl, "/Backend/users/$idUsers/password"), headers: headerss,body: json.encode(userDatapas))
                            .then((http.Response response) async {
                          if (response.statusCode == 200) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signin()),
                            );
                          } else {
                            // Handle non-200 status code
                          }
                        }).catchError((error) {
                          // Handle any errors or exceptions
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              constraints: BoxConstraints(maxWidth: 400), // Set the maximum width
                              child: AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                                  children: [
                                    Image.asset('lib/images/Mobile login-bro 2.png'),
                                    const Text(
                                      "Congratulations!",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF4448AE),
                                      ),
                                    ),
                                    const Text("Your account is ready to use"),
                                  ],
                                ),
                                actions: [
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFCEC9F2),
                                      ),

                                      onPressed: () async {


                                        },
                                      child: const Text(
                                        "Go to Homepage",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                      }
                    },
                  ),

                )
            ),


          ],
        ),
      ),
    );
  }
}
