import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/SquareTile.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  late String? _email;
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
                  "Create your",
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
                child: const Text("Sign up"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Map<String, dynamic> userData = {
                      "password" : _password,
                      "email" : _email,
                    };
                    Map<String, String> headers = {
                      "Content-Type": "application/json; charset=UTF-8"
                    };
                    http.post(Uri.http(_baseUrl, "/Backend/users/adduser"), headers: headers, body: json.encode(userData))
                        .then((http.Response response) {

                      if(response.statusCode == 200) {

                        Navigator.pushReplacementNamed(context, "/");



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
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // Add your logic here to handle the click event
                          // For example, navigate to the sign-in page
                          Navigator.pushNamed(context, "/"); // Replace "/signin" with your sign-in route name
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: Color(0xFF4448AE), // Color "#4448AE"
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )

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
