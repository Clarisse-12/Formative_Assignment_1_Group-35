import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/assignment.dart';

/// Add/Edit Assignment Screen
/// 
/// This screen provides a form interface for users to create new assignments
/// or edit existing ones. It includes input validation, date/time pickers,
/// and a priority selection dropdown.
/// 
/// The form validates:
/// - Title is not empty
/// - Course name is not empty
/// - Due date is selected and not in the past
/// 
/// Returns to the previous screen with the created/edited Assignment object.

class AddAssignmentScreen extends StatefulWidget {
  /// Optional assignment to edit - if null, the form will be for creating a new assignment
  final Assignment? assignmentToEdit;

  const AddAssignmentScreen({
    super.key,
    this.assignmentToEdit,
  });

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  /// Form key for validating the entire form
  /// Used to trigger validation and submit the form
  final _formKey = GlobalKey<FormState>();

  /// Text controller for the assignment title
  /// Manages user input for the assignment name field
  late TextEditingController _titleController;

  /// Text controller for the course name
  /// Manages user input for which course the assignment belongs to
  late TextEditingController _courseController;

  /// Selected due date for the assignment
  /// Initialized to tomorrow to encourage setting realistic deadlines
  late DateTime _selectedDueDate;

  /// Selected priority level for the assignment
  /// Can be 'High', 'Medium', or 'Low'
  /// Defaults to 'Medium' for new assignments
  late String _selectedPriority;

  /// Available priority options for the dropdown
  /// These represent common priority levels students might use
  static const List<String> _priorityOptions = ['High', 'Medium', 'Low'];

  /// Priority colors for visual distinction
  /// High = Red, Medium = Orange, Low = Green
  /// Helps users quickly identify assignment urgency
  static const Map<String, Color> _priorityColors = {
    'High': Color(0xFFDC3545),    // Red
    'Medium': Color(0xFFFDB827),  // Yellow/Gold
    'Low': Color(0xFF28A745),      // Green
  };

  @override
  void initState() {
    super.initState();

    // Initialize text controllers
    // If editing an existing assignment, pre-populate the fields
    if (widget.assignmentToEdit != null) {
      _titleController = TextEditingController(text: widget.assignmentToEdit!.title);
      _courseController = TextEditingController(text: widget.assignmentToEdit!.courseName);
      _selectedDueDate = widget.assignmentToEdit!.dueDate;
      _selectedPriority = widget.assignmentToEdit!.priority;
    } else {
      // For new assignments, initialize with empty controllers
      _titleController = TextEditingController();
      _courseController = TextEditingController();
      // Set due date to tomorrow by default
      _selectedDueDate = DateTime.now().add(const Duration(days: 1));
      _selectedPriority = 'Medium';
    }
  }

  @override
  void dispose() {
    /// Clean up text controllers to free memory
    /// This is important to prevent memory leaks in Flutter
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  /// Opens a date picker dialog to select the assignment due date
  /// 
  /// The date picker:
  /// - Shows a calendar interface
  /// - Prevents selecting dates in the past
  /// - Updates _selectedDueDate when a date is picked
  /// - Rebuilds the UI to show the selected date
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      // Don't allow selecting dates in the past
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        // Customize the date picker theme to match ALU colors
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ALUColors.accentYellow,
              onPrimary: Colors.black,
              surface: ALUColors.cardBackground,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    // Update the selected date if user picked a date
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  /// Validates the form and submits the assignment
  /// 
  /// Validation checks:
  /// 1. Title is provided (required)
  /// 2. Course name is provided (required)
  /// 3. Due date is set (required)
  /// 
  /// If all validations pass, creates/updates the Assignment object
  /// and returns it to the previous screen via Navigator.pop()
  void _submitForm() {
    // Validate all form fields against their validators
    if (_formKey.currentState!.validate()) {
      // Generate unique ID for new assignments
      // Use timestamp + random number for simple uniqueness
      final assignmentId = widget.assignmentToEdit?.id ??
          'assign_${DateTime.now().millisecondsSinceEpoch}';

      // Create a new Assignment object with form values
      final newAssignment = Assignment(
        id: assignmentId,
        title: _titleController.text.trim(),
        dueDate: _selectedDueDate,
        courseName: _courseController.text.trim(),
        priority: _selectedPriority,
        isCompleted: widget.assignmentToEdit?.isCompleted ?? false,
        createdAt: widget.assignmentToEdit?.createdAt,
      );

      // Return to previous screen with the created/edited assignment
      // The calling screen will receive this assignment via Navigator.pop()
      Navigator.pop(context, newAssignment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Use dark ALU blue background for consistency with app theme
      backgroundColor: ALUColors.primaryDark,
      appBar: AppBar(
        /// Display different titles based on whether editing or creating
        title: Text(
          widget.assignmentToEdit != null
              ? 'Edit Assignment'
              : 'Add New Assignment',
          style: const TextStyle(
            color: ALUColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: ALUColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ALUColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== TITLE FIELD =====
                // Required text input for the assignment title
                // Validates that a title is provided
                _buildFormSection(
                  label: 'Assignment Title',
                  child: TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: ALUColors.textWhite),
                    decoration: _buildInputDecoration(
                      hintText: 'e.g., Essay on Climate Change',
                      icon: Icons.assignment,
                    ),
                    // Validator ensures title is not empty
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an assignment title';
                      }
                      if (value.length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      if (value.length > 100) {
                        return 'Title must not exceed 100 characters';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ===== COURSE NAME FIELD =====
                // Required text input for the course this assignment belongs to
                // Helps organize assignments by course
                _buildFormSection(
                  label: 'Course Name',
                  child: TextFormField(
                    controller: _courseController,
                    style: const TextStyle(color: ALUColors.textWhite),
                    decoration: _buildInputDecoration(
                      hintText: 'e.g., Environmental Science 201',
                      icon: Icons.school,
                    ),
                    // Validator ensures course is not empty
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a course name';
                      }
                      if (value.length < 2) {
                        return 'Course name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ===== DUE DATE FIELD =====
                // Date picker field to select when the assignment is due
                // Prevents selecting dates in the past
                _buildFormSection(
                  label: 'Due Date',
                  child: GestureDetector(
                    onTap: () => _selectDueDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: ALUColors.cardLightBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ALUColors.accentYellow,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Display the selected due date
                          Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDueDate),
                            style: const TextStyle(
                              color: ALUColors.textWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Calendar icon to indicate this is a date picker
                          const Icon(
                            Icons.calendar_today,
                            color: ALUColors.accentYellow,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== PRIORITY DROPDOWN =====
                // Optional dropdown to set assignment priority level
                // Helps students prioritize their workload (High/Medium/Low)
                _buildFormSection(
                  label: 'Priority Level (Optional)',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: ALUColors.cardLightBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ALUColors.accentYellow,
                        width: 1.5,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedPriority,
                      isExpanded: true,
                      dropdownColor: ALUColors.cardLightBackground,
                      underline: const SizedBox(), // Remove default underline
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedPriority = newValue;
                          });
                        }
                      },
                      items: _priorityOptions.map((String priority) {
                        return DropdownMenuItem<String>(
                          value: priority,
                          child: Row(
                            children: [
                              // Show colored dot to indicate priority level
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _priorityColors[priority],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Priority label text
                              Text(
                                priority,
                                style: const TextStyle(
                                  color: ALUColors.textWhite,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ===== SUBMIT BUTTON =====
                // Button to create/update the assignment
                // Validates form before submission
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ALUColors.accentYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      widget.assignmentToEdit != null
                          ? 'Update Assignment'
                          : 'Create Assignment',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to build consistent form sections
  /// 
  /// Creates a section with a label and form field with consistent styling
  /// 
  /// Parameters:
  /// - [label]: The label text to display above the field
  /// - [child]: The form widget (TextFormField, DropdownButton, etc.)
  /// 
  /// Returns a Column widget with the label and child widget
  Widget _buildFormSection({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text in ALU gold color
        Text(
          label,
          style: const TextStyle(
            color: ALUColors.accentYellow,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Form field widget
        child,
      ],
    );
  }

  /// Helper method to build consistent input field decorations
  /// 
  /// Creates a consistent TextFormField decoration across all form fields
  /// with ALU color scheme and styling
  /// 
  /// Parameters:
  /// - [hintText]: Placeholder text to guide user input
  /// - [icon]: Icon to display inside the text field
  /// 
  /// Returns an InputDecoration object with consistent styling
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: ALUColors.textGray),
      prefixIcon: Icon(icon, color: ALUColors.accentYellow),
      filled: true,
      fillColor: ALUColors.cardLightBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ALUColors.accentYellow, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ALUColors.accentYellow, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ALUColors.accentYellow, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ALUColors.warningRed, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ALUColors.warningRed, width: 2),
      ),
      errorStyle: const TextStyle(color: ALUColors.warningRed),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
