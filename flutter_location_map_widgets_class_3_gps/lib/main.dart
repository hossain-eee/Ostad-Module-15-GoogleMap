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

  //get current location
  void getMyLocation() async {
    //get the permission
    await Location.instance.requestPermission().then((requestPermission) {
      print("Request to the user permission: $requestPermission");
    });
    //check the permission is available or not (status)
    await Location.instance.hasPermission().then((permissionStatus) {
      print("Is user give permission : $permissionStatus");
    });
    //fetch the current location
    myCurrentLocation = await Location.instance.getLocation();
    print("My current Location is : $myCurrentLocation");
    if (mounted) {
      setState(() {});
    }
  }

  //Listen to my location that mean track user activity
  void listenToMyLocation() async{
    Location.instance.onLocationChanged.listen((location) {
      myCurrentLocation=location; //myCurrentLocation got latest data from listen
      print('listening to location $location');
      if(mounted){
        setState(() {

        });
      }
    });
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
              listenToMyLocation() ;
            },
            child: Icon(Icons.location_on),
          ),
          SizedBox(width: 20,),
          FloatingActionButton(
            onPressed: () {
              //get current location
              getMyLocation();
            },
            child: Icon(Icons.my_location),
          ),
          SizedBox(width: 20,),
        ],
      ),
    );
  }
}
