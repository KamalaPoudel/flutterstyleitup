import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/customerbooking.dart';
import 'package:style_it_up/haircare.dart';

import 'comments.dart';

class Details extends StatefulWidget {
  String categoryId;
  String documentid;
  String collectionName;
  List comments;
  String orgEmail;
  Details(
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
  Icon actionIcon = new Icon(Icons.chat_bubble_outline);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Details"),
        leading: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HairCare()));
            },
            child: Icon(Icons.chevron_left)),
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              print(widget.collectionName);
              print(widget.documentid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommentPage(
                          collectionName: widget.collectionName,
                          documentid: widget.documentid,
                        )),
              );
            },
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
                                            const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          document['serviceName'],
                                          style: GoogleFonts.notoSans(
                                              fontSize: 24.0,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Text(
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
