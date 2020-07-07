import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style_it_up/home.dart';

import 'details.dart';

class HairCare extends StatefulWidget {
  String categoryId;
  HairCare({this.categoryId});
  @override
  _HairCareState createState() => _HairCareState();
}

class _HairCareState extends State<HairCare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerHome()),
              );
            },
            child: Icon(Icons.chevron_left)),
        centerTitle: true,
        title: Text("Hair Care"),
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
                .where("userType", isEqualTo: "organization")
                .snapshots(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        document['fullName'],
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
                                        "Address" +
                                            ":" +
                                            " " +
                                            document['address'],
                                        style: GoogleFonts.notoSans(
                                            fontSize: 14.0,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, right: 8, bottom: 4),
                                    child: Container(
                                      height: 50,
                                      child: RaisedButton(
                                        onPressed: () {
                                          print(document.documentID);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Details(
                                                      categoryId:
                                                          widget.categoryId,
                                                      documentid:
                                                          document.documentID,
                                                      collectionName: 'details',
                                                      comments:
                                                          document['comments'],
                                                      orgEmail:
                                                          document["email"],
                                                    )),
                                          );
                                        },
                                        child: Text(
                                          "View Details",
                                          style: GoogleFonts.notoSans(
                                              fontSize: 18.0,
                                              color: Colors.black87),
                                        ),
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, right: 8, bottom: 8),
                                    child: Container(
                                      height: 50,
                                      child: RaisedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    saloonLocation(
                                                        email:
                                                            document["email"],
                                                        fullName: document[
                                                            "fullName"])),
                                          );
                                        },
                                        child: Text(
                                          "Show in Map",
                                          style: GoogleFonts.notoSans(
                                              fontSize: 18.0,
                                              color: Colors.black87),
                                        ),
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            },
          )),
    );
  }
}

class saloonLocation extends StatefulWidget {
  String email;
  String fullName;
  saloonLocation({this.email, this.fullName});
  @override
  _saloonLocationState createState() => _saloonLocationState();
}

class _saloonLocationState extends State<saloonLocation> {
  GoogleMapController _controller;
  String searchAddr;
  List<Marker> Markers = <Marker>[];
  double longitude;
  double latitude;
  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  void initState() {
    super.initState();
    getLocation();
  }

  Future<LatLng> getLocation() async {
    var docRef = Firestore.instance.collection("users").document(widget.email);
    docRef.get().then((doc) {
      setState(() {
        longitude = doc.data['location'].longitude;
        latitude = doc.data['location'].latitude;
        print(longitude);
        Markers.add(Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId("1"),
            draggable: true,
            infoWindow: InfoWindow(title: widget.fullName),
            position: LatLng(latitude, longitude)));
      });
    });
  }

  searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15.0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            (latitude == null && longitude == null)
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(latitude, longitude), zoom: 17.0),
                      markers: Set.from(Markers),
                      myLocationButtonEnabled: true,
                      rotateGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: mapCreated,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      mapType: MapType.normal,
                      onTap: (position) {},
                    ),
                  ),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Search Place",
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: searchAndNavigate,
                        iconSize: 30.0,
                      )),
                  onChanged: (val) {
                    setState(() {
                      searchAddr = val;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
