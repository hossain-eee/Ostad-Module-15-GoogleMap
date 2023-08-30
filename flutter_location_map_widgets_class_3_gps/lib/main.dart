import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const GPSLocationApp());
}

class GPSLocationApp extends StatelessWidget {
  const GPSLocationApp({super.key});

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
  LocationData? myCurrentLocation;
  StreamSubscription? _locationSubscription;


  @override
  void initState() {
    initialize();
    super.initState();
  }

  //set data track condition
  void initialize() async{
    //get the permission
    await Location.instance.requestPermission().then((requestPermission) {
      print("Request to the user permission: $requestPermission");
    });
    //check the permission is available or not (status)
    await Location.instance.hasPermission().then((permissionStatus) {
      print("Is user give permission : $permissionStatus");
    });
    print("initialize-start");
    // instance is the singleton (single object for all) for location class, so if we apply it inside initState() then it will apply for all the method where apply this Location.instance
    Location.instance.changeSettings(
      distanceFilter: 1, //meter
      // accuracy:LocationAccuracy.navigation, // walking track
      accuracy: LocationAccuracy.high,
      interval: 1000, // 3 second
    );
    print("initialize-end");
  }

  //get current location
  void getMyLocation() async {
    //fetch the current location
    myCurrentLocation = await Location.instance.getLocation();
    print("My current Location is : $myCurrentLocation");
    if (mounted) {
      setState(() {});
    }
  }

  //Listen to my location that mean track user activity
  void listenToMyLocation() {
    _locationSubscription =
        Location.instance.onLocationChanged.listen((location) {
      myCurrentLocation =
          location; //myCurrentLocation got latest data from listen
      print('listening to location $location');
      if (mounted) {
        setState(() {});
      }
    });
    // initialize();
  }

  //stop listening
  void stopToListenLocation() {
    //to cancel the stream first need to use common instance for both listening and stop listening, that is why this instance got data from listen
    _locationSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("My Location"),
            Text('Lat-${myCurrentLocation?.latitude ?? ''}  '
                'Lon-${myCurrentLocation?.longitude ?? ''}'),
          ],
        ),
      ),
      //button for get location
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              //get latest location by listen user activity
              listenToMyLocation();
            },
            // child: Icon(Icons.location_on),
            child: Text('listen'),
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            onPressed: () {
              stopToListenLocation();
            },
            // child: const Icon(Icons.stop_circle_outlined),
            child: Text('stop'),
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            onPressed: () {
              //get current location
              getMyLocation();
            },
            // child: Icon(Icons.my_location),
            child: const FittedBox(
              child: Text('Location'),
            ),
          ),
        ],
      ),
    );
  }

//when create stream objecct, its best practice to cancel/close it
  @override
  void dispose() {
    // TODO: implement dispose
    _locationSubscription?.cancel();
    super.dispose();
  }
}
