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
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          //most use able is zoom, we use default value for bearing and tilt
          zoom: 15,
          //standard value 15-17, 17 for location oriented suppose office location
          bearing: 30,
          //map angel from north to clockwise direction
          tilt: 10,
          //camera angel
          target: LatLng(24.462366675440375,
              89.70871717947436), //Sirajganj Govt. college lat and lang
        ),
        myLocationEnabled: true,
        //default is false
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        //by default true; it give facility to zoom in or zoom out
        zoomGesturesEnabled: true,
        // by default true; it give facility to click on a position and zoom it
        trafficEnabled: false,
        // by default false; to see people or vehicle in road that road is free or has jam
        onMapCreated: (GoogleMapController controller) {
          //onMapCreated return controller, we can control the map by this controller, like zoom,move map etc

          print("On Map Created");
          _googleMapController = controller; //
        },
        compassEnabled: true,
        // by default true; compass inside a circular radius

        onTap: (LatLng latLng) {
          //it return LatLng on where user click inside the map
          print("LatLng of click/press position inside the map is : $latLng");
        },
        onLongPress: (LatLng latLng) {
          //it return LatLng on where user Long press  inside the map
          print("LatLng of  Long press position inside the map is : $latLng");
        },
        mapType: MapType.normal,
        // mapType: MapType.none, // no map, no data will display
        // mapType: MapType.satellite,
        // mapType: MapType.hybrid, //(both satellite and normal view)
        // mapType: MapType.terrain,

        //we can add multiple Markers class inside the set but id should different unless, we will see only last marker it will become stack on each other
        markers: <Marker>{
          Marker(
              markerId: const MarkerId('custom-marker'),
              position: const LatLng(24.462366675440375, 89.70871717947436),
              //sirajganj govt college
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              // marker icon, it could be anything, like cat, cow any thing
              infoWindow: const InfoWindow(title: "D.College"),
              // when click on marker then show this title of marker
              draggable: false,
              //by default false
              // draggable: true, // drag the marker one place to another
              onDragStart: (LatLng latlng) {
                print(latlng);
              },
              onDragEnd: (LatLng latlng) {
                print(latlng);
              }),

          //we can add multiple Markers class inside the set but id should different unless, we will see only last marker it will become stack on each other
          Marker(
              markerId: const MarkerId('custom-marker-2'),
              position: const LatLng(24.46502911924947, 89.70618009567262),
              //Rashidozzoha Women's college
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRose),
              // marker icon, it could be anything, like cat, cow any thing
              infoWindow: const InfoWindow(title: "W.College"),
              // when click on marker then show this title of marker
              draggable: false,
              //by default false
              // draggable: true, // drag the marker one place to another
              onDragStart: (LatLng latlng) {
                print(latlng);
              },
              onDragEnd: (LatLng latlng) {
                print(latlng);
              }),

          Marker(
              markerId: const MarkerId('custom-marker-3'),
              position: const LatLng(24.4604486599282, 89.71615991524304),
              //north bengal medical college
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
              // marker icon, it could be anything, like cat, cow any thing
              infoWindow: const InfoWindow(title: "N.M.College"),
              // when click on marker then show this title of marker
              draggable: false,
              //by default false
              // draggable: true, // drag the marker one place to another
              onDragStart: (LatLng latlng) {
                print(latlng);
              },
              onDragEnd: (LatLng latlng) {
                print(latlng);
              }),
        },
        //polyline use to draw strait line between two area
        polylines: <Polyline>{
          Polyline(
              polylineId: const PolylineId('polyline'),
              color: Colors.pink,
              width: 5,
              //jointType is start or joint tow lines make is round
              // jointType: JointType.mitered,
              jointType: JointType.round,
              onTap: () {
                print("Tapped on Polyline");
              },
              //add our three marker with the polylines
              points: const [
                //first latlng to second, second to third, third to first
                LatLng(24.462366675440375, 89.70871717947436),
                LatLng(24.46502911924947, 89.70618009567262),
                LatLng(24.4604486599282, 89.71615991524304),
                LatLng(24.462366675440375, 89.70871717947436),
              ]),
        },


        //circle-give circular area of a given lat-lng, we can use multiple circle but make sure id is different unless all of the circle become stack and visible only last circle.add circle at our 3 marker
        circles: <Circle>{
          //add circle at Sirajganj govt. college
          Circle(circleId: CircleId('demo'),
            center: LatLng(24.462366675440375, 89.70871717947436),//add circle at Sirajganj govt. college
            radius: 300,
            visible: true, //by default true
            strokeColor: Colors.purple, //circular area rounded color
            strokeWidth: 3,//circular area rounded color width
            fillColor: Colors.purple.shade100, // inside color of circle, make it transparent by .shade100 so that data of map inside  the circle can visible
            onTap: (){
            print("Tapped on Circle");
            },
          ),


          //add circle at Women college
          Circle(circleId: CircleId('demo-2'),
            center: LatLng(24.46502911924947, 89.70618009567262),//rashiduzzoha women college
            radius: 300,
            visible: true, //by default true
            strokeColor: Colors.purple, //circular area rounded color
            strokeWidth: 3,//circular area rounded color width
            fillColor: Colors.purple.shade100, // inside color of circle, make it transparent by .shade100 so that data of map inside  the circle can visible
            onTap: (){
              print("Tapped on Circle");
            },
          ),
          //add circle at NorthBengal Medical college
          Circle(circleId: CircleId('demo-3'),
            center: LatLng(24.4604486599282, 89.71615991524304),//add circle at North Bengal Medical college
            radius: 300,
            visible: true, //by default true
            strokeColor: Colors.purple, //circular area rounded color
            strokeWidth: 3,//circular area rounded color width
            fillColor: Colors.purple.shade100, // inside color of circle, make it transparent by .shade100 so that data of map inside  the circle can visible
            onTap: (){
              print("Tapped on Circle");
            },
          ),
        },


        //Polygon-used to define an area which has special case, like corona or dengue affected area
        polygons: <Polygon>{
           Polygon(polygonId: PolygonId('poly-id'),
          fillColor: Colors.purple.shade400, //make color transparent so map text/area could visible
           strokeWidth: 0,  //stroke looks ugly here so make it 0
             onTap: (){
             print("Polygon tapped");
             },

             points: const [
               //set area of polygon, we can add many more latlng
               LatLng(24.46121867033018, 89.70143392682076),
               LatLng(24.455707567267474, 89.69457417726515),
               LatLng(24.446473838787337, 89.70979705452919),
               LatLng(24.45415289087343, 89.71224926412104),
             ]
          ),
        },

      ),
    );
  }
}
