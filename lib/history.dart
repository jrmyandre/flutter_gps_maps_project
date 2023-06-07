import 'package:flutter/material.dart';
// import 'package:flutter_google_map_testing/database_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:provider/provider.dart';
// import 'package:dio/dio.dart';
import 'directions_model.dart';
import 'directions_reposiroty.dart';
import 'latest_data.dart';
import 'popup_alert.dart';
import 'home.dart';


class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});
  
  
  


  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 11.5,
  );
  final dbRef = FirebaseDatabase.instance.ref().child("locations");
  List<Map<dynamic,dynamic>> dataList = [];
  List<Map<dynamic,dynamic>> tempDataList = [];


  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  Directions? _info;
  List<Polyline> _polylines = [];
  int totalDistance = 0;
  List<int> totalDuration = [0, 0];




  @override
  void initState(){
    super.initState();
    


    dbRef.onValue.listen((event) {
      dataList.clear();
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, values) {
        dataList.add(values);
      });
      _updateMarker();

    });
    dbRef.orderByChild('timestamp').limitToLast(1).onChildAdded.listen((event) {
        if (event.snapshot.value != null){
          Map<dynamic,dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          bool isManual = data['manualTemp'];
          if(isManual){
            LatestData latestData = LatestData(
              latitude: double.parse(data['latitude']),
              longitude: double.parse(data['longitude']),
              timestamp: DateTime.parse(data['timestamp']),
              isManual: data['manualTemp'],
            );
            dbRef.child(event.snapshot.key!).child('manualTemp').set(false).then((_){
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => PopupAlert(latestData: latestData,)),
                (route) => false
              );
            }
             );
          }
        }
      });
  }

  void _updateMarker ()async{
    _markers.clear();
    _polylines.clear();



    dataList.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
  
    for(var i=0;i<dataList.length; i++){
      double lat = double.parse(dataList[i]['latitude']);
      double lng = double.parse(dataList[i]['longitude']);

      Marker marker = Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(lat, lng),
        infoWindow:
        InfoWindow(title: 'Marker ${i+1}'),
        icon: BitmapDescriptor.defaultMarker,
      );

      _markers.add(marker);  
    }

    for(var i=0; i<_markers.length; i++){
      final directions = await DirectionsRepository().getDirections(origin: _markers.elementAt(i).position, destination: _markers.elementAt(i+1).position);
      if (directions != null){
        setState(() {
            _info = directions;
            _polylines.add(Polyline(polylineId: PolylineId("Polyline $i"),
              color: Colors.blue,
              width: 5,
              points: _info!.polylinePoints
                .map((e) => LatLng(e.latitude, e.longitude)).toList(),
              
              ));
          });
      }
    }
  }
  

  @override
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    // DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    // databaseProvider.listenSosPing(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xFF0f0b53),
        title: const Text('History'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>  const HomePage(),
            ),
            (route) => false
           
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.55,
            
        alignment: Alignment.center,
        child: 
          GoogleMap(
            myLocationEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _markers,
            polylines: Set<Polyline>.of(_polylines),

            ),
        
      ),
      Expanded(
        child: Container(
        color:const  Color(0xFF0f0b53),
        
        child: 
      ListView.builder(
        
        itemCount: dataList.length,
        itemBuilder: (context, index) =>
        Card(
          color: const Color(0xFFff5fff),
          elevation: 4,
          child: ListTile(
          title: Text('Marker ${index+1}',
          style: const TextStyle(
            color: Color(0xFF0f0b53),
            fontWeight: FontWeight.bold,
          )
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dataList[index]['timestamp'],
              style: const TextStyle(
            color: Color(0xFF0f0b53),
            fontWeight: FontWeight.bold,
          )),
              Text('Lat: ${dataList[index]['latitude']}',
              style: const TextStyle(
            color: Color(0xFF0f0b53),
            fontWeight: FontWeight.bold,
          )
          ),
              Text('Lng: ${dataList[index]['longitude']}',
              style: const TextStyle(
            color:  Color(0xFF0f0b53),
            fontWeight: FontWeight.bold,
          )),
            ],
          )
      ),
        )
         
      )
      )
      ),
      
      //   child: ListView.builder(
      //     itemCount: _markers.length,
      //     itemBuilder: (context, index) => ListTile(
      //       title: Text('Marker ${index+1}'),
      //       // subtitle: Text('Lat: ${_markers.elementAt(index).position.latitude.toStringAsFixed(5)} \nLng: ${_markers.elementAt(index).position.longitude.toStringAsFixed(5)}'),
      //     ),
          
      //    )

      // )

        ],
      ),
      
      


        
        );
  }

}