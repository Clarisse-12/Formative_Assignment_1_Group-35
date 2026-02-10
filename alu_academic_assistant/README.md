# ALU Academic Assistant

A comprehensive Flutter mobile application designed to help African Leadership University (ALU) students manage their academic responsibilities. The app assists students in tracking assignments, scheduling academic sessions, monitoring attendance, and maintaining overall academic engagement throughout the semester.

## Project Overview

The ALU Academic Assistant is a personal academic management tool that integrates three core functionalities:
- **Dashboard**: Real-time overview of academic status and commitments
- **Assignment Management**: Create, track, and manage coursework
- **Schedule Management**: Plan academic sessions and track attendance



## Getting Started

### Prerequisites
- Flutter SDK (version 3.0 or higher)
- Dart (included with Flutter)
- An IDE (VS Code, Android Studio, or Xcode)
- Android Emulator or iOS Simulator (or a physical device)

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd alu_academic_assistant
   ```

2. **Install dependencies**
   
   flutter pub get
   

3. **Run the application**

   flutter run


## Component Documentation

### Dashboard Module

The Dashboard provides a comprehensive real-time overview of academic status, commitments, and performance metrics. It serves as the central hub for monitoring assignments, attendance, and scheduled sessions.

#### Files Included
- **`lib/screens/dashboard_screen.dart`** - Main dashboard interface
- **`lib/utils/helpers.dart`** - Helper utilities for date/time formatting
- **`lib/logic/schedule_logic.dart`** - Session management logic
- **`lib/widgets/hoverable_card.dart`** - Interactive card widget

#### Dashboard Features

##### 1. Date & Academic Week Display
Displays current date with day of week and calculates academic week number based on term start date.

```dart
// Helper method to calculate academic week
static int getAcademicWeek(DateTime currentDate) {
  DateTime termStart = DateTime(2026, 1, 5);
  int daysDifference = currentDate.difference(termStart).inDays;
  int weekNumber = (daysDifference / 7).floor() + 1;
  if (weekNumber < 1) return 1;
  if (weekNumber > 15) return 15;
  return weekNumber;
}

// Display implementation
Text(
  Helpers.formatDateWithDay(today), // "Monday, Feb 10"
  style: const TextStyle(
    color: ALUColors.textWhite,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),
Text(
  'Academic Week ${Helpers.getAcademicWeek(today)}', // "Academic Week 6"
  style: TextStyle(color: ALUColors.textGray, fontSize: 14),
),
```

##### 2. Course Filter Dropdown
Filter dashboard content by selecting specific courses or view all courses.

```dart
Widget _buildDropdown() => Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  decoration: BoxDecoration(
    color: ALUColors.cardBackground,
    borderRadius: BorderRadius.circular(8),
  ),
  child: DropdownButton<String>(
    value: 'All Selected Courses',
    items: const [
      DropdownMenuItem(value: 'All Selected Courses', child: Text('All Selected Courses')),
      DropdownMenuItem(value: 'Mobile Development', child: Text('Mobile Development')),
      DropdownMenuItem(value: 'Software Engineering', child: Text('Software Engineering')),
    ],
    onChanged: (value) {
      // Filter logic here
    },
  ),
);
```

##### 3. Statistics Cards
Three key metrics displayed in a row:
- **Actual Projects**: Count of pending assignments
- **Core Failures**: Count of missed sessions
- **Upcoming Assessments**: Assignments due within 7 days

```dart
Widget _buildStats() {
  final pending = _assignments.where((a) => !a.isCompleted).length;
  final missed = allSessions.where((s) => !s.isPresent).length;
  final upcoming = _assignments
      .where((a) => !a.isCompleted && Helpers.isWithinNextSevenDays(a.dueDate))
      .length;

  return Row(
    children: [
      Expanded(child: _buildStatCard('$pending', 'Actual\nProjects')),
      const SizedBox(width: 12),
      Expanded(child: _buildStatCard('$missed', 'Core\nfailures')),
      const SizedBox(width: 12),
      Expanded(child: _buildStatCard('$upcoming', 'Upcoming\nAssessm')),
    ],
  );
}
```

##### 4. Attendance Tracking
Visual attendance indicator with percentage calculation, present/total session ratio, and status alerts.

**Features:**
- Real-time attendance percentage calculation
- Color-coded status: Green (≥75% - Good), Red (<75% - Below threshold)
- Visual warning indicators for at-risk students
- Shows present sessions vs total sessions

```dart
// Attendance calculation logic
double calculateAttendance() {
  if (allSessions.isEmpty) return 0.0;
  int present = allSessions.where((s) => s.isPresent).length;
  return (present / allSessions.length) * 100;
}

bool isBelowThreshold() {
  return calculateAttendance() < 75.0;
}

// Attendance card display
Widget _buildAttendanceCard(double attendance, bool isBelowLimit) => Container(
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
        isBelowLimit ? Icons.warning_amber_rounded : Icons.check_circle,
        color: isBelowLimit ? ALUColors.warningRed : ALUColors.successGreen,
        size: 32,
      ),
      Text(
        '${attendance.toStringAsFixed(1)}%',
        style: TextStyle(
          color: isBelowLimit ? ALUColors.warningRed : ALUColors.successGreen,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Status badge
      Container(
        child: Text(
          isBelowLimit ? 'Below 75%' : 'Good',
          style: TextStyle(
            color: isBelowLimit ? ALUColors.warningRed : ALUColors.successGreen,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  ),
);
```

##### 5. Today's Classes
Displays all scheduled sessions for the current day with time, location, and session type.

```dart
// Get today's sessions from schedule logic
List<Session> getTodaysSessions(DateTime today) {
  List<Session> result = allSessions
      .where((session) => session.isToday(today))
      .toList();
  
  // Sort by start time
  result.sort((a, b) => a.startTime.compareTo(b.startTime));
  return result;
}

// Session card display
Widget _buildSessionCard(Session s) => Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: ALUColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      // Color indicator bar
      Container(
        width: 4,
        height: 50,
        decoration: BoxDecoration(
          color: ALUColors.accentYellow,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Row(
              children: [
                Icon(Icons.access_time, size: 14),
                Text('${Helpers.formatTime(s.startTime)} - ${Helpers.formatTime(s.endTime)}'),
                Icon(Icons.location_on, size: 14),
                Text(s.location ?? ''),
              ],
            ),
          ],
        ),
      ),
      // Session type badge
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getSessionTypeColor(s.sessionType).withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(s.sessionType, style: TextStyle(fontSize: 11)),
      ),
    ],
  ),
);
```

**Session Type Color Coding:**
```dart
Color _getSessionTypeColor(String sessionType) {
  switch (sessionType) {
    case 'Class': return ALUColors.infoBlue;
    case 'Mastery Session': return ALUColors.accentYellow;
    case 'Study Group': return ALUColors.successGreen;
    case 'PSL Meeting': return Color(0xFFB794F4); // Purple
    default: return ALUColors.textGray;
  }
}
```

##### 6. Upcoming Assignments
Shows assignments due within the next 7 days with urgency indicators.

```dart
// Filter upcoming assignments
final upcoming = _assignments
    .where((a) => !a.isCompleted && Helpers.isWithinNextSevenDays(a.dueDate))
    .toList()
  ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

// Check if within 7 days
static bool isWithinNextSevenDays(DateTime date) {
  final daysUntilDate = daysUntil(date);
  return daysUntilDate >= 0 && daysUntilDate <= 7;
}

// Assignment card with urgency indicator
Widget _buildAssignmentCard(Assignment a) {
  final isUrgent = Helpers.daysUntil(a.dueDate) <= 2;
  
  return Container(
    decoration: BoxDecoration(
      color: ALUColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isUrgent
            ? ALUColors.warningRed.withOpacity(0.5)  // Red border if urgent
            : ALUColors.textGray.withOpacity(0.2),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(a.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Text(
          Helpers.formatDueDate(a.dueDate), // "Due in 2 days" or "Overdue"
          style: TextStyle(
            color: isUrgent ? ALUColors.warningRed : ALUColors.textGray,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
```

##### 7. Visual Design & User Experience
- **Background**: Overlay gradient on student background image
- **Hoverable Cards**: Interactive feedback on card hover
- **Pull-to-Refresh**: Swipe down to refresh dashboard data
- **Color-Coded Elements**: Status-based color indicators throughout

```dart
// Background with gradient overlay
Stack(
  children: [
    Positioned.fill(
      child: Image.asset(
        'assets/images/students_background.jpg',
        fit: BoxFit.cover,
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
    // Dashboard content
  ],
);

// Pull-to-refresh functionality
RefreshIndicator(
  onRefresh: () async => setState(() {}),
  child: SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: /* Dashboard content */,
  ),
);
```

#### Helper Utilities

**Date & Time Formatting:**
```dart
// Format examples
Helpers.formatDateWithDay(DateTime.now());    // "Monday, Feb 10"
Helpers.formatDateLong(DateTime.now());       // "February 10, 2026"
Helpers.formatDateShort(DateTime.now());      // "Feb 10"
Helpers.formatTime("14:30");                  // "2:30 PM"
Helpers.getDayOfWeek(DateTime.now());         // "Monday"

// Date calculations
Helpers.daysUntil(dueDate);                   // Days until target date
Helpers.isToday(date);                        // Check if date is today
Helpers.isWithinNextSevenDays(date);          // Check if within 7 days
```

**Attendance Status:**
```dart
Map<String, dynamic> getAttendanceStatus(double percentage) {
  if (percentage >= 75) {
    return {'status': 'Good', 'color': 0xFF28A745, 'message': 'Keep up the good work!'};
  } else if (percentage >= 60) {
    return {'status': 'Warning', 'color': 0xFFFDB827, 'message': 'Attendance needs more work'};
  } else {
    return {'status': 'Critical', 'color': 0xFFDC3545, 'message': 'AT RISK - Attendance is not good'};
  }
}
```

---

### Assignment Creation Module (Phillip's Component)

The assignment creation module provides a comprehensive interface for students to add and edit assignments with full form validation and intuitive date/priority selection.

#### Files Included
- **`lib/models/assignment.dart`** - Assignment data model
- **`lib/screens/add_assignment_screen.dart`** - Add/Edit assignment interface

#### Assignment Model Architecture

The `Assignment` class is the core data structure that represents a single academic assignment.

**Key Properties:**
```dart
- id (String): Unique identifier for persistence and updates
- title (String): Assignment name/description [REQUIRED]
- dueDate (DateTime): When the assignment is due [REQUIRED]
- courseName (String): Associated course identifier [REQUIRED]
- priority (String): Assignment importance level {High, Medium, Low}
- isCompleted (bool): Completion status tracking
- createdAt (DateTime): Timestamp of assignment creation
```

**Key Methods:**
- `copyWith()`: Creates modified copies following immutability patterns
- `toJson()`: Serializes assignment data for storage
- `fromJson()`: Deserializes assignment data from storage
- `toString()`, `==`, `hashCode`: Standard Dart object methods

#### Add/Edit Assignment Form Features

**Form Fields:**
1. **Assignment Title** (Required)
   - Text input field with 3-100 character validation
   - Real-time validation feedback
   - Placeholder: "e.g., Essay on Climate Change"

2. **Course Name** (Required)
   - Text input field for course identification
   - Minimum 2 characters validation
   - Placeholder: "e.g., Environmental Science 201"

3. **Due Date** (Required)
   - Interactive date picker
   - Prevents selection of past dates
   - 365-day forward planning window
   - Displays selected date in readable format (MMM dd, yyyy)

4. **Priority Level** (Optional)
   - Dropdown selection: High, Medium, Low
   - Color-coded indicators:
     - **High**: Red (#DC3545) - Critical urgency
     - **Medium**: Gold/Yellow (#FDB827) - Standard priority
     - **Low**: Green (#28A745) - Lower urgency
   - Default: Medium

**Validation Logic:**
```
✓ Title: Not empty, 3-100 characters
✓ Course: Not empty, minimum 2 characters
✓ Due Date: Selected, not in the past
✓ Priority: Auto-validated dropdown
```

**User Experience Features:**
- Consistent ALU color branding throughout
- Material Design compliance
- Intuitive icon indicators for each field
- Responsive design with proper spacing
- Submit button shows contextual label ("Create Assignment" or "Update Assignment")
- Back navigation support with unsaved data handling

#### Integration Example

To use the assignment creation screen in the Assignments page:

```dart
// Navigate to add assignment screen
final newAssignment = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AddAssignmentScreen(),
  ),
);

// Handle returned assignment
if (newAssignment != null) {
  setState(() {
    assignments.add(newAssignment);
  });
}
```

To edit an existing assignment:

```dart
final updatedAssignment = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddAssignmentScreen(
      assignmentToEdit: existingAssignment,
    ),
  ),
);

if (updatedAssignment != null) {
  setState(() {
    // Update assignments list
  });
}
```

#### Data Persistence Ready

The Assignment model is designed to integrate with local storage solutions:

**JSON Storage Example:**
```dart
// Save to SharedPreferences
final jsonString = jsonEncode(assignment.toJson());
await prefs.setString('assignment_${assignment.id}', jsonString);

// Load from SharedPreferences
final storedJson = prefs.getString('assignment_${assignment.id}');
final assignment = Assignment.fromJson(jsonDecode(storedJson));
```

**SQLite Integration Ready:**
The model's JSON serialization methods enable seamless SQLite integration for advanced data persistence.

## Schedule & Attendance Logic (Veronicah)

**Files:**
- `lib/models/session.dart` - Session data model
- `lib/logic/schedule_logic.dart` - All schedule and attendance logic

**Session Model:**
Created a Session class to store session details (title, date, times, 
location, type) and attendance status. Added helper methods isToday() 
and isThisWeek() for filtering.

**Attendance System:**
- Calculates attendance percentage by counting present sessions
- Triggers warning when attendance drops below 75%
- Maintains complete attendance history

**Schedule Management Functions:**
- Add, edit, and delete sessions
- Filter sessions by day or week
- Sort sessions chronologically
- Validate form inputs before creating sessions

**Integration:**
The getDashboardData() function packages all schedule and attendance 
data for the dashboard screen.

#### Code Quality & Best Practices

**Comprehensive Documentation:**
- Class-level documentation explaining purpose and usage
- Method documentation with parameter descriptions and examples
- Inline comments explaining validation logic and UI decisions
- Clear variable naming following Dart conventions

**Design Patterns Used:**
- Factory pattern (fromJson constructor)
- Copy-on-write pattern (copyWith method)
- Immutable design principles
- Consistent error handling in validators

**Responsive Design:**
- Uses % Formative_Assignment_1_Group-35 workspace-relative sizing
- Proper padding and spacing conventions
- ScrollView for form overflow prevention
- Touch-friendly button sizes (minimum 48x48 dp)

## Color Scheme & Branding

The application uses ALU's official color palette:

```dart
// Primary Colors
- Primary Dark: #001F3F (Navy Blue)
- Accent Yellow: #FDB827 (Gold)
- Warning Red: #DC3545 (Danger/Alerts)

// Text Colors
- White: #FFFFFF
- Gray: #B0B0B0

// Status Colors
- Success Green: #28A745
- Info Blue: #17A2B8
```

## Development Guidelines

### Adding New Features
1. Maintain folder structure separation (models, screens, constants)
2. Use ALU color constants for consistency
3. Add comprehensive inline comments
4. Follow Dart style guide conventions
5. Implement proper error handling and validation

### Form Field Development
1. Use consistent `_buildFormSection()` helper method
2. Implement input decoration via `_buildInputDecoration()`
3. Add validators for required fields
4. Provide meaningful error messages
5. Clear input focus and validate on submit

### Testing
When implementing local storage:
```bash
# Run Flutter tests
flutter test

# Run app on emulator
flutter run

# Build release version
flutter build apk  # Android
flutter build ios  # iOS
```

## Future Enhancements

- SQLite implementation for advanced persistence
- Push notifications for assignment reminders
- Cloud synchronization across devices
- User authentication system
- Sharing assignments with classmates
- Integration with ALU calendar system

## Resources & Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)
- [intl Package (Date Formatting)](https://pub.dev/packages/intl)

## License

This project is created for educational purposes at African Leadership University.

## Contributing

Each team member should work on their assigned component:
- **Phillip**: Assignment Creation (Model & Form)
- **[Team Member 2]**: [Component]
- **[Team Member 3]**: [Component]

All contributions must follow the code quality standards outlined in the rubric.
