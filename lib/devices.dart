import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Devices",
          style: TextStyle(
            color: Color(0xFFff5fff),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Color(0xFF0f0b53),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          },
          color: Color(0xFFff5fff),
        ),
      ),
      body: Container(
        color: Color(0xFF0f0b53),
        child: ListView.builder(
          itemCount: userIds.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              color: Color(0xFFff5fff),
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
                leading: Icon(Icons.person,
                size: 40,
                color: Color(0xFF0f0b53),),
                title: Text(
                  userIds.elementAt(index),
                  style: const TextStyle(
                    color: Color(0xFF0f0b53),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                subtitle: Text(
                  phoneNumbers[index],
                  style: const TextStyle(
                    color: Color(0xFF0f0b53),
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
