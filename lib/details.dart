import 'package:flutter/material.dart';
import 'package:style_it_up/haircare.dart';

import 'comments.dart';

class Details extends StatefulWidget {
  String documentid;
  String collectionName;
  List comments;
  Details({this.documentid, this.collectionName, this.comments});
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
        title: Text(widget.collectionName),
        leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HairCare()),
              );
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
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Material(
                  color: Colors.yellow,
                  elevation: 20.0,
                  borderRadius: BorderRadius.circular(12.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Hair Straightening",
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 8, bottom: 1),
                            child: Container(
                              height: 20,
                              child: Text(
                                "Price",
                                style: TextStyle(fontSize: 9.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4, right: 8, bottom: 8),
                            child: Container(
                              height: 30,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/myBooking');
                                },
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                      fontSize: 9.0, color: Colors.white),
                                ),
                                color: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
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
          },
        ),
      ),
    );
  }
}
