import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_it_up/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  String userType;
  Future<void> login() async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email.text, password: password.text))
          .user;
      await Firestore.instance
          .collection('users')
          .document(email.text.trim())
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          userType = ds.data['userType'];
        });
        // use ds as a snapshot
        print(userType);
      });
      print(user.uid);
      print("login successful");

      if (user.uid.length > 0 && user.uid != null) {
        if (userType == "customer") {
          Navigator.of(context).pushNamed('/home');
        } else {
          Navigator.of(context).pushNamed('/orghome');
        }
      }

      return user.uid;
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("invalid details"),
              content: Text("Your email or password is wrong"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OKAY"),
                ),
              ],
            );
          });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("icon.png"),
              ),
              Text(
                "Login",
                style: TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: email,
                      decoration: InputDecoration(hintText: "Email"),
                    ),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Password"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RaisedButton(
                        onPressed: login,
                        child: Text("Login"),
                        color: Colors.pinkAccent,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registrationscreen()));
                        },
                        child: Text("Don't have account? Signup!"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
