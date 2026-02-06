import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../widgets/assignments_tile.dart';
import 'add_assignment_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final List<Assignment> _assignments = [
  Assignment(
    id: '1',
    title: 'Mobile App Development Assignment',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    courseName: 'Mobile Development',
    priority: 'High',
  ),
  Assignment(
    id: '2',
    title: 'Software Engineering Report',
    dueDate: DateTime.now().add(const Duration(days: 5)),
    courseName: 'Software Engineering',
    priority: 'Medium',
  ),
];

  void _addAssignment(Assignment assignment) {
    setState(() {
      _assignments.add(assignment);
      _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  void _deleteAssignment(Assignment assignment) {
    setState(() {
      _assignments.remove(assignment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A3A),
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: const Color(0xFF0A1A3A),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Yellow button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddAssignmentScreen(),
                    ),
                  );

                  if (result != null && result is Assignment) {
                    _addAssignment(result);
                  }
                },
                child: const Text(
                  'Create Group Assignment',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Assignment list
          Expanded(
            child: _assignments.isEmpty
                ? const Center(
                    child: Text(
                      'No assignments yet',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    itemCount: _assignments.length,
                    itemBuilder: (context, index) {
                      final assignment = _assignments[index];
                      return AssignmentTile(
                        assignment: assignment,
                        onToggleComplete: (value) {
                          setState(() {
                            assignment.isCompleted = value ?? false;
                          });
                        },
                        onDelete: () => _deleteAssignment(assignment),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
