import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'latest_data.dart';
import 'popup_alert.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final dbRef = FirebaseDatabase.instance.ref().child("locations");
  Set<String> userIds = {};
  List<String> phoneNumbers = [];



  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      for (var item in data.values) {
        String userId = item['user id'];
        String phoneNumber = item['phone number'].toString();

        if (!userIds.contains(userId)) {
          setState(() {
            userIds.add(userId);
            phoneNumbers.add(phoneNumber);
          });
        }
      }
    });
    dbRef.orderByChild('timestamp').limitToLast(1).onChildAdded.listen((event) {
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
            dbRef.child(event.snapshot.key!).child('manual temp').set(false).then((_){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Devices",
          style: TextStyle(
            color: Color(0xFF00ffc4),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor:const Color(0xFF000000),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
          color:const Color(0xFF00ffc4),
        ),
      ),
      body: Container(
        color:const Color(0xFF000000),
        child: ListView.builder(
          itemCount: userIds.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              color:const Color(0xFF00ffc4),
              child: ListTile(
                onTap: () async {
                  var uri = Uri(
                    scheme: 'tel',
                    path: phoneNumbers[index],
                  );
                  if (await canLaunchUrl(uri)) {
                    launchUrl(uri);
                  } else {
                    throw 'Could not launch $uri';
                  }
                },
                leading:const Icon(Icons.person,
                size: 40,
                color: Color(0xFF000000),),
                title: Text(
                  userIds.elementAt(index),
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                subtitle: Text(
                  phoneNumbers[index],
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
