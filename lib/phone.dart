import 'package:flutter/material.dart';
import 'package:phone_otp/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Phone extends StatefulWidget {

  static String verify = "";

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  TextEditingController countryCodeController = TextEditingController();
  var phone = "";

  final form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    countryCodeController.text = "+91";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: form,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img1.png",
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Phone Verification',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        SizedBox(
                          width: 60,
                          child: TextFormField(
                            controller: countryCodeController,
                            validator: (value) {
                              if (value == "") {
                                return "Please enter name";
                              } else {
                                return null;
                              }
                            },
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                        Text('|',
                            style: TextStyle(fontSize: 40, color: Colors.grey)),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              phone = value;
                            },
                            validator: (value) {
                              if (value == "") {
                                return "Please enter phone number";
                              } else {
                                return null;
                              }
                            },
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: 'Phone',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (form.currentState!.validate()) {

                          await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '${countryCodeController.text + phone}',
                              verificationCompleted: (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent: (String verificationId, int? resendToken) {

                                Phone.verify= verificationId;

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Otp()));
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {});
                        }
                      },
                      child: Text('Send Otp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
