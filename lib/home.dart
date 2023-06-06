import 'package:flutter/material.dart';
import 'package:flutter_google_map_testing/database_provider.dart';
import 'package:flutter_google_map_testing/main.dart';
import 'package:provider/provider.dart';

//make HomePage()
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    databaseProvider.listenSosPing(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      //make body
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('History'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
            },
          ),
        ],
      )
    );
  }
}
