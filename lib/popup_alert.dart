import 'package:flutter/material.dart';
import 'package:flutter_google_map_testing/home.dart';
// import 'package:flutter_google_map_testing/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'latest_data.dart';
import 'package:url_launcher/url_launcher.dart';

class PopupAlert extends StatelessWidget {
  final LatestData latestData;
  const PopupAlert({Key? key, required this.latestData}) : super(key: key);
  // static final _initialCameraPosition = CameraPosition(
  //   target: LatLng(latestData.latitude, latestData.longitude),
  //   zoom: 11.5,
  // );

    openMaps() async{
    var latitude = latestData.latitude;
    var longitude = latestData.longitude;
    String url = "https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}";
    if (await canLaunch(url)){
      await launch(url);
    }
    else{
      throw 'Could not launch $url';
    }
  }

  openTelephone() async{
    var uri = Uri(
      scheme: 'tel',
      path: latestData.phoneNumber.toString(),
    );
    if (await canLaunchUrl(uri)){
      await launchUrl(uri);
    }
    else{
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        leading: IconButton(
          icon: const Icon(Icons.close),
          //onpressed go to MainApp()
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false
          ),
          color: Color(0xFF00ffc4),

        ),
        title: const Text('New SOS!',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF00ffc4),

        ),
        // leading: IconButton(
        //   icon: Icon(Icons.close),
        //   //onpressed go to MainApp()
        //   onPressed: () => Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => MainApp(),
        //     ),
        //   ),

        // )
        
      ),
      ),
      body: Column(
        
        children: [
          SizedBox(
          //make height 60% of screen
            height: MediaQuery.of(context).size.height * 0.7,
          //make width maximum screen size
            width: MediaQuery.of(context).size.width,
            child: 
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(latestData.latitude, latestData.longitude),
                zoom: 11.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('New SOS'),
                  position: LatLng(latestData.latitude, latestData.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
              },
            ),
          ),
          Expanded(
            child: Container(
              color:const  Color(0xFF000000),
              child: ListView(
                children: [
                  Card(
                    margin: EdgeInsets.all(10),
                    
                    color: Color(0xFF00ffc4),
                    elevation: 4,
                    child: InkWell(
                      
                      onTap: openMaps,
                      child: ListTile(
                        
                        title: const Text("Directions",
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
                    margin: EdgeInsets.all(10),
                    
                    color: Color(0xFF00ffc4),
                    elevation: 4,
                    child: InkWell(
                      
                      onTap: openTelephone,
                      child: ListTile(
                        
                        title: const Text("Call",
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
      ),
    );
  }
}
