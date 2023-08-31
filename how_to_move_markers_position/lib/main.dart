import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  Set<Polyline> Polylines = {};
  Set<Circle> circle = {};

  LatLng location1 = LatLng(0.0, 0.0);
  LatLng location2 = LatLng(0.0, 0.0);
  LatLng location_move_marker =
      LatLng(0.0, 0.0); //marker move to this location, selected latest location
  bool isLongPressToGetLatLngFromMap = false;
  //list for polyline location latlng store, to show all the marker movement point by polyline
  List<LatLng> points = [];
  // by this flag true, remove previous polyline data
  bool isMarkerBackToInitialPosition = false;
  Location location = Location();
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    //this permission part is taken from location package (readme)
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      LocationData locationData = await location.getLocation();
      location1 = LatLng(locationData.latitude!, locationData.longitude!);
      location2 = LatLng(locationData.latitude!, locationData.longitude!);
      location_move_marker =
          LatLng(locationData.latitude!, locationData.longitude!);

      addMarkers();
      points.add(
          location2); //initial first location or starting point of polyline
      // camera focus on initial location
      mapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!)));
      print("Location 1: $location1");
      print("Location 2: $location2");
      setState(() {});
    } catch (error) {
      print("Error getting location: $error");
    }
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

//add circle to the first location
    circle.add(Circle(
      circleId: CircleId('circle1'),
      center: location1,
      radius: 100,
      fillColor: Colors.blue.withOpacity(0.2),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    ));
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
    //add plyline
    Polylines.add(Polyline(
      polylineId: PolylineId('polyline1'),
      color: Colors.blue,
      width: 4,
      /* points: [
        location2,
        location_move_marker,
      ], */
      points: points,
    ));

    //add circle to the every move point of marker
    for (int i = 0; i < points.length; i++) {
      circle.add(Circle(
        circleId: CircleId('${points.length}'),
        center: points[i],
        radius: 100,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ));
    }
    // camera/focus move according to latlng with latest location where move to marker
    mapController!.animateCamera(CameraUpdate.newLatLng(location_move_marker));
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

    //camera focus according to latlng also back with marker
    mapController!.animateCamera(CameraUpdate.newLatLng(location2));
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
          /* marker move to user selected locatoin (LongPress on map to get location where want to move" */
          isLongPressToGetLatLngFromMap = true;
          location_move_marker = latLng;
          print("get map latlng by LongPress : $latLng");

          if (mounted) {
            setState(() {});
          }
        },
        markers: markers,
        polylines: Polylines,
        mapType: MapType.normal,
        circles: circle,
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
              //when marker back then remove previous latlng data except initial or starting latlng which is location2 or markar initila position positoin, unless if user again move then again draw polyline with previous polyline
              if (isMarkerBackToInitialPosition == true && points.length > 1) {
                points.removeRange(1, points.length);
                isMarkerBackToInitialPosition =
                    false; //after operation make it false again, unless it will remaining true
                
                //remove all circle except first that means circle of first locaton
                 CircleId firstCircleId = circle.first.circleId;
                 circle.removeWhere((circles) => circles.circleId != firstCircleId);
                
                setState(() {});
              }
              /* when move alwasys take destination latlang for polyline last location,
              when move button click it will always take latest latlang value 
              because in map user taken Longpress latlng value is also updated in same variable (location_move_marker) */
              points.add(location_move_marker);
              moveLocation2();
            },
          ),
          //back to previous positon
          FloatingActionButton(
            child: Text("Back"),
            onPressed: () {
              points.add(location2);
              backToPreviousLocation();
              isMarkerBackToInitialPosition = true;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
