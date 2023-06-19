

import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'database_provider.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp( 
    MainApp());
}

class MainApp extends StatelessWidget {
   const MainApp({super.key});



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DatabaseProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      
      ),
      );

  }
}

