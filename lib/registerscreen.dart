import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    Firestore.instance.collection('users').document(email.text).setData({
      'email': email.text,
      'fullName': fullName.text,
      'phoneNumber': phoneNumber.text,
      'userType': group
    });
    return email.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Registration"),
      ),
      body: Container(
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
                            controller: fullName,
                            decoration: InputDecoration(hintText: "Full Name"),
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
                            obscureText: true,
                            decoration: InputDecoration(hintText: "Password"),
                          ),
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
    );
  }
}
