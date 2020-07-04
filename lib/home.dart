import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/appointment.dart';
import 'package:style_it_up/customerGallery.dart';
import 'package:style_it_up/haircare.dart';
import 'package:style_it_up/profile.dart';

class CustomerHome extends StatefulWidget {
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Customer Homepage"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.deepOrange, Colors.orangeAccent])),
              child: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          borderRadius:
                              BorderRadius.all(Radius.circular(110.0)),
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.asset(
                              "lib/assets/icon.png",
                              width: 80,
                              height: 90,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'STYLEitUP',
                            style: GoogleFonts.notoSans(
                                color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              height: 70,
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  title: Text(
                    'My Profile',
                    style: GoogleFonts.notoSans(
                        fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => myProfile()));
                  },
                ),
              ),
            ),
            Container(
              height: 70,
              child: Align(
                child: ListTile(
                  title: Text(
                    'My Appointment',
                    style: GoogleFonts.notoSans(
                        fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.calendar_today),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAppointment()));
                  },
                ),
              ),
            ),
            Container(
              height: 70,
              child: Align(
                child: ListTile(
                  title: Text(
                    'Gallery',
                    style: GoogleFonts.notoSans(
                        fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.camera),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerGallery()));
                  },
                ),
              ),
            ),
            Container(
              height: 70,
              child: Align(
                child: ListTile(
                  title: Text(
                    'Log Out',
                    style: GoogleFonts.notoSans(
                        fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(Icons.arrow_back),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamed('/Welcomepage');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red, Colors.blue[300]])),
        child: StreamBuilder<QuerySnapshot>(
            stream:
                Firestore.instance.collection('ServiceCategory').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return Text("loading");
              }
              return GridView.builder(
                primary: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HairCare(
                                categoryId: snapshot.data.documents[index]
                                    ["categoryId"],
                              )));
                    },
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white70,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                snapshot.data.documents[index]['image'])),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        snapshot.data.documents[index]["categoryName"],
                        style: GoogleFonts.notoSans(
                            fontSize: 30.0, color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
