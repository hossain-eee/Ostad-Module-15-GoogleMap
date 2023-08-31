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
  GoogleMapController? mapController;
  Set<Marker> markers = Set();

  LatLng startingLocation = LatLng(27.6602292, 85.308027);
  LatLng movingLocation = LatLng(27.6602292, 85.308027);

  @override
  void initState() {
    addMarkers();
    super.initState();
  }

  addMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('startingMarker'),
        position: startingLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId('movingMarker'),
        position: movingLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setState(() {});
  }

  moveMarker() {
    // Calculate the new position of the moving marker
    double newLatitude = movingLocation.latitude + 0.001;
    double newLongitude = movingLocation.longitude + 0.001;

    movingLocation = LatLng(newLatitude, newLongitude);

    markers.removeWhere((marker) => marker.markerId.value == 'movingMarker');
    markers.add(
      Marker(
        markerId: MarkerId('movingMarker'),
        position: movingLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setState(() {});

    // Repeat the process after a short delay
    Future.delayed(Duration(milliseconds: 200), () {
      moveMarker();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Move Marker on Map"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Move"),
        onPressed: () {
          // Start moving the marker
          moveMarker();
        },
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: startingLocation,
          zoom: 14.0,
        ),
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
