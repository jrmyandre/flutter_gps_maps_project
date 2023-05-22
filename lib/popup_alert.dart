import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'latest_data.dart';

class PopupAlert extends StatelessWidget {
  final LatestData latestData;
  const PopupAlert({Key? key, required this.latestData}) : super(key: key);
  // static final _initialCameraPosition = CameraPosition(
  //   target: LatLng(latestData.latitude, latestData.longitude),
  //   zoom: 11.5,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Ping!'),
      ),
      body: Stack(
        
        children: [
          SizedBox(
          //make height 60% of screen
            height: double.infinity,
          //make width maximum screen size
            width: double.infinity,
            child: 
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(latestData.latitude, latestData.longitude),
                zoom: 11.5,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('marker_1'),
                  position: LatLng(latestData.latitude, latestData.longitude),
                ),
              },
            ),
          ),
          GridView(
            padding: const EdgeInsets.all(25),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
             ),
             children: [
              InkWell(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blueAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text('Direction'),
                ),
              )
             ],
          )
          
          
        ],
      ),
    );
  }
}
