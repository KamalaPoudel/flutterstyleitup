import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/home.dart';

import 'details.dart';

class HairCare extends StatefulWidget {
  String categoryId;
  HairCare({this.categoryId});
  @override
  _HairCareState createState() => _HairCareState();
}

class _HairCareState extends State<HairCare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerHome()),
              );
            },
            child: Icon(Icons.chevron_left)),
        centerTitle: true,
        title: Text("Hair Care"),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green, Colors.blue])),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('users')
                .where("userType", isEqualTo: "organization")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    document['fullName'] + " " + ":",
                                    style: GoogleFonts.notoSans(
                                        fontSize: 24.0, color: Colors.black87),
                                  ),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Text(
                                        document['address'],
                                        style: GoogleFonts.notoSans(
                                            fontSize: 14.0,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, right: 8, bottom: 4),
                                    child: Container(
                                      height: 50,
                                      child: RaisedButton(
                                        onPressed: () {
                                          print(document.documentID);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Details(
                                                      categoryId:
                                                          widget.categoryId,
                                                      documentid:
                                                          document.documentID,
                                                      collectionName: 'details',
                                                      comments:
                                                          document['comments'],
                                                      orgEmail:
                                                          document["email"],
                                                    )),
                                          );
                                        },
                                        child: Text(
                                          "View Details",
                                          style: GoogleFonts.notoSans(
                                              fontSize: 18.0,
                                              color: Colors.black87),
                                        ),
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, right: 8, bottom: 8),
                                    child: Container(
                                      height: 50,
                                      child: RaisedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Show in Map",
                                          style: GoogleFonts.notoSans(
                                              fontSize: 18.0,
                                              color: Colors.black87),
                                        ),
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          )),
    );
  }
}
