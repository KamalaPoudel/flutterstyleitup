import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/appointment.dart';
import 'package:style_it_up/customerGallery.dart';
import 'package:style_it_up/haircare.dart';
import 'package:style_it_up/profile.dart';
import 'package:style_it_up/welcomepage.dart';

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
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            "Customer Homepage",
            style: GoogleFonts.notoSans(color: Colors.white, fontSize: 24.0),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 250.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                  Colors.deepOrange,
                  Colors.orangeAccent
                ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Image.asset(
                            "lib/assets/icon.png",
                            width: 100,
                            height: 120,
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
                ),
              ),
            ),
            Container(
              height: 100,
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
              height: 100,
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
              height: 100,
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
              height: 100,
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
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[300], Colors.red])),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: .5),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green[300]),
                  alignment: Alignment.center,
                  height: 150,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "We Have Four Different Services Available." +
                          "\n" +
                          "        " +
                          "Please Choose as Per Your Wish",
                      style: GoogleFonts.notoSans(
                          fontSize: 18.0, color: Colors.white),
                    ),
                  )),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('ServiceCategory')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return Text("loading");
                    }
                    return GridView.builder(
                      primary: false,
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
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
          ],
        ),
      ),
    );
  }
}
