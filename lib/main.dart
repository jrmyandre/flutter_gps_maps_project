// Farrel Zephaniah Lie 2540125390
// Jeremy Andre Muljono 2540128184
// Matthew Filbert Tander 2501994241
// Made for "Scoutify" GPS Tracker app for Semester Final Project, Binus University, Computer Engineering, 2023 Even Semester
// Mobile App Development for Engineering and Internet of Things course

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

