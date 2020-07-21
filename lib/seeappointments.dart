import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SeeAppointments extends StatefulWidget {
  String yourFullName;
  String location;
  String contactNumber;
  String date;
  String time;

  @override
  _SeeAppointmentsState createState() => _SeeAppointmentsState();
}

class _SeeAppointmentsState extends State<SeeAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(" Appointments"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('CustomerBooking').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: Text("You don't have any upcoming appointment"));
            if (snapshot.data.documents.length <= 0)
              return Center(
                  child: Text("You don't have any upcoming appointment"));
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Material(
                          color: Colors.green[200],
                          elevation: 20.0,
                          borderRadius: BorderRadius.circular(24.0),
                          shadowColor: Color(0x802196F3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    document['yourFullName'],
                                    style: GoogleFonts.notoSans(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    document['location'],
                                    style: GoogleFonts.notoSans(
                                        fontSize: 18.0, color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    document['contactNumber'],
                                    style: GoogleFonts.notoSans(
                                        fontSize: 18.0, color: Colors.black),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 8.0),
                                    child: Text(
                                      "Appointment Date:",
                                      style: GoogleFonts.notoSans(
                                          fontSize: 15.0, color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            DateFormat('MMMM dd, y').format(
                                                DateTime.parse(document['date']
                                                    .toDate()
                                                    .toString())),
                                            style: GoogleFonts.notoSans(
                                                fontSize: 18.0,
                                                color: Colors.black),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "," + document.data["time"],
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8, top: 8, right: 8, bottom: 4),
                                  //   child: Container(
                                  //     height: 25,
                                  //     child: RaisedButton(
                                  //       onPressed: () {
                                  //         Navigator.of(context)
                                  //             .pushNamed('/orghome');
                                  //       },
                                  //       child: Text("Change Date"),
                                  //       color: Colors.green,
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(15.0)),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        240.0, 12.0, 8.0, 8.0),
                                    child: Container(
                                      width: 100,
                                      height: 25,
                                      child: RaisedButton(
                                        onPressed: () async {
                                          await Firestore.instance
                                              .collection('CustomerBooking')
                                              .document(document.documentID)
                                              .delete();
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Appointment Detail"),
                                                  content: Text(
                                                    "You have deleted customer's booking",
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: 20.0,
                                                        color: Colors.black),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("OKAY"),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Text(
                                          "Delete",
                                          style: GoogleFonts.notoSans(
                                              fontSize: 14.0,
                                              color: Colors.black),
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
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ));
  }
}
