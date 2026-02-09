import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/assignment.dart';
import '../models/session.dart';
import '../logic/schedule_logic.dart';
import '../utils/helpers.dart';

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
    _initializeSampleData();
  }

  void _initializeSampleData() {
    if (allSessions.isEmpty) {
      allSessions.addAll([
        Session(
          title: 'Mobile App Development',
          date: DateTime.now(),
          startTime: '09:00',
          endTime: '11:00',
          location: 'Lab 3',
          sessionType: 'Lecture',
          isPresent: true,
        ),
        Session(
          title: 'Software Engineering',
          date: DateTime.now(),
          startTime: '14:00',
          endTime: '16:00',
          location: 'Room 201',
          sessionType: 'Tutorial',
          isPresent: true,
        ),
        Session(
          title: 'Data Structures',
          date: DateTime.now().subtract(const Duration(days: 1)),
          startTime: '10:00',
          endTime: '12:00',
          location: 'Lab 1',
          sessionType: 'Lecture',
          isPresent: false,
        ),
      ]);
    }
  }

  List<Assignment> _getUpcomingAssignments() {
    final now = DateTime.now();
    return _assignments.where((assignment) {
      if (assignment.isCompleted) return false;
      return Helpers.isWithinNextSevenDays(assignment.dueDate);
    }).toList()..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  int _getPendingAssignmentsCount() {
    return _assignments.where((a) => !a.isCompleted).length;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final academicWeek = Helpers.getAcademicWeek(today);
    final todaysSessions = getTodaysSessions(today);
    final upcomingAssignments = _getUpcomingAssignments();
    final attendancePercentage = calculateAttendance();
    final pendingCount = _getPendingAssignmentsCount();

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
              errorBuilder: (context, error, stackTrace) {
                return Container(color: ALUColors.backgroundDark);
              },
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
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCourseSelector(),
                  const SizedBox(height: 16),
                  _buildDateHeader(today, academicWeek),
                  const SizedBox(height: 20),
                  _buildStatsCards(pendingCount, attendancePercentage),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Today\'s Classes'),
                  const SizedBox(height: 12),
                  _buildTodaysClasses(todaysSessions),
                  const SizedBox(height: 24),
                  _buildSectionHeader('ASSIGNMENT'),
                  const SizedBox(height: 12),
                  _buildAssignmentsList(upcomingAssignments),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseSelector() {
    return MouseRegion(
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
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: ALUColors.textWhite,
          ),
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
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime today, int week) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
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
            'Academic Week $week',
            style: TextStyle(color: ALUColors.textGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int pendingCount, double attendance) {
    final totalSessionsCount = allSessions.length;
    final presentCount = allSessions.where((s) => s.isPresent).length;
    final coreFailures = totalSessionsCount - presentCount;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            number: '$pendingCount',
            label: 'Actual\nProjects',
            color: ALUColors.cardBackground,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            number: '$coreFailures',
            label: 'Core\nfailures',
            color: ALUColors.cardBackground,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            number: '${_getUpcomingAssignments().length}',
            label: 'Upcoming\nAssessm',
            color: ALUColors.cardBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String number,
    required String label,
    required Color color,
  }) {
    return _HoverableCard(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
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
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: ALUColors.textWhite,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTodaysClasses(List<Session> sessions) {
    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ALUColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No classes scheduled for today',
            style: TextStyle(color: ALUColors.textGray, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: sessions.map((session) => _buildClassCard(session)).toList(),
    );
  }

  Widget _buildClassCard(Session session) {
    return _HoverableCard(
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
                    session.title,
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
                        '${Helpers.formatTime(session.startTime)} - ${Helpers.formatTime(session.endTime)}',
                        style: TextStyle(
                          color: ALUColors.textGray,
                          fontSize: 12,
                        ),
                      ),
                      if (session.location != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: ALUColors.textGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          session.location!,
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
                color: session.sessionType == 'Lecture'
                    ? ALUColors.infoBlue.withOpacity(0.2)
                    : ALUColors.accentYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                session.sessionType,
                style: TextStyle(
                  color: session.sessionType == 'Lecture'
                      ? ALUColors.infoBlue
                      : ALUColors.accentYellow,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsList(List<Assignment> assignments) {
    if (assignments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ALUColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No assignments due in the next 7 days',
            style: TextStyle(color: ALUColors.textGray, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: assignments
          .map((assignment) => _buildAssignmentCard(assignment))
          .toList(),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final daysUntil = Helpers.daysUntil(assignment.dueDate);
    final isUrgent = daysUntil <= 2;

    return _HoverableCard(
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
                    assignment.title,
                    style: const TextStyle(
                      color: ALUColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Helpers.formatDueDate(assignment.dueDate),
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

class _HoverableCard extends StatefulWidget {
  final Widget child;
  final Color? glowColor;

  const _HoverableCard({required this.child, this.glowColor});

  @override
  State<_HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<_HoverableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (widget.glowColor ?? ALUColors.accentYellow)
                      .withOpacity(0.4 * _animation.value),
                  blurRadius: 20 * _animation.value,
                  spreadRadius: 2 * _animation.value,
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}
