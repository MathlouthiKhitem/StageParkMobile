import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripedemo/users/phonecerfication.dart';



import '../SplashScreen.dart';
import '../components/SquareTile.dart';
import 'mailVerfication.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}


class _SigninState extends State<Signin> {


  late String? _email;
  late String? _password;
  bool rememberMe = false;
  bool isGestureDetectorTapped = false;





  final String _baseUrl = "10.0.2.2:8080";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Transform(
              transform: Matrix4.identity()..scale(2.0, 1.0),
              child: Icon(
                Icons.arrow_back,
                textDirection: TextDirection.rtl,
                size: 48,
              ),
            ),

            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(30, 40, 50, 0),
                child:const Text(
                    "Login to your",
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                )


            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(30, 0, 40, 40),
                child:const Text(
                  "Account",
                  style: TextStyle(
                    color: Color(0xFF999CF0),
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                )

            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF8F7FD),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Color(0xFF999CF0)),
                  ),
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Color(0xFF9E9E9E)),
                  labelStyle: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                    fontFamily: "UrbNIST",
                  ),
                ),
                onSaved: (String? value) {
                  _email = value;
                },
                validator: (String? value) {
                  RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if(value!.isEmpty || !regex.hasMatch(value)) {
                    return "L'adresse email n'est pas valide !";
                  }
                  else {
                    return null;
                  }
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
                  labelText: "Mot de passe",

                  prefixIcon: Icon(Icons.lock, color: Color(0xFF9E9E9E)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    color: Color(0xFF9E9E9E),
                    onPressed: () {},
                  ),
                ),
                onSaved: (String? value) {
                  _password = value;
                },
                validator: (String? value) {
                  if(value!.isEmpty || value.length < 5) {
                    return "Le mot de passe ne doit pas avoir moins de 5 caractères !";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),


            Container(
              padding: EdgeInsets.fromLTRB(90, 10, 30, 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all<Color>(Color(0xFF4448AE)),
                      value: rememberMe,
                      onChanged: (bool? newValue) {
                        setState(() {
                          rememberMe = newValue ?? false;
                        });
                        SplashScreen();
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
                    child: const Text("Sign in"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                       //   Navigator.pushNamed(context, "/homeBottom");
                        Map<String, dynamic> userData = {

                          "email" : _email,
                          "password" : _password
                        };
                        Map<String, String> headers = {
                          'Content-Type': 'application/json',
                        };
                        http.post(Uri.http(_baseUrl, "/Backend/users/signin"), body: json.encode(userData), headers: headers)
                            .then((http.Response response) async {
                          if(response.statusCode == 200) {
                            Navigator.pushReplacementNamed(context, "/homeBottom");
                            Map<String, dynamic> userData = json.decode(response.body);

                            // Shared preferences
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("userEmail", userData["email"]);
                           String? emailout=  prefs.getString("userEmail");

                           print(emailout);
                            http.get(Uri.http(_baseUrl, "/Backend/users/$emailout"), headers: headers)
                                .then((http.Response response) async {
                              if (response.statusCode == 200) {
                                List<String> userIds = List<String>.from(json.decode(response.body));

                                if (userIds.isNotEmpty) {
                                  String userId = userIds[0];

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString("userId", userId);

                                  print("User ID: $userId");
                                } else {
                                  // Handle case when the userIds list is empty
                                }
                              } else {
                                // Handle non-200 status code
                              }
                            }).catchError((error) {
                              // Handle any errors or exceptions
                            });
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



                      }
                    },
                  ),
                )
            ),
            Align(
              alignment: Alignment.center, // Aligns the child at the center
              child: TextButton(
                onPressed:(){
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      builder: (context)=>Container(
                       padding: EdgeInsets.all(16.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,

                         children: [
                           Container(
                             child: Center(
                               child: Image.asset(
                                 'lib/images/Forgot password-rafiki 1.png', // Replace with your image asset path
                                 width: 170,
                                 height: 160,
                               ),
                             ),
                           ),
                           SizedBox(
                             width: 2,
                           ),
                           const Text( "Make Selection!",
                             style: TextStyle(
                               fontSize: 30,
                               color: Color(0xFF4448AE),
                             )),
                           Text("Select which contact details should we use to reset your password",style: Theme.of(context).textTheme.bodyText2),
                              const SizedBox(
                                height: 30,
                              ),
                           GestureDetector(
                             onTap: () {
                               setState(() {
                                 isGestureDetectorTapped = !isGestureDetectorTapped;
                               });

                               // Navigate to another screen or route
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => PhoneVerfiavtion()),
                               );
                             },
                             child: Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.0),
                                 color: isGestureDetectorTapped ? Colors.pink : Color(0xFFF1F2FF),
                                 border: Border.all(
                                   color: isGestureDetectorTapped ? Colors.pink : Colors.transparent,
                                   width: 2.0,
                                 ),
                               ),
                               padding: EdgeInsets.all(20.0),
                               child: const Row(
                                 children: [
                                   Icon(Icons.sms_outlined, size: 30),
                                   SizedBox(width: 10),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(
                                         "SMS",
                                         style: TextStyle(
                                           fontSize: 25,
                                           color: Color(0xFF999CF0),
                                         ),
                                       ),
                                       Text(
                                         "Reset via SMS verification",
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             ),
                           ),

                           const SizedBox(
                             height: 20,
                           ),
                           Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10.0),
                               color: isGestureDetectorTapped ? Colors.pink : Color(0xFFF1F2FF),
                               border: Border.all(
                                 color: isGestureDetectorTapped ? Colors.pink : Colors.transparent,
                                 width: 2.0,
                               ),
                             ),

                             child: GestureDetector(
                               onTap: () async {
                                 setState(() {
                                   isGestureDetectorTapped = !isGestureDetectorTapped;
                                 });
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => MailVerfication()),
                                     );



                               },
                               child: Container(
                                 padding: EdgeInsets.all(20.0),
                                 child: const Row(
                                   children: [
                                     Icon(Icons.mail_outline, size: 30),
                                     SizedBox(width: 10),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text(
                                           "E-Mail",
                                           style: TextStyle(
                                             fontSize: 25,
                                             color: Color(0xFF999CF0),
                                           ),

                                         ),
                                         Text(
                                           "Reset via Mail verification",
                                         ),
                                       ],
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                  )
                  );
                },
                child: Text(
                  'Forgot the password?',
                  style: TextStyle(
                    color: Color(0xFF4D5DFA), // Color "#4D5DFA"
                  ),
                ),


              ),
            ),

             Center(
                child: TextButton(
                  onPressed: () {
                    // Add the navigation logic to go to the login page
                    Navigator.pushNamed(context, "/signup"); // Replace "/login" with your login route name
                  },
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color(0xFF4D5DFA), // Color "#4D5DFA"
                    ),
                  ),
                )



            ),

            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120.0,
                        height: 1.0,
                        color: const Color(0xFF9E9E9E),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Continue with",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 120.0,
                        height: 1.0,
                        color: Color(0xFF9E9E9E),
                      ),
                    ],
                  ),
                  SizedBox(height: 23),

                  // google + apple sign in buttons
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(imagePath: 'lib/images/google.png'),

                      SizedBox(width: 25),

                      // apple button
                      SquareTile(imagePath: 'lib/images/apple.png')
                    ],
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xFF4448AE), // Color "#4448AE"
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

