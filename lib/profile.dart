import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class myProfile extends StatefulWidget {
  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("My Profile"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').snapshots(),
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
                                  child: Text(
                                    document['fullName'],
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 15.0, 0, 15.0),
                                  child: Text(
                                    document['phoneNumber'],
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 15.0, 0, 15.0),
                                  child: Text(
                                    document['address'],
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 15.0, 0, 15.0),
                                  child: Text(
                                    document['email'],
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                              )
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
