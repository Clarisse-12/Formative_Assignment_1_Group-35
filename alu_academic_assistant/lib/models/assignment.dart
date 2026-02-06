/// Assignment Model
/// 
/// This class represents an academic assignment with all necessary fields
/// for tracking and managing coursework. It includes properties for the
/// assignment title, due date, course name, priority level, and completion status.
/// 
/// The model is designed to be serializable for potential local storage
/// implementation (shared_preferences or SQLite).

class Assignment {
  /// Unique identifier for the assignment
  /// Used for updating and deleting assignments from storage
  final String id;
  
  /// Title of the assignment - required field
  /// Should be descriptive and meaningful (e.g., "Essay on Climate Change")
  final String title;
  
  /// Due date of the assignment
  /// Stored as DateTime to enable sorting and comparison operations
  final DateTime dueDate;
  
  /// Name of the course this assignment belongs to
  /// Helps organize assignments by course context
  final String courseName;
  
  /// Priority level of the assignment
  /// Can be 'High', 'Medium', or 'Low' to help students prioritize workload
  final String priority;
  
  /// Completion status of the assignment
  /// true means the assignment is marked as completed
  /// false means the assignment is pending
  bool isCompleted;
  
  /// Timestamp when the assignment was created
  /// Useful for tracking when assignments were added to the system
  final DateTime createdAt;

  /// Constructor for creating an Assignment instance
  /// 
  /// Parameters:
  /// - [id]: Unique identifier (can be generated from UUID or timestamp)
  /// - [title]: Assignment title (required)
  /// - [dueDate]: When the assignment is due (required)
  /// - [courseName]: Associated course name (required)
  /// - [priority]: Priority level - defaults to 'Medium' (optional)
  /// - [isCompleted]: Completion status - defaults to false (optional)
  /// - [createdAt]: Creation timestamp - defaults to current time (optional)
  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.courseName,
    this.priority = 'Medium',
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Creates a copy of this Assignment with modified fields
  /// 
  /// This method follows the immutability pattern and allows creating
  /// updated versions of assignments without modifying the original object.
  /// Useful when editing assignment details.
  /// 
  /// Example usage:
  /// ```dart
  /// var updatedAssignment = originalAssignment.copyWith(
  ///   isCompleted: true,
  ///   priority: 'High'
  /// );
  /// ```
  Assignment copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    String? courseName,
    String? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      courseName: courseName ?? this.courseName,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts Assignment object to JSON format
  /// 
  /// This method enables serialization of Assignment data to JSON,
  /// which is essential for storing data in local storage systems
  /// like shared_preferences or JSON files.
  /// 
  /// Returns a Map<String, dynamic> that can be encoded to JSON string
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'courseName': courseName,
      'priority': priority,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Factory constructor to create Assignment from JSON data
  /// 
  /// This method enables deserialization of JSON data back into Assignment objects,
  /// which is necessary when retrieving assignments from local storage.
  /// 
  /// Parameters:
  /// - [json]: Map containing JSON representation of Assignment
  /// 
  /// Returns a new Assignment instance with values from the JSON map
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      courseName: json['courseName'] as String,
      priority: json['priority'] as String? ?? 'Medium',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  /// Returns a string representation of the Assignment
  /// Useful for debugging and logging purposes
  @override
  String toString() {
    return 'Assignment(id: $id, title: $title, dueDate: $dueDate, courseName: $courseName, priority: $priority, isCompleted: $isCompleted)';
  }

  /// Checks equality between two Assignment objects
  /// Two assignments are equal if all their properties match
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Assignment &&
        other.id == id &&
        other.title == title &&
        other.dueDate == dueDate &&
        other.courseName == courseName &&
        other.priority == priority &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt;
  }

  /// Generates a hash code for the Assignment
  /// Enables Assignment objects to be used in hash-based collections
  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        dueDate.hashCode ^
        courseName.hashCode ^
        priority.hashCode ^
        isCompleted.hashCode ^
        createdAt.hashCode;
  }
}
