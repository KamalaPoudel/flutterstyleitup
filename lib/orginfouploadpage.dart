import 'package:flutter/material.dart';

class OrgUploadInfo extends StatefulWidget {
  @override
  _OrgUploadInfoState createState() => _OrgUploadInfoState();
}

class _OrgUploadInfoState extends State<OrgUploadInfo> {
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
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () {},
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
