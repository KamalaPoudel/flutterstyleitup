import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        title: Text("Home for customer"),
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
                padding: const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HairCare(
                                categoryId: snapshot.data.documents[index]
                                    ["categoryId"],
                              )));
                    },
                    child: Text(
                      snapshot.data.documents[index]["categoryName"],
                    ),
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  );
                },
              );
            }),
      ),
    );
  }
}
