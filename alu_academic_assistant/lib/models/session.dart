// session class
class Session {
  String title;
  DateTime date;
  String startTime;
  String endTime;
  String? location; //can be null
  String sessionType;
  bool isPresent; 
  
  Session({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.sessionType,
    this.isPresent = false,
  });
}
// check if this session is today
  bool isToday(DateTime checkDate) {
    return date.year == checkDate.year &&
           date.month == checkDate.month &&
           date.day == checkDate.day;
  }
  
  // check if session is this week
  bool isThisWeek(DateTime checkDate) {
    // get start of week which is Monday
    DateTime weekStart = checkDate.subtract(Duration(days: checkDate.weekday - 1));
    DateTime weekEnd = weekStart.add(Duration(days: 6));
    
    // check if date is between start and end
    return date.isAfter(weekStart.subtract(Duration(days: 1))) && 
           date.isBefore(weekEnd.add(Duration(days: 1)));
  }