import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../logic/schedule_logic.dart';
import '../models/session.dart';
import '../utils/helpers.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _viewMode = 'Week'; // 'Today' or 'Week'

  Color _getSessionTypeColor(String sessionType) {
    switch (sessionType) {
      case 'Class':
        return ALUColors.infoBlue;
      case 'Mastery Session':
        return ALUColors.accentYellow;
      case 'Study Group':
        return ALUColors.successGreen;
      case 'PSL Meeting':
        return const Color(0xFFB794F4);
      default:
        return ALUColors.textGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final sessions = _viewMode == 'Today'
        ? getTodaysSessions(today)
        : getWeeklySessions(today);
    final attendance = calculateAttendance();
    final isBelowLimit = isBelowThreshold();

    return Scaffold(
      backgroundColor: ALUColors.backgroundDark,
      appBar: AppBar(
        title: const Text(
          'Schedule',
          style: TextStyle(
            color: ALUColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ALUColors.backgroundDark,
        elevation: 0,
        actions: [_buildViewModeToggle(), const SizedBox(width: 8)],
      ),
      body: Column(
        children: [
          _buildAttendanceHeader(attendance, isBelowLimit),
          Expanded(
            child: sessions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: ALUColors.textGray.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _viewMode == 'Today'
                              ? 'No sessions scheduled for today'
                              : 'No sessions scheduled this week',
                          style: TextStyle(
                            color: ALUColors.textGray,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => setState(() {}),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final sessionIndex = allSessions.indexOf(session);
                        return _buildSessionCard(session, sessionIndex);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSessionDialog(context),
        backgroundColor: ALUColors.accentYellow,
        icon: const Icon(Icons.add, color: ALUColors.primaryDark),
        label: const Text(
          'Add Session',
          style: TextStyle(
            color: ALUColors.primaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildToggleButton('Today', _viewMode == 'Today'),
          _buildToggleButton('Week', _viewMode == 'Week'),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _viewMode = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ALUColors.accentYellow : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? ALUColors.primaryDark : ALUColors.textGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceHeader(double attendance, bool isBelowLimit) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBelowLimit
              ? ALUColors.warningRed.withOpacity(0.5)
              : ALUColors.successGreen.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isBelowLimit ? Icons.warning_amber_rounded : Icons.verified,
            color: isBelowLimit ? ALUColors.warningRed : ALUColors.successGreen,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Attendance',
                  style: TextStyle(color: ALUColors.textGray, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${attendance.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isBelowLimit
                            ? ALUColors.warningRed
                            : ALUColors.successGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${allSessions.where((s) => s.isPresent).length}/${allSessions.length})',
                      style: TextStyle(color: ALUColors.textGray, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isBelowLimit)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ALUColors.warningRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Below 75%',
                style: TextStyle(
                  color: ALUColors.warningRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Session session, int index) {
    final isPast = session.date.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ALUColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ALUColors.textGray.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () => _showSessionOptions(context, session, index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.title,
                      style: const TextStyle(
                        color: ALUColors.textWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getSessionTypeColor(
                        session.sessionType,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.sessionType,
                      style: TextStyle(
                        color: _getSessionTypeColor(session.sessionType),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: ALUColors.textGray,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Helpers.formatDateWithDay(session.date),
                    style: TextStyle(color: ALUColors.textGray, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: ALUColors.textGray),
                  const SizedBox(width: 8),
                  Text(
                    '${Helpers.formatTime(session.startTime)} - ${Helpers.formatTime(session.endTime)}',
                    style: TextStyle(color: ALUColors.textGray, fontSize: 14),
                  ),
                  if (session.location != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: ALUColors.textGray,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      session.location!,
                      style: TextStyle(color: ALUColors.textGray, fontSize: 14),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: session.isPresent
                            ? ALUColors.successGreen.withOpacity(0.2)
                            : ALUColors.warningRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            session.isPresent
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 18,
                            color: session.isPresent
                                ? ALUColors.successGreen
                                : ALUColors.warningRed,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            session.isPresent ? 'Present' : 'Absent',
                            style: TextStyle(
                              color: session.isPresent
                                  ? ALUColors.successGreen
                                  : ALUColors.warningRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        toggleAttendance(session);
                      });
                    },
                    icon: Icon(
                      session.isPresent ? Icons.toggle_on : Icons.toggle_off,
                      size: 32,
                      color: session.isPresent
                          ? ALUColors.successGreen
                          : ALUColors.textGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSessionOptions(BuildContext context, Session session, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ALUColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: ALUColors.accentYellow),
              title: const Text(
                'Edit Session',
                style: TextStyle(color: ALUColors.textWhite),
              ),
              onTap: () {
                Navigator.pop(context);
                _showEditSessionDialog(context, session, index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: ALUColors.warningRed),
              title: const Text(
                'Delete Session',
                style: TextStyle(color: ALUColors.textWhite),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteSession(context, index);
              },
            ),
            ListTile(
              leading: Icon(
                session.isPresent ? Icons.toggle_off : Icons.toggle_on,
                color: ALUColors.infoBlue,
              ),
              title: Text(
                session.isPresent ? 'Mark as Absent' : 'Mark as Present',
                style: const TextStyle(color: ALUColors.textWhite),
              ),
              onTap: () {
                setState(() {
                  toggleAttendance(session);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSessionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    DateTime? selectedDate;
    String? startTime;
    String? endTime;
    String sessionType = 'Class';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: ALUColors.cardBackground,
          title: const Text(
            'Add New Session',
            style: TextStyle(color: ALUColors.textWhite),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: ALUColors.textWhite),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: ALUColors.textGray),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.textGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.accentYellow),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : Helpers.formatDateWithDay(selectedDate!),
                    style: TextStyle(color: ALUColors.textGray),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: ALUColors.accentYellow,
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          startTime ?? 'Start Time',
                          style: TextStyle(color: ALUColors.textGray),
                        ),
                        trailing: const Icon(
                          Icons.access_time,
                          color: ALUColors.accentYellow,
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setDialogState(() {
                              startTime =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          endTime ?? 'End Time',
                          style: TextStyle(color: ALUColors.textGray),
                        ),
                        trailing: const Icon(
                          Icons.access_time,
                          color: ALUColors.accentYellow,
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setDialogState(() {
                              endTime =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  style: const TextStyle(color: ALUColors.textWhite),
                  decoration: InputDecoration(
                    labelText: 'Location (Optional)',
                    labelStyle: TextStyle(color: ALUColors.textGray),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.textGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.accentYellow),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: sessionType,
                  dropdownColor: ALUColors.cardBackground,
                  style: const TextStyle(color: ALUColors.textWhite),
                  decoration: InputDecoration(
                    labelText: 'Session Type',
                    labelStyle: TextStyle(color: ALUColors.textGray),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.textGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.accentYellow),
                    ),
                  ),
                  items:
                      ['Class', 'Mastery Session', 'Study Group', 'PSL Meeting']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => sessionType = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: ALUColors.textGray),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ALUColors.accentYellow,
                foregroundColor: ALUColors.primaryDark,
              ),
              onPressed: () {
                final errors = validateSession(
                  title: titleController.text,
                  date: selectedDate,
                  startTime: startTime,
                  endTime: endTime,
                  sessionType: sessionType,
                );

                if (errors.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errors.values.first),
                      backgroundColor: ALUColors.warningRed,
                    ),
                  );
                  return;
                }

                final newSession = Session(
                  title: titleController.text,
                  date: selectedDate!,
                  startTime: startTime!,
                  endTime: endTime!,
                  location: locationController.text.isEmpty
                      ? null
                      : locationController.text,
                  sessionType: sessionType,
                  isPresent: false,
                );

                addSession(newSession);
                setState(() {});
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session added successfully'),
                    backgroundColor: ALUColors.successGreen,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSessionDialog(
    BuildContext context,
    Session session,
    int index,
  ) {
    final titleController = TextEditingController(text: session.title);
    final locationController = TextEditingController(
      text: session.location ?? '',
    );
    DateTime selectedDate = session.date;
    String startTime = session.startTime;
    String endTime = session.endTime;
    String sessionType = session.sessionType;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: ALUColors.cardBackground,
          title: const Text(
            'Edit Session',
            style: TextStyle(color: ALUColors.textWhite),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: ALUColors.textWhite),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: ALUColors.textGray),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.textGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.accentYellow),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    Helpers.formatDateWithDay(selectedDate),
                    style: TextStyle(color: ALUColors.textGray),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: ALUColors.accentYellow,
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          startTime,
                          style: TextStyle(color: ALUColors.textGray),
                        ),
                        trailing: const Icon(
                          Icons.access_time,
                          color: ALUColors.accentYellow,
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: int.parse(startTime.split(':')[0]),
                              minute: int.parse(startTime.split(':')[1]),
                            ),
                          );
                          if (time != null) {
                            setDialogState(() {
                              startTime =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          endTime,
                          style: TextStyle(color: ALUColors.textGray),
                        ),
                        trailing: const Icon(
                          Icons.access_time,
                          color: ALUColors.accentYellow,
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: int.parse(endTime.split(':')[0]),
                              minute: int.parse(endTime.split(':')[1]),
                            ),
                          );
                          if (time != null) {
                            setDialogState(() {
                              endTime =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  style: const TextStyle(color: ALUColors.textWhite),
                  decoration: InputDecoration(
                    labelText: 'Location (Optional)',
                    labelStyle: TextStyle(color: ALUColors.textGray),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.textGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.accentYellow),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: sessionType,
                  dropdownColor: ALUColors.cardBackground,
                  style: const TextStyle(color: ALUColors.textWhite),
                  decoration: InputDecoration(
                    labelText: 'Session Type',
                    labelStyle: TextStyle(color: ALUColors.textGray),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.textGray),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ALUColors.accentYellow),
                    ),
                  ),
                  items:
                      ['Class', 'Mastery Session', 'Study Group', 'PSL Meeting']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => sessionType = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: ALUColors.textGray),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ALUColors.accentYellow,
                foregroundColor: ALUColors.primaryDark,
              ),
              onPressed: () {
                final errors = validateSession(
                  title: titleController.text,
                  date: selectedDate,
                  startTime: startTime,
                  endTime: endTime,
                  sessionType: sessionType,
                );

                if (errors.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errors.values.first),
                      backgroundColor: ALUColors.warningRed,
                    ),
                  );
                  return;
                }

                final updatedSession = Session(
                  title: titleController.text,
                  date: selectedDate,
                  startTime: startTime,
                  endTime: endTime,
                  location: locationController.text.isEmpty
                      ? null
                      : locationController.text,
                  sessionType: sessionType,
                  isPresent: session.isPresent,
                );

                editSession(index, updatedSession);
                setState(() {});
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session updated successfully'),
                    backgroundColor: ALUColors.successGreen,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSession(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ALUColors.cardBackground,
        title: const Text(
          'Delete Session',
          style: TextStyle(color: ALUColors.textWhite),
        ),
        content: const Text(
          'Are you sure you want to delete this session?',
          style: TextStyle(color: ALUColors.textGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: ALUColors.textGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ALUColors.warningRed,
              foregroundColor: ALUColors.textWhite,
            ),
            onPressed: () {
              deleteSession(index);
              setState(() {});
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session deleted successfully'),
                  backgroundColor: ALUColors.warningRed,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
