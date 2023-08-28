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
  void getMyLocation() async{
     myCurrentLocation = await Location.instance.getLocation();
    print("My current Location is : $myCurrentLocation");
    if(mounted){
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPS Location"),),
      body: Column(
        children: [
          Text("My Location"),
          Text('${myCurrentLocation?.latitude ?? ''}'
              '${myCurrentLocation?.longitude ?? ''}'),
        ],
      ),
      //button for get location
      floatingActionButton: FloatingActionButton(onPressed: (){
        //get current location
        getMyLocation();
      }, child: Icon(Icons.my_location),),
    );
  }
}

