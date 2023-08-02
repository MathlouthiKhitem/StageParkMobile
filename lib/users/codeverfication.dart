import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../components/SquareTile.dart';
import 'creatNewPassword.dart';

class CodeVerfication extends StatefulWidget {
  final String responseBody;

  CodeVerfication({required this.responseBody});

  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerfication> {
  late String verificationCode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 69, 40, 15),
            child: Image.asset('lib/images/flech.png'),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Image.asset('lib/images/Forgot password-rafiki 1.png', width: 460, height: 215),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80,),
                const Text(
                  "Enter the verification code sent to your phone number",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30,),
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: Color(0xFF512DA8),
                  fillColor: Color(0xFF999CF0).withOpacity(0.1),
                  filled: true,
                  showFieldAsBox: true,
                  onSubmit: (String code) {
                    verificationCode = code;
                    if (verificationCode == widget.responseBody) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        },
                      ).then((value) {
                        if (value != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreatNewPassword()),
                          );
                        }
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Incorrect Code"),
                            content: Text("The entered code is incorrect."),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF999CF0), // Set the background color
                      // Set the text color
                    ),
                    child: const Text("Next"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreatNewPassword()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
