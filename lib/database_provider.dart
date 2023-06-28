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
          bool isManual = data['manual temp'];
          if(isManual){
            LatestData latestData = LatestData(
              latitude: double.parse(data['latitude']),
              longitude: double.parse(data['longitude']),
              timestamp: DateTime.parse(data['timestamp']),
              phoneNumber: data['phone number'].toString(),
              isManual: data['manual temp'],
            );
            dbProvRef.child(event.snapshot.key!).child('manual temp').set(false).then((_){
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
}