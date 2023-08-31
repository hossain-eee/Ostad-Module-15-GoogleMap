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
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          // Do something when the map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
