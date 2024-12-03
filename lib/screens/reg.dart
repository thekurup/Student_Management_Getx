// Import statements section - Setting up required packages and dependencies
import 'package:flutter/material.dart';
// What: Core Flutter framework import for UI components
// Why: Provides essential widgets and material design elements
// Interaction: Foundation for all visual elements in the app

import 'package:flutter/services.dart';
// What: Flutter's platform interaction services
// Why: Needed for input formatting and system-level operations
// Interaction: Used by text fields for input validation and formatting

import 'package:get/get.dart';
// What: GetX state management library import
// Why: Provides reactive state management and simplified navigation
// Interaction: Connects UI with RegistrationController for state updates

import 'package:image_picker/image_picker.dart';
// What: Image selection functionality import
// Why: Enables users to select images from gallery or take photos
// Interaction: Used in student photo selection feature

import '../controllers/registration_controller.dart';
// What: Custom controller import for registration logic
// Why: Contains all business logic and state management
// Interaction: Manages form data, validation, and database operations

// Custom Animated Button Widget Definition
class AnimatedCustomButton extends StatefulWidget {
  // What: Defines a reusable animated button component
  // Why: Creates consistent, interactive buttons throughout the app
  // Interaction: Used for form actions like submit and clear

  final String text;
  // What: Text displayed on the button
  // Why: Shows the button's purpose to users
  // Interaction: Changes dynamically based on button state (e.g., "Saving...")

  final VoidCallback onPressed;
  // What: Function to execute when button is pressed
  // Why: Defines button's behavior on interaction
  // Interaction: Triggers form submission or clearing

  final Color color;
  // What: Button's background color
  // Why: Provides visual distinction between different actions
  // Interaction: Helps users identify button types (green for save, red for clear)

  final Color textColor;
  // What: Color of button text
  // Why: Ensures text visibility and contrast
  // Interaction: Maintains readability against button background

  // Constructor with required parameters
  const AnimatedCustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);
  // What: Initializes button properties
  // Why: Sets up button configuration
  // Interaction: Called when creating new button instances

  @override
  State<AnimatedCustomButton> createState() => _AnimatedCustomButtonState();
  // What: Creates mutable state for button
  // Why: Manages button's animation state
  // Interaction: Controls button's visual feedback
}

// Button State Management Class
class _AnimatedCustomButtonState extends State<AnimatedCustomButton>
    with SingleTickerProviderStateMixin {
  // What: Manages button's animated state
  // Why: Handles animations and state changes
  // Interaction: Controls button's visual response to interactions

  late AnimationController _animationController;
  // What: Controls animation timing and progress
  // Why: Manages button press animation
  // Interaction: Coordinates scale and shadow animations

  late Animation<double> _scaleAnimation;
  // What: Defines button scale animation
  // Why: Creates pressing effect
  // Interaction: Makes button slightly smaller when pressed

  late Animation<double> _shadowAnimation;
  // What: Controls button shadow animation
  // Why: Adds depth effect during press
  // Interaction: Adjusts shadow to enhance 3D effect

  bool _isDisposed = false;
  // What: Tracks widget disposal state
  // Why: Prevents animation updates after disposal
  // Interaction: Helps prevent memory leaks

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // What: Sets up initial animations
    // Why: Prepares button for user interaction
    // Interaction: Called when button is first created
  }

  void _initializeAnimations() {
    // Animation Setup Section
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // What: Creates animation controller
    // Why: Manages timing of animations
    // Interaction: Controls all button animations

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // What: Defines scale animation values
    // Why: Creates smooth pressing effect
    // Interaction: Makes button scale down when pressed

    _shadowAnimation = Tween<double>(begin: 8.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // What: Defines shadow animation values
    // Why: Creates depth effect
    // Interaction: Adjusts shadow during press
  }

  // Button Press Handlers
  void _handleTapDown(_) {
    if (mounted && !_isDisposed) {
      _animationController.forward();
    }
    // What: Handles button press down
    // Why: Starts press animation
    // Interaction: Triggers when user presses button
  }

  void _handleTapUp(_) async {
    if (mounted && !_isDisposed) {
      await _animationController.reverse();
      if (mounted) {
        widget.onPressed();
      }
    }
    // What: Handles button release
    // Why: Reverses animation and triggers action
    // Interaction: Executes button's onPressed function
  }

  void _handleTapCancel() {
    if (mounted && !_isDisposed) {
      _animationController.reverse();
    }
    // What: Handles cancelled press
    // Why: Resets button state
    // Interaction: Called when press is interrupted
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_animationController.status != AnimationStatus.dismissed) {
      _animationController.stop();
    }
    _animationController.dispose();
    super.dispose();
    // What: Cleans up resources
    // Why: Prevents memory leaks
    // Interaction: Called when button is removed
  }

  // Button UI Builder
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: _shadowAnimation.value,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.8),
                  ],
                ),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        );
      },
    );
    // What: Builds button's visual appearance
    // Why: Creates interactive, animated button UI
    // Interaction: Combines all visual and interactive elements
  }
}

// Main Registration Screen
class Register extends GetView<RegistrationController> {
  // What: Main registration form screen
  // Why: Provides interface for student registration
  // Interaction: Connected to RegistrationController via GetX

  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // What: Dismisses keyboard on outside tap
      // Why: Improves user experience
      // Interaction: Manages keyboard visibility

      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  // App Bar Builder
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 126, 126, 126),
      title: const Text(
        "Registration",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
    );
    // What: Creates custom app bar
    // Why: Provides consistent header with title
    // Interaction: Shows screen title and navigation options
  }

  // Main Body Builder
  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildImageSelection(),
                const SizedBox(height: 24),
                _buildFormFields(),
                const SizedBox(height: 32),
                _buildActionButtons(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
    // What: Builds scrollable form layout
    // Why: Creates organized, scrollable form interface
    // Interaction: Contains all form components
  }

  // Header Builder
  Widget _buildHeader() {
    return const Text(
      "Add New Student",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
    // What: Creates form header
    // Why: Provides clear form purpose
    // Interaction: Shows form title to user
  }

  // Image Selection Builder
  Widget _buildImageSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() => _buildImageContent()),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildImagePickerButtons(),
        ],
      ),
    );
    // What: Creates image selection area
    // Why: Allows student photo selection
    // Interaction: Shows selected image or placeholder
  }

  // Image Content Builder
  Widget _buildImageContent() {
    return controller.selectedImage.value != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              controller.selectedImage.value!,
              fit: BoxFit.cover,
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add student photo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          );
    // What: Shows selected image or placeholder
    // Why: Provides visual feedback for image selection
    // Interaction: Updates when image is selected
  }

  // Image Picker Buttons Builder
  Widget _buildImagePickerButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => controller.pickImage(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          tooltip: "Select from gallery",
          iconSize: 32,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        IconButton(
          onPressed: () => controller.pickImage(ImageSource.camera),
          icon: const Icon(Icons.camera_alt),
          tooltip: "Open camera",
          iconSize: 32,
          color: Colors.blue,
        ),
      ],
    );
    // What: Creates image selection buttons
    // Why: Provides options for image selection
    // Interaction: Triggers camera or gallery selection
  }

  // Form Fields Builder
  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: controller.nameController,
          label: "Name",
          hint: "Enter Name",
          icon: Icons.person,
          validator: controller.validateName,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: controller.contactController,
          label: "Phone Number",
          hint: "Enter Phone Number",
          icon: Icons.phone,
          validator: controller.validatePhoneNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: controller.placeController,
          label: "Place",
          hint: "Enter Student Place",
          icon: Icons.location_on,
          validator: controller.validatePlace,
        ),
      ],
    );
    // What: Creates input fields for student data
    // Why: Collects student information
    // Interaction: Connected to controller for data management
  }

 // Text Field Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      // What: Links text field to its controller
      // Why: Manages text input state and value
      // Interaction: Connects UI input with form data management

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // What: Creates rounded border for text field
        // Why: Provides visual boundary and consistent styling
        // Interaction: Maintains visual hierarchy in the form

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        // What: Defines normal state border
        // Why: Shows inactive field boundary
        // Interaction: Provides visual feedback about field state

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        // What: Defines focused state border
        // Why: Highlights active field
        // Interaction: Shows which field is currently selected

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        // What: Defines error state border
        // Why: Indicates validation errors
        // Interaction: Provides visual feedback for invalid input

        labelText: label,
        // What: Sets field label text
        // Why: Identifies field purpose
        // Interaction: Helps users understand what data to enter

        hintText: hint,
        // What: Sets placeholder text
        // Why: Provides input guidance
        // Interaction: Shows example or expected input format

        prefixIcon: Icon(icon),
        // What: Adds icon before input field
        // Why: Provides visual indicator of field type
        // Interaction: Improves field recognition and UX

        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        // What: Styles error message text
        // Why: Makes error messages visible but not overwhelming
        // Interaction: Helps users identify and fix input errors
      ),

      keyboardType: keyboardType,
      // What: Sets keyboard type for input
      // Why: Shows appropriate keyboard for data type
      // Interaction: Optimizes input method for field type

      inputFormatters: inputFormatters,
      // What: Applies input formatting rules
      // Why: Enforces input restrictions and formatting
      // Interaction: Validates input as user types

      validator: validator,
      // What: Assigns validation function
      // Why: Ensures input meets requirements
      // Interaction: Checks input validity on form submission
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // What: Centers buttons horizontally
      // Why: Creates balanced layout
      // Interaction: Maintains visual symmetry

      children: [
        // Update Button with Loading State
        Obx(() => AnimatedCustomButton(
          // What: Creates reactive update button
          // Why: Shows current submission state
          // Interaction: Updates automatically when loading state changes

          text: controller.isLoading.value ? 'Saving...' : 'Update',
          // What: Sets button text based on state
          // Why: Provides feedback during submission
          // Interaction: Changes text when form is being submitted

          onPressed: (controller.isLoading.value || controller.isNavigating.value)
              ? () {}  // Empty function when loading/navigating
              : () => controller.insertData(),
          // What: Defines button press behavior
          // Why: Prevents multiple submissions
          // Interaction: Triggers data saving when appropriate

          color: const Color(0xFF4CAF50),
          // What: Sets green color for positive action
          // Why: Follows material design guidelines
          // Interaction: Indicates primary action button
        )),

        const SizedBox(width: 20),
        // What: Adds horizontal space between buttons
        // Why: Creates visual separation
        // Interaction: Prevents accidental mis-clicks

        // Clear Button
        AnimatedCustomButton(
          text: 'Clear',
          // What: Sets clear button text
          // Why: Indicates form reset action
          // Interaction: Shows destructive action purpose

          onPressed: (controller.isLoading.value || controller.isNavigating.value)
              ? () {}
              : () => controller.clearForm(),
          // What: Defines clear button behavior
          // Why: Prevents clearing during submission
          // Interaction: Resets form when appropriate

          color: const Color(0xFFE53935),
          // What: Sets red color for destructive action
          // Why: Indicates caution required
          // Interaction: Warns user about data clearing
        ),
      ],
    );
  }
}

// The registration form creates a complete user interaction flow where:
// 1. Users can input student details through validated form fields
// 2. Photo can be added from camera or gallery
// 3. Form state is managed reactively using GetX
// 4. Validation occurs in real-time and on submission
// 5. Visual feedback is provided through animations and state changes
// 6. Data is saved to local database on successful validation
// 7. Navigation occurs automatically after successful submission

// This implementation follows Flutter best practices for:
// - Form validation and error handling
// - State management and reactivity
// - User interface design and feedback
// - Code organization and maintainability
// - Performance and resource management