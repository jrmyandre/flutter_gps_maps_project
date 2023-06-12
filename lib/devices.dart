import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';

class DevicePage extends StatefulWidget{
  const DevicePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage>{
  final dbRef = FirebaseDatabase.instance.ref().child("locations");
  List<String> userIds = [];
  
  @override
  void initState(){
    super.initState();

    dbRef.onValue.listen((event) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      for (var item in data.values){
        if (!userIds.contains(item['user_id'])){
          setState(() {
            userIds.add(item['user_id']);
          });
      }

      }
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices",
        style: TextStyle(
          color: Color(0xFFff5fff),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins'
        ),
        ),
        backgroundColor: Color(0xFF0f0b53),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false
            );
          },
          color: Color(0xFFff5fff),
        ),

      ),
      body: Container(
        color:  Color(0xFF0f0b53),
        child: ListView.builder(
          itemCount: userIds.length,
          itemBuilder: (context, index){
            return Card(
              elevation: 4,
              color: Color(0xFFff5fff),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(userIds[index],
                style: const TextStyle(
                  color: Color(0xFF0f0b53),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'
                ),
                ),
              ),
            );
          },

        )
      )
    );
    
    // TODO: implement build

  }

}