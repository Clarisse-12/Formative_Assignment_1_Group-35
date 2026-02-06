import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';


class AssignmentTile extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleComplete;

  const AssignmentTile({
    super.key,
    required this.assignment,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Checkbox(
              value: assignment.isCompleted,
              onChanged: onToggleComplete,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                 Text(
  'Due ${DateFormat('MMM d').format(assignment.dueDate)}',
  style: TextStyle(color: Colors.grey[600]),
),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
