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
  final Set<Marker> _markers = {};

  @override
  void initState(){
    super.initState();
    

dbRef.orderByChild('timestamp').onValue.listen((event) {
  Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
  
  
  for (var item in data.values) {
    if (item['manual'] == true) {
      latestData = item;
      _updateMarker();
      break; // Break out of the loop after finding the most recent "manual" item
    }
  }
  });
  }

  void _updateMarker(){
    _markers.clear();
    setState(() {
      Marker marker = Marker(
        markerId: MarkerId("Latest SOS"),
        position: LatLng(latestData['latitude'], latestData['longitude']),
        infoWindow:
        InfoWindow(title: 'Latest SOS'),
        icon: BitmapDescriptor.defaultMarker,
      );
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: 
        IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        backgroundColor: Color(0xFF0f0b53),
        title: Text("Latest Ping"),
      ),
      body: Column(
        children: [
          Container(
            
            height: MediaQuery.of(context).size.height * 0.55,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  -6.200000,
                  106.816666,
                
                ),
                zoom: 11.5,
                
              ),
              markers: _markers
            ),
          ),
          
        ],
      )
    );
  }

}