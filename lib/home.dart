// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_google_map_testing/database_provider.dart';
import 'package:flutter_google_map_testing/latest_ping.dart';
// import 'package:flutter_google_map_testing/main.dart';
import 'package:provider/provider.dart';
import 'history.dart';

//make HomePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    databaseProvider.listenSosPing(context);
    return Scaffold(
      backgroundColor:const Color(0xFF0f0b53),
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      // ),
      //make body
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top:35),
            height: MediaQuery.of(context).size.height * 0.13,
            width: MediaQuery.of(context).size.width * 0.4,
            child: const Image(image: AssetImage("assets/images/Logo Scoutify (Globe).png")),
            
          ),
          const Text(
            "Scoutify",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: Color(0xFF00ffc4),
              letterSpacing: 4
            
            ),
          ),
          const SizedBox(height: 15,),
          
          Expanded(child: 
          ListView(
        children: <Widget>[
          Container(
            
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
            

            // color: Color(0xFFff5fff),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:const Color(0xFFff5fff)
            ),



        
            child: InkWell(
              // borderRadius: BorderRadius.circular(10),
              
            child: ListTile(
              leading: const Icon(
                Icons.history,
                color: Color(0xFF0f0b53),
                size: 50,
              ),
              
            title: const Text('History',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color(0xFF0f0b53)
            ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
            },
          ),
          )
          
          
          ),
         const SizedBox(height: 20
          ,),
          Container(
            
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
            

            // color: Color(0xFFff5fff),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:const Color(0xFFff5fff)
            ),



        
            child: InkWell(
              // borderRadius: BorderRadius.circular(10),
              
            child: ListTile(
              leading: Icon(
                Icons.sos,
                color: Color(0xFF0f0b53),
                size: 50,
              ),
              
            title: const Text('Latest Ping',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color(0xFF0f0b53)
            ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LatestPing()));
            },
          ),
          )
          
          
          ),
         const SizedBox(height: 20),
          Container(
            
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
            

            // color: Color(0xFFff5fff),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:const Color(0xFFff5fff)
            ),



        
            child: InkWell(
              // borderRadius: BorderRadius.circular(10),
              
            child: ListTile(
              leading: Icon(
                Icons.devices,
                color: Color(0xFF0f0b53),
                size: 50,
              
              ),
              
            title: const Text('Devices',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color(0xFF0f0b53)
            ),
            ),
            // onTap: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
            // },
          ),
          )
          
          
          ),
          
          // InkWell(
          //   child: ListTile(
          //     title: const Text("Latest Ping"),

          //   ),
          // )
        ],
      )
          )


          
        ],
      ),
      
      
    );
  }
}
