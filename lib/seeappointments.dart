import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeeAppointments extends StatefulWidget {
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
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

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
                        child: new FittedBox(
                          child: Material(
                            color: Colors.white,
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
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      document['location'],
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      document['contactNumber'],
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
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
                                      padding: const EdgeInsets.only(
                                          top: 12, right: 8, bottom: 8),
                                      child: Container(
                                        width: 112,
                                        height: 25,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            await Firestore.instance
                                                .collection('CustomerBooking')
                                                .document(
                                                    document['serviceDoc'])
                                                .delete();
                                          },
                                          child: Text("Delete"),
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
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ));
  }
}
