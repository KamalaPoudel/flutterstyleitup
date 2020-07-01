import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAppointment extends StatefulWidget {
  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  String userEmail;

  @override
  void initState() {
    userData();
    super.initState();
  }

  Future<String> userData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String email = user.email;
    this.setState(() {
      userEmail = email;
    });

    return email;
  }

  DateTime _currentdate = new DateTime.now();
  Future<Null> _selectdate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: _currentdate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (_seldate != null) {
      setState(() {
        _currentdate = _seldate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formattedate = new DateFormat.yMMMd().format(_currentdate);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("My Appointment"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('CustomerBooking')
                .where("userEmail", isEqualTo: userEmail)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              if (snapshot.data.documents.length <= 0)
                return Center(
                    child: Text("You don't have any upcoming appointment"));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      Timestamp bookingDate = document.data["date"];
                      String formattedBookingDate =
                          DateFormat('MMM dd,yyyy | hh:mm')
                              .format(bookingDate.toDate());
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
                                    formattedBookingDate,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 12.0, 8.0, 8.0),
                                child: Container(
                                  width: 120,
                                  height: 45,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      await _selectdate(context);
                                      await Firestore.instance
                                          .collection('CustomerBooking')
                                          .document(document.documentID)
                                          .updateData({'date': _currentdate});
                                    },
                                    child: Text("Change Date"),
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 12.0, 8.0, 8.0),
                                child: Container(
                                  width: 130,
                                  height: 45,
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
                                              title: Text("Appointment Detail"),
                                              content: Text(
                                                  "You have deleted an appointment"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("OKAY"),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text("Delete Booking"),
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
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
