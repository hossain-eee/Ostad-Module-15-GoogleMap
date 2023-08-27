import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//api key: AIzaSyB7w8JhkAHJJkhweXYfp7w_28JRYI6o8zg
void main() {
  runApp(const MyApp());
}

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
  late final GoogleMapController _googleMapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Screen"),
      ),
      body:   GoogleMap(
        initialCameraPosition: CameraPosition(
          //most use able is zoom, we use default value for bearing and tilt
          zoom: 15,//standard value 15-17, 17 for location oriented suppose office location
          bearing: 30, //map angel from north to clockwise direction
          tilt: 10,//camera angel
          target: LatLng(24.462366675440375, 89.70871717947436), //Sirajganj Govt. college lat and lang
        ),
        myLocationEnabled: true, //default is false
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,//by default true; it give facility to zoom in or zoom out
        zoomGesturesEnabled: true, // by default true; it give facility to click on a position and zoom it
        trafficEnabled: false,// by default false; to see people or vehicle in road that road is free or has jam
        onMapCreated: (GoogleMapController  controller){
          //onMapCreated return controller, we can control the map by this controller, like zoom,move map etc
          
          print("On Map Created");
          _googleMapController=controller; //

        },
        compassEnabled: true, // by default true; compass inside a circular radius


      ),
    );
  }
}