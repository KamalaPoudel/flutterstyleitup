import 'package:flutter/material.dart';
//import 'package:table_calendar/table_calendar.dart';

class CustomerBooking extends StatefulWidget {
  @override
  _CustomerBookingState createState() => _CustomerBookingState();
}

class _CustomerBookingState extends State<CustomerBooking> {
  //CalendarController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width / 4) -
                        95,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              //TableCalendar(
              //calendarStyle: CalendarStyle(
              // todayColor: Colors.orange,
              // selectedColor: Theme.of(context).primaryColor),
              //calendarController: _controller,
              // ),
              RaisedButton(
                onPressed: () {},
                child: Text(
                  "Book",
                  style: TextStyle(color: Colors.white70),
                ),
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
