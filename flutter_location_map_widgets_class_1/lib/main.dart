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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Screen"),
      ),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(24.605169371098192, 89.64165685434453),
        ),
      ), //Tarakandi school lat and lang
    );
  }
}
