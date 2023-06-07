import 'package:flutter/material.dart';
import 'package:flutter_google_map_testing/database_provider.dart';
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
      backgroundColor: Color(0xFF0F0B53),
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      // ),
      //make body
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.23,
            child: const Image(image: AssetImage("assets/images/Scoutify_Logo.png")),
          ),
          
          Expanded(child: 
          ListView(
        children: <Widget>[
          Container(
            
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
            

            // color: Color(0xFFff5fff),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFff5fff)
            ),



        
            child: InkWell(
              // borderRadius: BorderRadius.circular(10),
              
            child: ListTile(
              
            title: const Text('History',
            textAlign: TextAlign.center,
            style: TextStyle(
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
          SizedBox(height: 20
          ,),
          Container(
            
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
            

            // color: Color(0xFFff5fff),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFff5fff)
            ),



        
            child: InkWell(
              // borderRadius: BorderRadius.circular(10),
              
            child: ListTile(
              
            title: const Text('Latest Ping',
            textAlign: TextAlign.center,
            style: TextStyle(
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
          SizedBox(height: 20),
          Container(
            
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
            

            // color: Color(0xFFff5fff),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFff5fff)
            ),



        
            child: InkWell(
              // borderRadius: BorderRadius.circular(10),
              
            child: ListTile(
              
            title: const Text('Devices',
            textAlign: TextAlign.center,
            style: TextStyle(
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
