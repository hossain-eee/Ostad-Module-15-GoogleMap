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

  LatLng initialLocation = LatLng(27.6602292, 85.308027);
  LatLng movingLocation = LatLng(27.6602292, 85.308027);

  // Number of steps for moving marker
  int numSteps = 50;
  int delayMilliseconds = 50;
  int currentStep = 0;
  double? stepLat;
  double? stepLng;
  List<double> currentPosition = [];

  @override
  void initState() {
    currentPosition = [initialLocation.latitude, initialLocation.longitude];
    addMarkers();
    super.initState();
  }

  addMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('initialMarker'),
        position: initialLocation,
        infoWindow: InfoWindow(title: "Marker 1",snippet: '${initialLocation.latitude}, ${initialLocation.longitude},'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId('movingMarker'),
        position: movingLocation,
        infoWindow: InfoWindow(title: "Marker 2",snippet: '${movingLocation.latitude}, ${movingLocation.longitude},'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setState(() {});
  }

  moveMarkerToLocation(LatLng targetLocation) {
    movingLocation = targetLocation;
/* This calculates how much the marker's latitude (up and down on the map) 
should change in each step to reach the target location. 
It takes the difference between the target latitude and the current latitude, 
then divides it by the total number of steps. */
    stepLat = (movingLocation.latitude - currentPosition[0]) / numSteps; // to understand, let 0.5
    stepLng = (movingLocation.longitude - currentPosition[1]) / numSteps; //to understand, let 0.3
    currentStep = 0;//indicate,marker is just starting to move.
    moveMarker();
  }

  moveMarker() {
    /* The current latitude of the marker is updated by adding the calculated latitude step. */
    currentPosition[0] += stepLat!; // let 24.5968 + 0.5,
    currentPosition[1] += stepLng!; // // let 89.5968 + 0.3

    /* A new LatLng object is created using the updated latitude and longitude. */
    var newPosition = LatLng(currentPosition[0], currentPosition[1]);

  /* The existing moving marker is removed from the markers set. */
    markers.removeWhere((marker) => marker.markerId.value == 'movingMarker');
    /* A new marker is added to the markers set with the updated position. This creates the effect of the marker moving. */
    markers.add(
      Marker(
        markerId: MarkerId('movingMarker'),
        position: newPosition,
         infoWindow: InfoWindow(title: "Marker 2 new",snippet: '${newPosition.latitude}, ${newPosition.longitude},'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setState(() {});

    if (currentStep != numSteps) {
      //we want 5o step to complete the move, so in previous we devided, start and target lat and lng by 50(numSteps) to make small number and add that to the currentPosition, so now we are ready to go 50 step
      currentStep++;
      Future.delayed(Duration(milliseconds: delayMilliseconds), () {
        /* A small delay is added to make the marker move smoothly. 
        The moveMarker() function is called again after the delay, 
        repeating the process until the marker reaches the target location. */
        moveMarker();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Move Marker to Desired Location"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14.0,
        ),
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        onLongPress: (LatLng latLng) {
          moveMarkerToLocation(latLng);
        },
      ),
    );
  }
}
