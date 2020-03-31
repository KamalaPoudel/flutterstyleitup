import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:style_it_up/orghome.dart';

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
    _showAlert();
  }

  clearTextInput() {
    serviceName.clear();
    price.clear();
    estimatedTime.clear();
  }

  void _showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("invalid details"),
            content: Text("Your email or password is wrong"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Information"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 45.0, 10.0, 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      "Organization Name",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width / 4) -
                        110,
                    child: TextField(
                      controller: organizationName,
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
                      "Service Name",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width / 4) -
                        110,
                    child: TextField(
                      controller: serviceName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width / 4) -
                        230,
                    child: FloatingActionButton(
                      onPressed: clearTextInput,
                      child: Icon(Icons.add),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Row(
              //   children: <Widget>[
              //     Container(
              //       height: 30,
              //       width: MediaQuery.of(context).size.width -
              //           (MediaQuery.of(context).size.width / 4) -
              //           50,
              //       child: FloatingActionButton(
              //         onPressed: () {
              //           // Add your onPressed code here!
              //         },
              //         child: Icon(Icons.navigation),
              //         backgroundColor: Colors.green,
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      "Price",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width / 4) -
                        110,
                    child: TextField(
                      controller: price,
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
                      "Estimated Time",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width / 4) -
                        110,
                    child: TextField(
                      controller: estimatedTime,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                        110,
                    child: TextField(
                      controller: location,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () => createOrganizationDb,
                child: Text(
                  "Upload Information",
                  style: TextStyle(color: Colors.black87),
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
