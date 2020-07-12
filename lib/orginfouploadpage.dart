import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class OrgUploadInfo extends StatefulWidget {
  final GeoPoint location;

  String categoryId;
  OrgUploadInfo({this.categoryId, this.location});
  @override
  _OrgUploadInfoState createState() => _OrgUploadInfoState();
}

class _OrgUploadInfoState extends State<OrgUploadInfo> {
  String userEmail;
  @override
  void initState() {
    super.initState();
    userData();
  }

  Future<dynamic> referenceData(DocumentReference documentReference) async {
    DocumentSnapshot reference = await documentReference.get();
    return reference.data;
  }

  Future<String> userData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String email = user.email;
    this.setState(() {
      userEmail = email;
    });

    return email;
  }

  TextEditingController organizationName = TextEditingController();
  TextEditingController serviceName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController estimatedTime = TextEditingController();
  TextEditingController location = TextEditingController();

  clearTextInput() {
    serviceName.clear();
    price.clear();
    estimatedTime.clear();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add a Service"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: serviceName,
                  decoration: InputDecoration(hintText: "Service Name"),
                ),
                TextField(
                  controller: price,
                  decoration: InputDecoration(hintText: "Service Price"),
                ),
                TextField(
                  controller: estimatedTime,
                  decoration: InputDecoration(hintText: "Service Time"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Upload"),
              onPressed: () {
                var uuid = Uuid();
                String serviceId = uuid.v4();
                DocumentReference serviceReference =
                    Firestore.instance.document("services/" + serviceId);
                DocumentReference orgReference =
                    Firestore.instance.document("users/" + userEmail);

                //For organization service sub collection

                Firestore.instance
                    .collection('users')
                    .document(userEmail)
                    .collection("services")
                    .getDocuments()
                    .then((value) {
                  if (value.documents.length > 0) {
                    value.documents.forEach((element) {
                      if (element.documentID == widget.categoryId) {
                        Firestore.instance
                            .collection('users')
                            .document(userEmail)
                            .collection("services")
                            .document(widget.categoryId)
                            .updateData({
                          "serviceDoc":
                              FieldValue.arrayUnion([serviceReference])
                        });
                      } else {
                        Firestore.instance
                            .collection('users')
                            .document(userEmail)
                            .collection("services")
                            .document(widget.categoryId)
                            .setData({
                          "serviceDoc":
                              FieldValue.arrayUnion([serviceReference])
                        });
                      }
                    });
                  } else {
                    Firestore.instance
                        .collection('users')
                        .document(userEmail)
                        .collection("services")
                        .document(widget.categoryId)
                        .setData({
                      "serviceDoc": FieldValue.arrayUnion([serviceReference])
                    });
                  }
                }).catchError((onError) {
                  print(onError);
                });

                // Firestore.instance
                //     .collection('users')
                //     .document(userEmail)
                //     .collection("services")
                //     .document(widget.categoryId)
                //     .get()
                //     .then((value) {
                //   Firestore.instance
                //       .collection('users')
                //       .document(userEmail)
                //       .collection("services")
                //       .document(widget.categoryId)
                //       .updateData({
                //     "serviceDoc": FieldValue.arrayUnion([serviceReference])
                //   });
                // }).catchError((onError) {
                //   Firestore.instance
                //       .collection('users')
                //       .document(userEmail)
                //       .collection("services")
                //       .document(widget.categoryId)
                //       .setData({
                //     "serviceDoc": FieldValue.arrayUnion([serviceReference])
                //   });
                // });

                Firestore.instance
                    .collection('services')
                    .document(serviceId)
                    .setData({
                  "Location": GeoPoint(
                      widget.location.latitude, widget.location.longitude),
                  "categoryId": widget.categoryId,
                  "serviceId": serviceId,
                  "serviceName": serviceName.text,
                  "orgEmail": userEmail,
                  "price": price.text,
                  "estimatedTime": estimatedTime.text,
                  "orgDoc": orgReference
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Upload Information"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () => _showDialog())
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green, Colors.blue])),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(userEmail)
              .collection("services")
              .document(widget.categoryId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                if (snapshot.data.data == null) {
                  return Text("No data");
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data["serviceDoc"].length,
                    itemBuilder: (BuildContext context, index) {
                      var service = snapshot.data["serviceDoc"][index];
                      return FutureBuilder(
                          future: referenceData(service),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> serviceSnapshot) {
                            if (!snapshot.hasData) {
                              return Text("No Data");
                            } else if (serviceSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (serviceSnapshot.connectionState ==
                                ConnectionState.active) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (serviceSnapshot.connectionState ==
                                ConnectionState.done) {
                              return serviceSnapshot.data["categoryId"] ==
                                      widget.categoryId
                                  ? Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: .5),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.white),
                                      margin: EdgeInsets.only(
                                          left: 5.0, top: 10.0, right: 5.0),
                                      child: ListTile(
                                        title: Text(
                                          serviceSnapshot.data["serviceName"],
                                          style: GoogleFonts.notoSans(
                                              fontSize: 20.0,
                                              color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          serviceSnapshot.data["estimatedTime"],
                                          style: GoogleFonts.notoSans(
                                              fontSize: 20.0,
                                              color: Colors.black),
                                        ),
                                        trailing: Text(
                                          serviceSnapshot.data["price"],
                                          style: GoogleFonts.notoSans(
                                              fontSize: 20.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                  : Container();
                            }
                            return Text("Nodata");
                          });
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
