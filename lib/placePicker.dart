import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style_it_up/orginfouploadpage.dart';

class PlacePicker extends StatefulWidget {
  String categoryId;
  PlacePicker({@required this.categoryId});
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
            onPressed: () {
              if (Markers.length < 1) {
                print("No Markers added");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrgUploadInfo(
                              locationCoord: LatLng(
                                  Markers.first.position.latitude,
                                  Markers.first.position.longitude),
                            )));
                print(Markers.first.position);
              }
            },
          ),
        ),
      ),
    );
  }
}
