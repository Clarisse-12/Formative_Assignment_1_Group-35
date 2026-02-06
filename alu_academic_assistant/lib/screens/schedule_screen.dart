import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A3A),
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: const Color(0xFF0A1A3A),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _dayHeader('Monday'),
          _sessionCard(
            title: 'Mobile App Development',
            time: '09:00 - 11:00',
            location: 'Room B2',
          ),
          _sessionCard(
            title: 'Software Engineering',
            time: '13:00 - 15:00',
            location: 'Room C1',
          ),
          _dayHeader('Tuesday'),
          _sessionCard(
            title: 'Data Structures',
            time: '10:00 - 12:00',
            location: 'Room A3',
          ),
        ],
      ),
    );
  }

  Widget _dayHeader(String day) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        day,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
        ),
      ),
    );
  }

  Widget _sessionCard({
    required String title,
    required String time,
    required String location,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const Icon(Icons.school),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$time • $location'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
