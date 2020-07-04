import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/registerscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String userType;

  bool _obscureText = true;
  bool isLoading = false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Check if form is valid before perform login
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        isLoading = true;
      });
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: email.toLowerCase(), password: password))
            .user;
        await Firestore.instance
            .collection('users')
            .document(email.toLowerCase().trim())
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
        setState(() {
          isLoading = false;
        });
        if (user.uid.length > 0 && user.uid != null) {
          if (userType == "customer") {
            Navigator.of(context).pushNamed('/home');
          } else {
            Navigator.of(context).pushNamed('/orghome');
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text("invalid details"),
        //         content: Text("Your email or password is wrong"),
        //         actions: <Widget>[
        //           FlatButton(
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //             child: Text("OKAY"),
        //           ),
        //         ],
        //       );
        //     });

        print(e);
      }
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  //validator for password
  String validatePassword(String value) {
    if (value.length < 8)
      return 'Password must be 8 character long';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green, Colors.blue])),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 200.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("lib/assets/icon.png"),
                        ),
                        Text(
                          "Login",
                          style: GoogleFonts.notoSans(
                              fontSize: 25.0, color: Colors.black87),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    3.0, 15.0, 3.0, 15.0),
                                child: TextFormField(
                                  validator: validateEmail,
                                  onSaved: (value) => email = value.trim(),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: GoogleFonts.notoSans(
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    3.0, 15.0, 3.0, 15.0),
                                child: TextFormField(
                                  validator: validatePassword,
                                  onSaved: (value) => password = value.trim(),
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: GoogleFonts.notoSans(
                                        color: Colors.black87),
                                    suffixIcon: IconButton(
                                        icon: FaIcon(
                                          _obscureText
                                              ? FontAwesomeIcons.eyeSlash
                                              : FontAwesomeIcons.eye,
                                          color: Colors.black,
                                        ),
                                        onPressed: _toggle),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: RaisedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    validateAndSubmit();
                                  },
                                  child: Text("Login"),
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen()));
                                    },
                                    child: Text("Don't have account? Signup!")),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ));
  }
}
