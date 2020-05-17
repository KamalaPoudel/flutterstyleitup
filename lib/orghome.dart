import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_it_up/gallery.dart';
import 'package:style_it_up/orginfouploadpage.dart';
import 'package:style_it_up/seeappointments.dart';

class OrgHome extends StatefulWidget {
  @override
  _OrgHomeState createState() => _OrgHomeState();
}

class _OrgHomeState extends State<OrgHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Organization Home"),
        leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed('/Welcomepage');
            }),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green, Colors.blue])),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Gallery()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 0),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white70),
                        child: Text('Gallery'),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeeAppointments()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                          width: MediaQuery.of(context).size.width / 2.4,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white70),
                          child: Text('See Appointments'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('ServiceCategory')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return new Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return Text("loading");
                      }
                      return GridView.builder(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return RaisedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrgUploadInfo(
                                        categoryId: snapshot.data
                                            .documents[index]["categoryId"],
                                      )));
                            },
                            child: Text(
                              snapshot.data.documents[index]["categoryName"],
                            ),
                            color: Colors.white70,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          );
                        },
                      );
                    }),
              ),
            ],
          )),
    );
  }
}
