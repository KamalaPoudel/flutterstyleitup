import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class myProfile extends StatefulWidget {
  //myprofile class to see the details of registered customers
  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  String userEmail;

  @override
  void initState() {
    userData();
    super.initState();
  }

  Future<String> userData() async {
    //identifying current user
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String email = user.email;
    this.setState(() {
      userEmail = email;
    });

    return email;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: GoogleFonts.notoSans(fontSize: 30.0, color: Colors.white),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(userEmail)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 40.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 100.0, 0, 15.0),
                          child: Image.asset("lib/assets/icon.png"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(
                          "STYLEitUP",
                          style: GoogleFonts.notoSans(
                              fontSize: 24.0, color: Colors.black),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 10.0, 0, 15.0),
                          child: Text(
                            snapshot.data[
                                'fullName'], //fetching fullname from users collection
                            style: GoogleFonts.notoSans(
                                fontSize: 24.0, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 5.0, 0, 15.0),
                          child: Text(
                            snapshot.data[
                                'phoneNumber'], //fetching phonenumber from users collection
                            style: GoogleFonts.notoSans(
                                fontSize: 24.0, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 5.0, 0, 15.0),
                          child: Text(
                            snapshot.data[
                                'address'], //fetching address from users collection
                            style: GoogleFonts.notoSans(
                                fontSize: 24.0, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(70.0, 15.0, 0, 15.0),
                          child: Text(
                            snapshot.data[
                                'email'], //fetching email from users collection
                            style: GoogleFonts.notoSans(
                                fontSize: 24.0, color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
          }
          ;
        },
      ),
    );
  }
}
