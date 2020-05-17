import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:style_it_up/loginscreen.dart';

class Registrationscreen extends StatefulWidget {
  @override
  _RegistrationscreenState createState() => _RegistrationscreenState();
}

class _RegistrationscreenState extends State<Registrationscreen> {
  String group;
  String user;
  TextEditingController fullName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<String> register() async {
    FirebaseUser user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text))
        .user;
    print(user.uid);
    createUserDb();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    return user.uid;
  }

  Future<String> createUserDb() async {
    Firestore.instance
        .collection('users')
        .document(email.text.toLowerCase())
        .setData({
      'email': email.text.toLowerCase(),
      'fullName': fullName.text,
      'address': address.text,
      'phoneNumber': phoneNumber.text,
      'userType': group
    });
    return email.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          //height: 600.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green, Colors.blue])),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("icon.png"),
                      ),
                      Text("Registration"),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              onTap: () {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please enter organization name if you are registering as organization",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.red,
                                    gravity: ToastGravity.TOP,
                                    textColor: Colors.white);
                              },
                              controller: fullName,
                              decoration: InputDecoration(
                                hintText: "Full Name",
                              ),
                            ),
                            TextField(
                              controller: address,
                              decoration: InputDecoration(hintText: "Address"),
                            ),
                            TextField(
                              controller: phoneNumber,
                              decoration:
                                  InputDecoration(hintText: "Phone Number"),
                            ),
                            TextField(
                              controller: email,
                              decoration: InputDecoration(hintText: "Email"),
                            ),
                            TextField(
                              controller: password,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: "Password",
                                suffixIcon: IconButton(
                                    icon: FaIcon(
                                      _obscureText
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye,
                                      color: Colors.deepOrange,
                                    ),
                                    onPressed: _toggle),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Radio(
                                      value: "customer",
                                      groupValue: group,
                                      onChanged: (T) {
                                        print(T);
                                        setState(() {
                                          group = T;
                                        });
                                      },
                                    ),
                                    Text("Customer"),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Radio(
                                      value: "organization",
                                      groupValue: group,
                                      onChanged: (T) {
                                        print(T);
                                        setState(() {
                                          group = T;
                                        });
                                      },
                                    ),
                                    Text("Organization"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      onPressed: register,
                      child: Text("Register"),
                      color: Colors.pinkAccent,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Already have an account? Login!"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
