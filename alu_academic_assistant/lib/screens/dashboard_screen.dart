import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/assignment.dart';
import '../models/session.dart';
import '../logic/schedule_logic.dart';
import '../utils/helpers.dart';
import '../widgets/hoverable_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Assignment> _assignments = [
    Assignment(
      id: '1',
      title: 'Quiz 1',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      courseName: 'Mobile Development',
      priority: 'High',
    ),
    Assignment(
      id: '2',
      title: 'Assignment 2',
      dueDate: DateTime(2026, 2, 26),
      courseName: 'Software Engineering',
      priority: 'Medium',
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (allSessions.isEmpty) {
      allSessions.addAll([
        Session(
          title: 'Mobile App Development',
          date: DateTime.now(),
          startTime: '09:00',
          endTime: '11:00',
          location: 'Lab 3',
          sessionType: 'Class',
          isPresent: true,
        ),
        Session(
          title: 'Software Engineering',
          date: DateTime.now(),
          startTime: '14:00',
          endTime: '16:00',
          location: 'Room 201',
          sessionType: 'Study Group',
          isPresent: true,
        ),
        Session(
          title: 'Data Structures',
          date: DateTime.now().subtract(const Duration(days: 1)),
          startTime: '10:00',
          endTime: '12:00',
          location: 'Lab 1',
          sessionType: 'Mastery Session',
          isPresent: false,
        ),
      ]);
    }
  }

  Color _getSessionTypeColor(String sessionType) {
    switch (sessionType) {
      case 'Class':
        return ALUColors.infoBlue;
      case 'Mastery Session':
        return ALUColors.accentYellow;
      case 'Study Group':
        return ALUColors.successGreen;
      case 'PSL Meeting':
        return Color(0xFFB794F4);
      default:
        return ALUColors.textGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final upcoming =
        _assignments
            .where(
              (a) => !a.isCompleted && Helpers.isWithinNextSevenDays(a.dueDate),
            )
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      backgroundColor: ALUColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: ALUColors.backgroundDark,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: ALUColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, size: 28),
            color: ALUColors.textWhite,
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/students_background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: ALUColors.backgroundDark),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ALUColors.backgroundDark.withOpacity(0.85),
                    ALUColors.backgroundDark.withOpacity(0.92),
                    ALUColors.backgroundDark.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Helpers.formatDateWithDay(today),
                          style: const TextStyle(
                            color: ALUColors.textWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Academic Week ${Helpers.getAcademicWeek(today)}',
                          style: TextStyle(
                            color: ALUColors.textGray,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStats(),
                  const SizedBox(height: 24),
                  _buildHeader('Today\'s Classes'),
                  const SizedBox(height: 12),
                  ...getTodaysSessions(today).isEmpty
                      ? [
                          _buildCard(
                            child: Center(
                              child: Text(
                                'No classes scheduled for today',
                                style: TextStyle(
                                  color: ALUColors.textGray,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ]
                      : getTodaysSessions(
                          today,
                        ).map((s) => _buildSessionCard(s)).toList(),
                  const SizedBox(height: 24),
                  _buildHeader('ASSIGNMENT'),
                  const SizedBox(height: 12),
                  ...upcoming.isEmpty
                      ? [
                          _buildCard(
                            child: Center(
                              child: Text(
                                'No assignments due in the next 7 days',
                                style: TextStyle(
                                  color: ALUColors.textGray,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ]
                      : upcoming.map((a) => _buildAssignmentCard(a)).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ALUColors.textGray.withOpacity(0.3)),
      ),
      child: DropdownButton<String>(
        value: 'All Selected Courses',
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: ALUColors.cardBackground,
        style: const TextStyle(color: ALUColors.textWhite, fontSize: 14),
        icon: const Icon(Icons.keyboard_arrow_down, color: ALUColors.textWhite),
        items: const [
          DropdownMenuItem(
            value: 'All Selected Courses',
            child: Text('All Selected Courses'),
          ),
          DropdownMenuItem(
            value: 'Mobile Development',
            child: Text('Mobile Development'),
          ),
          DropdownMenuItem(
            value: 'Software Engineering',
            child: Text('Software Engineering'),
          ),
        ],
        onChanged: (_) {},
      ),
    ),
  );

  Widget _buildCard({required Widget child, EdgeInsets? padding}) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ALUColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );

  Widget _buildHeader(String title) => Text(
    title,
    style: const TextStyle(
      color: ALUColors.textWhite,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _buildStats() {
    final pending = _assignments.where((a) => !a.isCompleted).length;
    final missed = allSessions.where((s) => !s.isPresent).length;
    final upcoming = _assignments
        .where(
          (a) => !a.isCompleted && Helpers.isWithinNextSevenDays(a.dueDate),
        )
        .length;
    final attendance = calculateAttendance();
    final isBelowLimit = isBelowThreshold();

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('$pending', 'Actual\nProjects')),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('$missed', 'Core\nfailures')),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('$upcoming', 'Upcoming\nAssessm')),
          ],
        ),
        const SizedBox(height: 12),
        _buildAttendanceCard(attendance, isBelowLimit),
      ],
    );
  }

  Widget _buildStatCard(String number, String label) => HoverableCard(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ALUColors.textGray.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: ALUColors.textWhite,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ALUColors.textGray,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildAttendanceCard(
    double attendance,
    bool isBelowLimit,
  ) => HoverableCard(
    child: Container(
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isBelowLimit
                  ? ALUColors.warningRed.withOpacity(0.2)
                  : ALUColors.successGreen.withOpacity(0.2),
            ),
            child: Center(
              child: Icon(
                isBelowLimit ? Icons.warning_amber_rounded : Icons.check_circle,
                color: isBelowLimit
                    ? ALUColors.warningRed
                    : ALUColors.successGreen,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance',
                  style: TextStyle(color: ALUColors.textGray, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${attendance.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isBelowLimit
                            ? ALUColors.warningRed
                            : ALUColors.successGreen,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${allSessions.where((s) => s.isPresent).length}/${allSessions.length}',
                        style: TextStyle(
                          color: ALUColors.textGray,
                          fontSize: 14,
                        ),
                      ),
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
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ALUColors.successGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Good',
                style: TextStyle(
                  color: ALUColors.successGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    ),
  );

  Widget _buildSessionCard(Session s) => HoverableCard(
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ALUColors.textGray.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: ALUColors.accentYellow,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.title,
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: ALUColors.textGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${Helpers.formatTime(s.startTime)} - ${Helpers.formatTime(s.endTime)}',
                      style: TextStyle(color: ALUColors.textGray, fontSize: 12),
                    ),
                    if (s.location != null) ...[
                      const SizedBox(width: 12),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: ALUColors.textGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        s.location!,
                        style: TextStyle(
                          color: ALUColors.textGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getSessionTypeColor(s.sessionType).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              s.sessionType,
              style: TextStyle(
                color: _getSessionTypeColor(s.sessionType),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildAssignmentCard(Assignment a) {
    final isUrgent = Helpers.daysUntil(a.dueDate) <= 2;
    return HoverableCard(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ALUColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUrgent
                ? ALUColors.warningRed.withOpacity(0.5)
                : ALUColors.textGray.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: const TextStyle(
                      color: ALUColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Helpers.formatDueDate(a.dueDate),
                    style: TextStyle(
                      color: isUrgent
                          ? ALUColors.warningRed
                          : ALUColors.textGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: ALUColors.textGray),
          ],
        ),
      ),
    );
  }
}
