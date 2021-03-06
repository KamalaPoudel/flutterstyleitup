import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/customerbooking.dart';
import 'package:style_it_up/haircare.dart';

import 'comments.dart';

class Details extends StatefulWidget {
  //Details class
  String categoryId; //declaring variable to access category id
  String documentid; //declaring variable to access document id
  String collectionName; // declaring variable to access collection name
  List comments; //declaring variabe to access comment page
  String orgEmail; //declaring variable to access organization email
  Details(
      //parameters in constructor
      {this.documentid,
      this.collectionName,
      this.comments,
      this.categoryId,
      this.orgEmail});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            "Details",
            style: GoogleFonts.notoSans(color: Colors.white, fontSize: 24.0),
          ),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Icon(Icons.chevron_left, size: 30.0),
            )),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: IconButton(
              icon: Icon(Icons.chat_bubble),
              onPressed: () {
                print(widget.collectionName);
                print(widget.documentid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      //setting route to go into the comment page
                      builder: (context) => CommentPage(
                            collectionName: widget.collectionName,
                            documentid: widget.documentid,
                          )),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red[300], Colors.yellow])),
          child: StreamBuilder<QuerySnapshot>(
              //streaming details from database stored in services collection by using reference of categoryId and OrgEmail
              stream: Firestore.instance
                  .collection('services')
                  .where("categoryId", isEqualTo: widget.categoryId)
                  .where("orgEmail", isEqualTo: widget.orgEmail)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          document[
                                              'serviceName'], //fetching service name
                                          style: GoogleFonts.notoSans(
                                              fontSize: 24.0,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          //fetching estimated service time
                                          "Service Time" +
                                              ":" +
                                              " " +
                                              document['estimatedTime'],
                                          style: GoogleFonts.notoSans(
                                              fontSize: 14.0,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Container(
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(left: 15.0),
                                //     child: Text(
                                //       document['estimatedTime'],
                                //       style: GoogleFonts.notoSans(
                                //           fontSize: 24.0,
                                //           color: Colors.black87),
                                //     ),
                                //   ),
                                // ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, right: 8, bottom: 1),
                                      child: Container(
                                        height: 25,
                                        child: Text(
                                          //fetching price per service
                                          "Price:" + " " + document['price'],
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, right: 8, bottom: 8),
                                      child: Container(
                                        height: 40,
                                        child: RaisedButton(
                                          //making route to reach customer booking page
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerBooking(
                                                          serviceId: document[
                                                              'serviceId'],
                                                        )));
                                          },
                                          child: Text(
                                            "Book Now",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white),
                                          ),
                                          color: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              })),
    );
  }
}
