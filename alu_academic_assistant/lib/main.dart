import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './navigations/bottom.dart';
import './screens/assignments_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/schedule_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Academic Assistant',
      theme: ThemeData(
        primaryColor: const Color(0xFF003366), // ALU blue
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003366),
          foregroundColor: Colors.white,
        ),
      ),
      home: const BottonNav(),
      routes: {
},
    ); 
  }
}
