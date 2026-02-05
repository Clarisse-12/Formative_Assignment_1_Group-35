import 'package:flutter/material.dart';
import '../screens/assignments_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/schedule_screen.dart';

class BottonNav extends StatefulWidget {
  const BottonNav({super.key});

  @override
  State<BottonNav> createState() => _BottonNavState();
}

class _BottonNavState extends State<BottonNav> {
  int myIndex = 0;

  // List of screens to show in bottom navigation
  final List<Widget> screens = [
    
    DashboardScreen(),
    AssignmentsScreen(),
    ScheduleScreen(),
 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using IndexedStack to preserve screen state
      body: IndexedStack(
        index: myIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'assignment',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
            backgroundColor: Colors.deepOrange,
          ),
        ],
      ),
    );
  }
}