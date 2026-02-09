import 'package:flutter/material.dart';
import '../logic/schedule_logic.dart';
import '../models/session.dart';
import '../utils/helpers.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weeklySessions = getWeeklySessions(today);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A3A),
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: const Color(0xFF0A1A3A),
        elevation: 0,
      ),
      body: weeklySessions.isEmpty
          ? const Center(
              child: Text(
                'No sessions scheduled',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: weeklySessions.length,
              itemBuilder: (context, index) {
                final Session session = weeklySessions[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.school),
                    title: Text(
                      session.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${Helpers.formatDateWithDay(session.date)} • '
                      '${Helpers.formatTime(session.startTime)} - '
                      '${Helpers.formatTime(session.endTime)}'
                      '${session.location != null ? ' • ${session.location}' : ''}',
                    ),
                    trailing: Checkbox(
                      value: session.isPresent,
                      onChanged: (_) {
                        toggleAttendance(session);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
