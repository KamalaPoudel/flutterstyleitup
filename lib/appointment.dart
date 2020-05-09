import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class myAppointment extends StatefulWidget {
  @override
  _myAppointmentState createState() => _myAppointmentState();
}

class _myAppointmentState extends State<myAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("My Appointment"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                Firestore.instance.collection('CustomerBooking').snapshots(),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 15.0, 0, 15.0),
                                  child: Image.asset("icon.png"),
                                ),
                              ),
                              Container(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 15.0, 0, 15.0),
                                    child: Text("Upcoming Appointment Date")),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    DateFormat('MMMM dd, y, h:mm a').format(
                                        DateTime.parse(document['date']
                                            .toDate()
                                            .toString())),
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            }));
  }
}
