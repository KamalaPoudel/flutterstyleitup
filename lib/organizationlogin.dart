import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_it_up/orghome.dart';

class OrganizationLoginScreen extends StatefulWidget {
  @override
  _OrganizationLoginScreenState createState() =>
      _OrganizationLoginScreenState();
}

class _OrganizationLoginScreenState extends State<OrganizationLoginScreen> {
  TextEditingController email1 = TextEditingController();

  TextEditingController password1 = TextEditingController();

  Future<String> login() async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: email1.text, password: password1.text))
          .user;
      print(user.uid);
      print("login successful");
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
      appBar: AppBar(),
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
              Text("Organization Login"),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: email1,
                      decoration: InputDecoration(hintText: "Email"),
                    ),
                    TextField(
                      controller: password1,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Password"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/orghome');
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.pinkAccent,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrgHome()));
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
