import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';

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
    latestData.clear();
    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
    List<dynamic> sortedData = data.values.toList();
    sortedData.sort((a, b) => -a['timestamp'].compareTo(b['timestamp']));
    for (var item in sortedData) {
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

  openMaps() async{
    var latitude = latestData['latitude'];
    var longitude = latestData['longitude'];
    String url = "https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}";
    if (await canLaunch(url)){
      await launch(url);
    }
    else{
      throw 'Could not launch $url';
    }
  }

  openTelephone() async{
    var phoneNumber = latestData['phone number'];
    var uri = Uri(
      scheme: 'tel',
      path: phoneNumber.toString(),
    );
    if (await canLaunchUrl(uri)){
      await launchUrl(uri);
    }
    else{
      throw 'Could not launch $uri';
    }
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
          color: const Color(0xFF00ffc4),
        ),
        backgroundColor: const Color(0xFF000000),
        title: const Text("Latest Ping",
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF00ffc4),
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: 
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(latestData['latitude']??"-6.2"),
                  double.parse(latestData['longitude']??"106.816666"),
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
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                
                )
              }
            ),
          ),
          Expanded(
            child: Container(
              color:const  Color(0xFF000000),
              child: ListView(
                children: [
                  Card(
                    margin:const EdgeInsets.all(10),
                    
                    color:const Color(0xFF00ffc4),
                    elevation: 4,
                    child: InkWell(
                      
                      onTap: openMaps,
                      child: const ListTile(
                        
                        title:  Text("Directions",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF000000),

                        ),)
                      )
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(10),
                    
                    color:const Color(0xFF00ffc4),
                    elevation: 4,
                    child: InkWell(
                      
                      onTap: openTelephone,
                      child: const ListTile(
                        
                        title:  Text("Call",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF000000),

                        ),)
                      )
                    ),
                  ),

                  

                ],
              ),
            ),
          )
          
        ],
      )
    );
  }

}