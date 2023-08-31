import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = Set(); // or use {}
  // Set<Marker> markers = {};//

  LatLng location1 = LatLng(27.6602292, 85.308027);
  LatLng location2 = LatLng(27.6599592, 85.3102498);
  LatLng location_move_marker = LatLng(
      27.67831505697596, 85.29788810759783); //marker move to this location
  bool isLongPressToGetLatLngFromMap = false;
  @override
  void initState() {
    addMarkers();
    super.initState();
  }

  addMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('location1'),
        position: location1,
        infoWindow: InfoWindow(title: "Marker 1"),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId('location2'),
        position: location2,
        infoWindow: InfoWindow(title: "Marker 2"),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setState(() {
      // Refresh the map to show markers
    });
  }

//move marker
  moveLocation2() {
    /* Delete marker two which id is location2 and again create it at new position */
    markers.removeWhere((marker) =>
        marker.markerId.value ==
        'location2'); //remove/delete marker which id is location2
    //now add new marker at define postion, this marker will take 2nd marker id becasue we are delete and again creating second marker
    markers.add(
      Marker(
        markerId: MarkerId('location2'),
        // position: LatLng(27.661838, 85.308543),
        position: location_move_marker, // marker create at new location
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setState(() {
      // Refresh the map to show the new location for location 2
    });
  }

  //back marker at previous position
  void backToPreviousLocation() {
    /* Delete marker two which id is location2 and again create it at new position */
    markers.removeWhere((Marker) =>
        Marker.markerId.value ==
        'location2'); //remove/delete marker which id is location2
    //now add new marker at define postion, this marker will take 2nd marker id becasue we are delete and again creating second marker
    markers.add(Marker(
      markerId: MarkerId('location2'),
      position: location2, //marker create at previous location
      infoWindow: const InfoWindow(title: "Marker 2"),
      icon: BitmapDescriptor.defaultMarker,
    ));
    setState(() {
      // Refresh the map to show markers
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Places on the Map"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: location1,
          zoom: 14.0,
        ),
        onTap: (LatLng latLng) {
          print("get map latlng by click : $latLng");
        },
        onLongPress: (LatLng latLng) {
          isLongPressToGetLatLngFromMap = true;
          location_move_marker = latLng;
          print("get map latlng by LongPress : $latLng");
          if(mounted){
            setState(() {
              
            });
          }
        },
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          // Do something when the map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //move to new position
          FloatingActionButton(
            child: Text("Move"),
            onPressed: () {
              moveLocation2();
            },
          ),
          //back to previous positon
          FloatingActionButton(
            child: Text("Back"),
            onPressed: () {
              backToPreviousLocation();
            },
          ),
        ],
      ),
    );
  }
}
