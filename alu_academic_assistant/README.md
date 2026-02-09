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
