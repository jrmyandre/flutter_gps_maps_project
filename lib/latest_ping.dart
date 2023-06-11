import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home.dart';

class LatestPing extends StatefulWidget{
  const LatestPing({super.key});
  
  
  

  @override
  // ignore: library_private_types_in_public_api
  _LatestPingState createState() => _LatestPingState();
}

class _LatestPingState extends State<LatestPing>{
  final dbRef = FirebaseDatabase.instance.ref().child("locations");
  Map<dynamic,dynamic> latestData = {};
  List<Map<dynamic,dynamic>> dataList = [];
  late GoogleMapController _googleMapController;

  @override
  void initState(){
    super.initState();
    

  dbRef.orderByChild('timestamp').onValue.listen((event) {
    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    for (var item in data.values) {
      if (item['manual'] == true) {
        setState(() {
          latestData = item;
        });
        // latestData = item;
        break;
      }
    }

  });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        
        leading: 
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        backgroundColor: const Color(0xFF0f0b53),
        title: const Text("Latest Ping"),
      ),
      body: Column(
        children: [
          Container(
            
            height: MediaQuery.of(context).size.height * 0.55,
            child: 
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  -6.200000,
                  106.816666,
                
                ),
                zoom: 11.5,
                
              ),
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                Marker(
                  markerId: const MarkerId("Latest SOS"),
                  position: LatLng(double.parse(latestData['latitude']??'0'), double.parse(latestData['longitude']??'0')),
                  infoWindow:
                  const InfoWindow(title: 'Latest SOS'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                
                )
              }
            ),
          ),
          
        ],
      )
    );
  }

}