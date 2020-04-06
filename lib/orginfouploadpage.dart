import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrgUploadInfo extends StatefulWidget {
  @override
  _OrgUploadInfoState createState() => _OrgUploadInfoState();
}

class _OrgUploadInfoState extends State<OrgUploadInfo> {
  TextEditingController organizationName = TextEditingController();
  TextEditingController serviceName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController estimatedTime = TextEditingController();
  TextEditingController location = TextEditingController();

  Future<String> createOrganizationDb() async {
    Firestore.instance
        .collection('Organizationinfo')
        .document(organizationName.text)
        .setData({
      'organizationName': organizationName.text,
      'serviceName': serviceName.text,
      'Price': price.text,
      'estimatedTime': estimatedTime.text,
      'location': location.text
    });
  }

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
                Firestore.instance
                    .collection('Organizationinfo')
                    .document("Ansa")
                    .updateData({
                  "services": FieldValue.arrayUnion([
                    {
                      "serviceName": serviceName.text,
                      "price": price.text,
                      "estimatedTime": estimatedTime.text
                    }
                  ])
                });
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
                  .collection('Organizationinfo')
                  .document("Ansa")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return ListView.builder(
                      itemCount: snapshot.data.data["services"].length,
                      itemBuilder: (BuildContext context, index) {
                        var service = snapshot.data.data["services"][index];
                        return ListTile(
                          title: Text(service["serviceName"]),
                          trailing: Text(service["price"]),
                        );
                      },
                    );
                }
              },
            )));
  }
}
