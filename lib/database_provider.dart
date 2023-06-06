import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'latest_data.dart';
import 'popup_alert.dart';

class DatabaseProvider extends ChangeNotifier{
  final dbProvRef = FirebaseDatabase.instance.ref().child("locations");

  void listenSosPing(BuildContext context){
    dbProvRef.orderByChild('timestamp').limitToLast(1).onChildAdded.listen((event) {
        if (event.snapshot.value != null){
          Map<dynamic,dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          bool isManual = data['manual'];
          if(isManual){
            LatestData latestData = LatestData(
              latitude: double.parse(data['latitude']),
              longitude: double.parse(data['longitude']),
              timestamp: DateTime.parse(data['timestamp']),
              isManual: data['manual'],
            );
            dbProvRef.child(event.snapshot.key!).child('manual').set(false).then((_){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PopupAlert(latestData: latestData,)),
              );
            }
             );
          }
        }
      });    
  }  
}