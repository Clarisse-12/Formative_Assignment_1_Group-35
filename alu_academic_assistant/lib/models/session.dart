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