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
