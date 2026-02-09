import 'package:flutter/material.dart';
import '../models/assignment.dart';

class AssignmentTile extends StatelessWidget {
  final Assignment assignment;
  final Function(bool?) onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AssignmentTile({
    super.key,
    required this.assignment,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onEdit,
  });

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: assignment.isCompleted,
          onChanged: onToggleComplete,
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            decoration:
                assignment.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${assignment.courseName}\nDue: ${assignment.dueDate.toLocal().toString().split(' ')[0]}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton(
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            if (value == 'delete') onDelete();
            if (value == 'edit') onEdit();
          },
        ),
        tileColor: _priorityColor(assignment.priority).withOpacity(0.15),
      ),
    );
  }
}
