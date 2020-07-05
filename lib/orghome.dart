import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:style_it_up/gallery.dart';
import 'package:style_it_up/orginfouploadpage.dart';
import 'package:style_it_up/placePicker.dart';
import 'package:style_it_up/seeappointments.dart';

class OrgHome extends StatefulWidget {
  @override
  _OrgHomeState createState() => _OrgHomeState();
}

class _OrgHomeState extends State<OrgHome> {
  String userEmail;
  GeoPoint location;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userEmail = user.email;
        print(userEmail);
      });
      getData();
    });
    super.initState();
  }

  void getData() async {
    await Firestore.instance
        .collection('users')
        .document(userEmail)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        location = ds.data['location'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Organization Home"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed('/Welcomepage');
            }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green, Colors.blue])),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Gallery()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 20.0, top: 20.0, right: 5.0, bottom: 20.0),
                      height: 80,
                      width: MediaQuery.of(context).size.width / 2.2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70),
                      child: Text('Gallery'),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeeAppointments()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 5.0, top: 20.0, right: 20.0, bottom: 20.0),
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70),
                      child: Text('See Appointments'),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 5.0),
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
                        padding: const EdgeInsets.all(20.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OrgUploadInfo(
                                        location: location,
                                        categoryId: snapshot.data
                                            .documents[index]["categoryId"],
                                      )));
                            },
                            child: Container(
                              // height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white70,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(snapshot
                                        .data.documents[index]['image'])),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                snapshot.data.documents[index]["categoryName"],
                                style: GoogleFonts.notoSans(
                                    fontSize: 30.0, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlacePicker(
                    userEmail: userEmail,
                  )));
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          height: 60.0,
          width: 60.0,
          child: Icon(
            Icons.location_on,
            size: 30,
          ),
        ),
      ),
    );
  }
}
