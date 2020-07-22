import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style_it_up/orginfouploadpage.dart';

class PlacePicker extends StatefulWidget {
  //placepicker class for organization to select their location and set it in map
  final String userEmail;
  PlacePicker({this.userEmail});
  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  GoogleMapController _controller;

  Set<Marker> Markers;

  PageController _pageController;
  double longitude;
  double latitude;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  int prevPage;
  @override
  void initState() {
    super.initState();
    getLocation();
    Markers = Set.from([]);
  }

  void getLocation() async {
    //selecting location in map
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (mounted)
        setState(() {
          longitude = position.longitude;
          latitude = position.latitude;
        });
    });
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Lot Location"),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            (latitude == null && longitude == null)
                ? Container(
                    child: Text("No Data"),
                  )
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
                      onTap: (position) {
                        Marker mk1 =
                            Marker(markerId: MarkerId('1'), position: position);
                        setState(() {
                          Markers.add(mk1);
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.location_on),
            label: Text("Set Location"),
            onPressed: () async {
              if (Markers.length < 1) {
                print("No Markers added");
              } else {
                print(Markers.first.position);

                await Firestore
                    .instance //storing the organization location in users collection
                    .collection("users")
                    .document(widget.userEmail)
                    .updateData({
                  "location": GeoPoint(Markers.first.position.latitude,
                      Markers.first.position.longitude)
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }
}
