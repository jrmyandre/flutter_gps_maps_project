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
  List<Map<dynamic,dynamic>> dataList = [];
  List<Map<dynamic,dynamic>> tempDataList = [];

  @override
  void initState(){
    super.initState();
    

dbRef.onValue.listen((event) {
  dataList.clear();
  Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
  
  List<dynamic> sortedData = data.values.toList();
  sortedData.sort((a, b) {
    DateTime timestampA = DateTime.parse(a['timestamp']);
    DateTime timestampB = DateTime.parse(b['timestamp']);
    return timestampB.compareTo(timestampA);
  });
  
  for (dynamic item in sortedData) {
    if (item['manual'] == true) {
      dataList.add(item);
      _updateMarker();
      break; // Break out of the loop after finding the most recent "manual" item
    }
  }
  });
  }

  void _updateMarker(){
    setState(() {
      tempDataList = dataList;
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
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  -6.200000,
                  106.816666,
                
                ),
                zoom: 11.5,
                
              ),
              markers: {

              }
            ),
          ),
          
        ],
      )
    );
  }

}