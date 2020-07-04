import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class OrgUploadInfo extends StatefulWidget {
  final LatLng locationCoord;

  String categoryId;
  OrgUploadInfo({this.categoryId, this.locationCoord});
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
                    .document(serviceId)
                    .setData({"serviceDoc": serviceReference});

                Firestore.instance
                    .collection('services')
                    .document(serviceId)
                    .setData({
                  "Location": GeoPoint(widget.locationCoord.latitude,
                      widget.locationCoord.longitude),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(userEmail)
              .collection("services")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Error: ');

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, index) {
                    var service = snapshot.data.documents[index];
                    return FutureBuilder(
                        future: referenceData(service['serviceDoc']),
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
                                ? ListTile(
                                    title: Text(
                                      serviceSnapshot.data["serviceName"],
                                      style: GoogleFonts.notoSans(
                                          fontSize: 20.0, color: Colors.black),
                                    ),
                                    trailing: Text(
                                      serviceSnapshot.data["price"],
                                      style: GoogleFonts.notoSans(
                                          fontSize: 20.0, color: Colors.black),
                                    ),
                                  )
                                : Container();
                          }
                          return Text("Nodata");
                        });
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
