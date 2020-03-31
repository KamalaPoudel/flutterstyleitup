import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerBooking extends StatefulWidget {
  @override
  _CustomerBookingState createState() => _CustomerBookingState();
}

class _CustomerBookingState extends State<CustomerBooking> {
  //CalendarController _controller;

  TextEditingController yourFullName = TextEditingController();
  TextEditingController location1 = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = CalendarController();
  }

  Future<String> createCustomerBookingDb() async {
    Firestore.instance
        .collection('CustomerBooking')
        .document(contactNumber.text)
        .setData({
      'yourFullName': yourFullName.text,
      'location': location1.text,
      'contactNumber': contactNumber.text,
      'date': _currentdate,
    });
    return contactNumber.text;
  }

  DateTime _currentdate = new DateTime.now();
  Future<Null> _selectdate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: _currentdate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2021),
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
          title: Text("Make Booking"),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(27.0, 45.0, 10.0, 45.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Your Full Name",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width / 4) -
                                95,
                            child: TextField(
                              controller: yourFullName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Location",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width / 4) -
                                95,
                            child: TextField(
                              controller: location1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Contact Number",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width / 4) -
                                95,
                            child: TextField(
                              controller: contactNumber,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Choose your date",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text('Date: $_formattedate'),
                              IconButton(
                                onPressed: () {
                                  _selectdate(context);
                                },
                                icon: Icon(Icons.calendar_today),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      RaisedButton(
                        onPressed: (createCustomerBookingDb),
                        child: Text(
                          "Book",
                          style: TextStyle(color: Colors.black87),
                        ),
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ]))));
  }
}
