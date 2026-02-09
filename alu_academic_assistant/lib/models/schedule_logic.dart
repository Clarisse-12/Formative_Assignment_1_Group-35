import '../models/session.dart';

// store all sessions here
List<Session> allSessions = [];

// add new session
void addSession(Session session) {
  allSessions.add(session);
}

// edit session at index
void editSession(int index, Session updated) {
  if (index >= 0 && index < allSessions.length) {
    allSessions[index] = updated;
  }
}

// delete session
void deleteSession(int index) {
  if (index >= 0 && index < allSessions.length) {
    allSessions.removeAt(index);
  }
}
// get today's sessions
List<Session> getTodaysSessions(DateTime today) {
  List<Session> result = [];
  
  for (var session in allSessions) {
    if (session.isToday(today)) {
      result.add(session);
    }
  }
  
  // sort by time
  result.sort((a, b) => a.startTime.compareTo(b.startTime));
  return result;
}

// get this week's sessions
List<Session> getWeeklySessions(DateTime current) {
  List<Session> weekSessions = [];
  
  for (var session in allSessions) {
    if (session.isThisWeek(current)) {
      weekSessions.add(session);
    }
  }
  
  // sort by date then time
  weekSessions.sort((a, b) {
    int dateComp = a.date.compareTo(b.date);
    if (dateComp != 0) return dateComp;
    return a.startTime.compareTo(b.startTime);
  });
  
  return weekSessions;
}

// toggle attendance
void toggleAttendance(Session session) {
  session.isPresent = !session.isPresent;
}

// get attendance history
List<Session> getAttendanceHistory() {
  return List.from(allSessions);
}
// calculate attendance %
double calculateAttendance() {
  if (allSessions.isEmpty) return 0.0;
  
  int present = 0;
  for (var s in allSessions) {
    if (s.isPresent) {
      present++;
    }
  }
  
  return (present / allSessions.length) * 100;
}

// check if attendance is  below 75%
bool isBelowThreshold() {
  return calculateAttendance() < 75.0;
}
// validate session inputs this makes sure required fields are filled
Map<String, String> validateSession({
  required String title,
  DateTime? date,
  String? startTime,
  String? endTime,
  String? sessionType,
}) {
  Map<String, String> errors = {};
  
  // check title
  if (title.trim().isEmpty) {
    errors['title'] = 'Title is required';
  }
  
  // check date
  if (date == null) {
    errors['date'] = 'Please select a date';
  }
  
  // check start time
  if (startTime == null || startTime.isEmpty) {
    errors['startTime'] = 'Start time required';
  }
  
  // check end time
  if (endTime == null || endTime.isEmpty) {
    errors['endTime'] = 'End time required';
  }
  
  // validate times
  if (startTime != null && endTime != null) {
    if (startTime.compareTo(endTime) >= 0) {
      errors['time'] = 'End time must be after start time';
    }
  }
  
  // check session type
  List<String> validTypes = [
    'Class',
    'Mastery Session',
    'Study Group',
    'PSL Meeting'
  ];
  
  if (sessionType == null || !validTypes.contains(sessionType)) {
    errors['sessionType'] = 'Please select a valid session type';
  }
  
  return errors;
}
// get data for dashboard
Map<String, dynamic> getDashboardData(DateTime current) {
  return {
    'todaySessions': getTodaysSessions(current),
    'attendance': calculateAttendance(),
    'showWarning': isBelowThreshold(),
  };
}