import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String group;
  String user;
  String fullName;
  String address;
  bool isLoading = false;
  String phoneNumber;
  // TextEditingController fullName = TextEditingController();
  //TextEditingController address = TextEditingController();
  // TextEditingController phoneNumber = TextEditingController();
  // TextEditingController email = TextEditingController();
  // TextEditingController password = TextEditingController();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Check if form is valid before perform registration
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
                .createUserWithEmailAndPassword(
                    email: email, password: password))
            .user;
        print(user.uid);
        Firestore.instance
            .collection('users')
            .document(email.toLowerCase())
            .setData({
          'email': email.toLowerCase(),
          'fullName': fullName,
          'address': address,
          'phoneNumber': phoneNumber,
          'userType': group,
          "location": GeoPoint(0, 0),
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } catch (e) {
        print(e.message);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // String valdateFullName(String value){
  //   Pattern pattern =
  // }

  String validatePhoneNumber(String value) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
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
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green, Colors.blue])),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("lib/assets/icon.png"),
                            ),
                            Text(
                              "Registration",
                              style: GoogleFonts.notoSans(
                                  fontSize: 20.0, color: Colors.black87),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        3.0, 15.0, 3.0, 15.0),
                                    child: TextFormField(
                                      onSaved: (value) =>
                                          fullName = value.trim(),
                                      //controller: fullName,
                                      onTap: () {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please enter organization name if you are registering as organization",
                                            toastLength: Toast.LENGTH_LONG,
                                            backgroundColor: Colors.red,
                                            gravity: ToastGravity.TOP,
                                            textColor: Colors.white);
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Full Name",
                                        hintStyle: GoogleFonts.notoSans(
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        3.0, 15.0, 3.0, 15.0),
                                    child: TextFormField(
                                      //controller: address,
                                      onSaved: (value) =>
                                          address = value.trim(),
                                      decoration: InputDecoration(
                                        hintText: "Address",
                                        hintStyle: GoogleFonts.notoSans(
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        3.0, 15.0, 3.0, 15.0),
                                    child: TextFormField(
                                      validator: validatePhoneNumber,
                                      onSaved: (value) =>
                                          phoneNumber = value.trim(),
                                      decoration: InputDecoration(
                                        hintText: "Phone Number",
                                        hintStyle: GoogleFonts.notoSans(
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
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
                                      onSaved: (value) =>
                                          password = value.trim(),
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
                                              color: Colors.deepOrange,
                                            ),
                                            onPressed: _toggle),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                          Text(
                                            "Customer",
                                            style: GoogleFonts.notoSans(
                                                color: Colors.black87),
                                          ),
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
                                          Text(
                                            "Organization",
                                            style: GoogleFonts.notoSans(
                                                color: Colors.black87),
                                          ),
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
                          padding: const EdgeInsets.only(top: 23),
                          child: RaisedButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              validateAndSubmit();
                            },
                            child: Text("Register"),
                            color: Colors.pinkAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("Already have an account? Login!"),
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
    );
  }
}
