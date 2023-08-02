import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';





import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stripedemo/users/profile.dart';
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late String? _username;
  late String? _NickName;
  late String? _email;
  late String? _password;
  late String? _birth;
  late String? _phone;
  late String? _gendre;


  final String _baseUrl = "10.0.2.2:8080";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: _formKey,
        child: ListView(

        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('lib/images/Ellipse.png'),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Handle edit image button press
                    },
                    icon: Icon(
                      IconlyBold.editSquare,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
            SizedBox(
              height: 30,
            ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
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
                labelText: "Full Name",
              ),
              onSaved: (String? value) {
                _username= value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
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
              ),
              onSaved: (String? value) {
                _email= value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
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
                labelText: "NickName",
              ),
              onSaved: (String? value) {
                _NickName= value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
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
                labelText: "Date of Birth",
              ),
              onSaved: (String? value) {
                _birth= value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
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
                labelText: "Phone Number",
              ),
              onSaved: (String? value) {
                _phone = value;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(

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
                labelText: "Gendre",
              ),
              onSaved: (String? value) {
                _gendre= value;
              },
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 30),

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
                  child: const Text("Edit"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Map<String, dynamic> userData= {

                        "firstName":_username,
                        "lastName":_NickName,
                        "phoneNumber":_phone,
                        "gender": _gendre,
                        "dateOfBirth":_birth,
                        "email":_email
                      };
                      Map<String, String> headerss = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };

                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      String? idUser= prefs.getString("userId");
                      http.put(Uri.http(_baseUrl, "/Backend/users/$idUser/profile"), headers: headerss,body: json.encode(userData))
                          .then((http.Response response) async {
                        if (response.statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileInterface()),
                          );
                        } else {
                          // Handle non-200 status code
                        }
                      }).catchError((error) {
                        // Handle any errors or exceptions
                      });
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

