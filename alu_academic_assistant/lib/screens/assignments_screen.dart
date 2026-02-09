import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../widgets/assignments_tile.dart';
import 'add_assignment_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Assignment> _assignments = [
    Assignment(
      id: '1',
      title: 'Assignment 1',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      courseName: 'Mobile App Development',
      priority: 'High',
    ),
    Assignment(
      id: '2',
      title: 'Assignment 2',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      courseName: 'Software Engineering',
      priority: 'Medium',
    ),
    Assignment(
      id: '3',
      title: 'Group Project',
      dueDate: DateTime.now().add(const Duration(days: 10)),
      courseName: 'Mobile App (Flutter)',
      priority: 'Low',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _sortAssignments();
  }

  void _sortAssignments() {
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void _addAssignment(Assignment assignment) {
    setState(() {
      _assignments.add(assignment);
      _sortAssignments();
    });
  }

  void _deleteAssignment(Assignment assignment) {
    setState(() {
      _assignments.removeWhere((a) => a.id == assignment.id);
    });
  }

 void _editAssignment(Assignment oldAssignment, Assignment updated) {
  setState(() {
    final index =
        _assignments.indexWhere((a) => a.id == oldAssignment.id);

    if (index != -1) {
      _assignments[index] = oldAssignment.copyWith(
        title: updated.title,
        courseName: updated.courseName,
        dueDate: updated.dueDate,
        priority: updated.priority,
        isCompleted: updated.isCompleted,
      );
    }

    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  });
}

  List<Assignment> _filteredAssignments() {
    // Tabs are UI-based for now (can be extended later)
    return _assignments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A3A),
        elevation: 0,
        title: const Text('Assignments'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Formative'),
            Tab(text: 'Summative'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Create Assignment Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          // Assignment List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAssignmentList(_filteredAssignments()),
                _buildAssignmentList(_filteredAssignments()),
                _buildAssignmentList(_filteredAssignments()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentList(List<Assignment> assignments) {
    if (assignments.isEmpty) {
      return const Center(
        child: Text(
          'No assignments yet',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return AssignmentTile(
          assignment: assignment,
          onToggleComplete: (value) {
            setState(() {
              assignment.isCompleted = value ?? false;
            });
          },
          onDelete: () => _deleteAssignment(assignment),
          onEdit: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddAssignmentScreen(assignmentToEdit: assignment),
              ),
            );

            if (updated != null && updated is Assignment) {
              _editAssignment(assignment, updated);
            }
          },
        );
      },
    );
  }
}
