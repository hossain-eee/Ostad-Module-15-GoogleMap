import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/* How to Move Camera to any Position in Google Maps in Flutter? */
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // on below line we are initializing our controller for google maps.
  final Completer<GoogleMapController> _controller = Completer();
  // on below line we are specifying our camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(37.42796133580664, -122.885749655962),
    zoom: 14.4746,
  );
  // on below line we have created the set of markers and polyline to set on map
  // final Set<Marker> _markers = {};
  final List<Marker> _markers = [];
  final Set<Polyline> _polyline = {};
  final List<LatLng> _latlng = const [
    LatLng(20.42796133580664, 75.885749655962),
    LatLng(25.42796133580664, 80.885749655962),
    LatLng(23.42796133580664, 77.885749655962),
    LatLng(22.42796133580664, 78.885749655962),
    LatLng(21.42796133580664, 79.885749655962),
    LatLng(20.42796133580664, 73.885749655962),
  ];
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(25.42796133580664, 80.885749655962),
        infoWindow: InfoWindow(
          title: 'Location 1',
        )),
    Marker(
        markerId: MarkerId('3'),
        position: LatLng(23.42796133580664, 77.885749655962),
        infoWindow: InfoWindow(
          title: 'Location 2',
        )),
    Marker(
        markerId: MarkerId('4'),
        position: LatLng(22.42796133580664, 78.885749655962),
        infoWindow: InfoWindow(
          title: 'Location 3',
        )),
    Marker(
        markerId: MarkerId('5'),
        position: LatLng(21.42796133580664, 79.885749655962),
        infoWindow: InfoWindow(
          title: 'Location 4',
        )),
    Marker(
        markerId: MarkerId('6'),
        position: LatLng(20.42796133580664, 73.885749655962),
        infoWindow: InfoWindow(
          title: 'Location 5',
        )),
  ];

  @override
  void initState() {
    // TODO: implement initState
/*     for (int i = 0; i < _latlng.length; i++) {
      _markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            position: _latlng[i],
            //for differnet title have to take multiple marker insted of the loop
            infoWindow: InfoWindow(title: 'Marker')),
      );
      setState(() {});
    } */
    //add marker to all
    _markers.addAll(_list);
    _polyline.add(Polyline(
      polylineId: PolylineId('1'),
      color: Colors.blue,
      points: _latlng,
      width: 4,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
        initialCameraPosition: _kGoogle,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        // markers: _markers, // when use set varibale
        markers:
            Set<Marker>.of(_markers), //list variable put in Set{}, type casting
        polylines: _polyline,
      ),
      // on below line we are creating floating action
      // button for changing camera position
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: FloatingActionButton(
          onPressed: () async {
            GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(
                // on below line we have given positions of Location 5
                const CameraPosition(
              target: LatLng(20.42796133580664, 73.885749655962),
              zoom: 14,
            )));
            setState(() {});
          },
          child: Icon(Icons.location_disabled_outlined),
        ),
      ),
    );
  }
}
