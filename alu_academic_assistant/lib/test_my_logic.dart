import 'logic/schedule_logic.dart';
import 'models/session.dart';

void main() {
  print('testing stuff\n');
  
  allSessions.clear();
  
  // adding some test sessions
  Session s1 = Session(
    title: 'Mobile Dev',
    date: DateTime.now(),
    startTime: '09:00',
    endTime: '11:00',
    sessionType: 'Class',
  );
  
  Session s2 = Session(
    title: 'Study Group',
    date: DateTime.now(),
    startTime: '14:00',
    endTime: '16:00',
    location: 'Library',
    sessionType: 'Study Group',
  );
  
  addSession(s1);
  addSession(s2);
  print('added ${allSessions.length} sessions\n');
  
  // check todays sessions
  var today = getTodaysSessions(DateTime.now());
  print('today: ${today.length} sessions');
  for (var s in today) {
    print('  ${s.title} at ${s.startTime}');
  }
  print('');
  
  // attendance test
  s1.isPresent = true;
  print('attendance: ${calculateAttendance().toStringAsFixed(1)}%');
  print('below 75? ${isBelowThreshold()}\n');
  
  // test validation with bad inputs
  var errors = validateSession(
    title: '',
    date: null,
    startTime: '10:00',
    endTime: '09:00', // wrong
    sessionType: 'Invalid',
  );
  print('found ${errors.length} errors:');
  errors.forEach((k, v) => print('  $k: $v'));
  
  print('\ndone testing');
}