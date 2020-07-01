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
                  child: Column(
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset(
                        "icon.png",
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'STYLEitUP',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              )),
            ),
            ListTile(
              title: Text(
                'My Profile',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              leading: Icon(Icons.account_circle),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => myProfile()));
              },
            ),
            ListTile(
              title: Text(
                'My Appointment',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              leading: Icon(Icons.calendar_today),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyAppointment()));
              },
            ),
            ListTile(
              title: Text(
                'Gallery',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerGallery()));
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamed('/Welcomepage');
              },
            ),
          ],
        ),
      ),
      body: Container(
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
                            fontSize: 20.0, color: Colors.white),
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
