import 'dart:io';  
// What: Imports Flutter's IO library for file system operations
// Why: Required for handling file operations like reading/writing student profile images 
// Interaction: Used with ImagePicker and for displaying student photos

import 'package:flutter/material.dart';
// What: Imports core Flutter material design widgets and utilities
// Why: Provides essential UI building blocks and material design components
// Interaction: Used throughout the file for creating the visual interface

import 'package:get/get.dart';
// What: Imports GetX state management library
// Why: Handles state management, routing, and dependency injection
// Interaction: Connects UI to controllers, manages app state changes

import 'package:image_picker/image_picker.dart';
// What: Imports image selection functionality
// Why: Enables selecting images from gallery or camera for student profiles
// Interaction: Triggered when user taps gallery or camera buttons for profile photos

import '../screens/details.dart';
// What: Imports the student details screen
// Why: Required for showing detailed student information
// Interaction: Navigation destination when user taps on a student card

import '../screens/reg.dart';
// What: Imports student registration screen
// Why: Required for adding new students to the database
// Interaction: Launched when FAB is pressed to add new student

import '../screens/serachpage.dart';
// What: Imports search functionality screen
// Why: Enables searching through student records
// Interaction: Accessed via search icon in app bar to find specific students

import 'package:student_db/theme/twitter_colors.dart';
// What: Imports custom color scheme constants
// Why: Maintains consistent theming throughout the app
// Interaction: Applied to all UI elements for visual consistency

import 'package:simple_animations/simple_animations.dart';
// What: Imports animation utilities
// Why: Creates smooth, complex animations for the FAB
// Interaction: Controls FAB animation sequences when user interacts

import '../controllers/home_controller.dart';
// What: Imports home screen controller
// Why: Manages state and business logic for home screen
// Interaction: Connects UI to database operations and state management

// AnimatedFAB (Floating Action Button) Widget
// This widget creates a beautifully animated floating action button with custom effects

class AnimatedFAB extends StatefulWidget {
   // What: Defines animated floating action button widget
  // Why: Creates reusable button with sophisticated animations
  // Interaction: Main entry point for adding new students

  final VoidCallback onPressed;  // Callback function for button press

   // What: Callback function for button press events
  // Why: Allows parent widget to define button press behavior
  // Interaction: Triggers navigation to registration screen when pressed

  const AnimatedFAB({Key? key, required this.onPressed}) : super(key: key);

  // What: Constructor for AnimatedFAB widget
  // Why: Initializes widget with required callback
  // Interaction: Called when creating new FAB instance

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();

// What: Creates state object for AnimatedFAB
  // Why: Manages widget's internal state for animations
  // Interaction: Maintains animation state throughout widget lifecycle
}

class _AnimatedFABState extends State<AnimatedFAB> with AnimationMixin {
  //   What: Defines private state class for AnimatedFAB
  // Why: Handles animation logic and state management
  // Interaction: Controls button's visual appearance during interactions

  late AnimationController animationController;  // Controls the animation timing
  late MovieTween animationSequence;  // Controls the visual flow of button animations

  @override
  void initState() {
    // Interaction: Called when FAB is first created
    super.initState();
    
    animationController = createController()
      ..duration = const Duration(milliseconds: 800);
      // What: Creates animation controller with 800ms duration
    // Why: Controls timing of animation sequence
    // Interaction: Determines how long animations take to complete
    
   
    animationSequence = MovieTween()
      // First scene: Button scales up and elevation increases
      ..scene(
        begin: const Duration(milliseconds: 0),
        duration: const Duration(milliseconds: 200),
      )
        .tween(
          'scale',
          Tween<double>(begin: 1.0, end: 1.3),  // Scale up by 30%
          curve: Curves.easeOutCubic,  // Smooth scaling effect
        )
        .tween(
          'elevation',
          Tween<double>(begin: 2.0, end: 15.0),  // Increase shadow
          curve: Curves.easeOutExpo,
        )
      // Second scene: Rotation and scale normalization
      ..scene(
        begin: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 300),
      )
        .tween(
          'rotate',
          Tween<double>(begin: 0.0, end: 0.5),  // Rotate button
          curve: Curves.elasticOut,  // Bouncy rotation effect
        )
        .tween(
          'scale',
          Tween<double>(begin: 1.3, end: 1.0),  // Return to normal size
          curve: Curves.elasticOut,
        )
      // Third scene: Return to original state
      ..scene(
        begin: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 300),
      )
        .tween(
          'elevation',
          Tween<double>(begin: 15.0, end: 2.0),  // Return to normal elevation
          curve: Curves.easeOutBack,
        )
        .tween(
          'rotate',
          Tween<double>(begin: 0.5, end: 0.0),  // Return to original rotation
          curve: Curves.easeOutBack,
        );
  }

  // Handle button tap with animation sequence
  Future<void> _handleTap() async {
    if (animationController.isAnimating) return;  // Prevent multiple taps during animation

    try {
      await animationController.forward(from: 0);  // Start animation
      await Future.delayed(const Duration(milliseconds: 400));  // Wait for animation
      widget.onPressed();  // Interaction:  navigates to registration screen
    } finally {
      if (mounted) {
        animationController.reset();  // Reset animation state
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Interaction: Renders animated button on screen
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final Movie movie = animationSequence.transform(animationController.value);
        // Interaction: Changes button visuals during animation

        return Transform.scale(
          scale: movie.get('scale'),
          child: Transform.rotate(
            angle: movie.get('rotate'),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: TwitterColors.accent.withOpacity(0.3),
                    blurRadius: movie.get('elevation') * 2,
                    spreadRadius: movie.get('elevation') / 3,
                    offset: Offset(0, movie.get('elevation') / 2),
                  ),
                ],
              ),
              // Interaction: This below section Updates button appearance smoothly during animations
              child: FloatingActionButton(
                onPressed: _handleTap,
                backgroundColor: TwitterColors.accent,
                elevation: movie.get('elevation'),
                child: Transform.rotate(
                  angle: -movie.get('rotate'),
                  child: Icon(
                    Icons.add,
                    color: TwitterColors.textPrimary,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();  // Clean up animation controller
    super.dispose();
  }
}

// Main HomeScreen implementation using GetX for state management
class HomeScreen extends StatelessWidget {
    // Interaction: First screen users see after launch
  HomeScreen({super.key});

  // Initialize HomeController using GetX dependency injection
  final HomeController controller = Get.put(HomeController());
  // What: Initializes home screen controller
  // Why: Manages state and business logic for home screen
  // Interaction: Handles all data operations and UI updates


  // Helper method to build student profile image
  Widget _buildStudentImage(String? imagePath) {
    // What: Creates student profile image widget
    // Why: Displays student photo or default avatar
    // Interaction: Shows in student list and detail views

    // If no image path or file doesn't exist, show default avatar
    if (imagePath == null || !File(imagePath).existsSync()) {
      return CircleAvatar(
        backgroundColor: TwitterColors.cardBg,
        radius: 25,
        child: Icon(
          Icons.person,
          color: TwitterColors.textSecondary,
          size: 30,
        ),
      );
      // What: Creates default avatar
      // Why: Shown when no image exists
      // Interaction: Displays for students without photos
    }

    // Show student image with error handling
    return CircleAvatar(
      radius: 25,
      backgroundImage: FileImage(File(imagePath)),
      backgroundColor: TwitterColors.cardBg,
      onBackgroundImageError: (_, __) {
        debugPrint('Error loading image: $imagePath');
      },
    );
       // What: Displays student photo
    // Why: Shows actual student image when available
    // Interaction: Loads and displays student's profile picture
  }

   // Build the main scaffold with app bar, body, and FAB
  @override
  Widget build(BuildContext context) {
    // What: Builds main home screen structure
    // Why: Creates primary interface layout
    // Interaction: Renders main screen users interact with


    return Scaffold(
      backgroundColor: TwitterColors.background,
      appBar: AppBar(
        backgroundColor: TwitterColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Students Updates",
          style: TextStyle(
            color: TwitterColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
         // What: Creates app bar with title
        // Why: Shows screen title and actions
        // Interaction: Displays at top of screen with navigation options



        leading: Icon(Icons.school, color: TwitterColors.accent),
         // What: Adds school icon to app bar


        actions: [
          // Search button
          IconButton(
            onPressed: () => Get.to(() => const SearchPage()),
            icon: Icon(Icons.search, color: TwitterColors.accent),
            tooltip: 'Search Students',
          ),
          // What: Adds search button
          // Why: Provides access to student search
          // Interaction: Opens search screen when tapped


          // Refresh button
          IconButton(
            onPressed: () => controller.fetchAllStudents(),
            icon: Icon(Icons.refresh, color: TwitterColors.accent),
            tooltip: 'Refresh List',
          ),
           // Interaction: Reloads student list when tapped
        ],
      ),


      // Adding Animated Add buttton in the body
      floatingActionButton: AnimatedFAB(
        onPressed: () => Get.to(() => const Register())?.then((_) => controller.fetchAllStudents()),
      ),
      // Why: Provides access to student registration
      // Interaction: Opens registration screen with animation when pressed


      // Main body with reactive state management using Obx
      body: Obx(
        // Why: Updates UI automatically when data changes
          // Interaction: Rebuilds when student list changes
        () {

          // Show loading indicator while fetching data
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: TwitterColors.accent,
              ),
            );

              // Interaction: Displays while fetching student data
          }

          // Show empty state when no students exist
          // Interaction: Displays when student list is empty with option to add
          if (controller.students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 64,
                    color: TwitterColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No students added yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: TwitterColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.to(() => const Register())?.then((_) => controller.fetchAllStudents()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TwitterColors.accent,
                      foregroundColor: TwitterColors.textPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Add Student'),
                  ),
                ],
              ),
            );

          }

          //  Creates student list item card
          return ListView.builder(
            // Interaction: Displays each student's basic info in list

            itemCount: controller.students.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final student = controller.students[index];
              return Card(
                elevation: 0,
                color: TwitterColors.cardBg,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),


                child: ListTile(
                  // Interaction: Animates when navigating to details
                  onTap: () => _showData(student),
                  contentPadding: const EdgeInsets.all(12),
                  leading: Hero(
                    tag: 'student_${student['id']}',
                    child: _buildStudentImage(student['imagePath']),
                  ),

                  // Interaction: Shows basic student details in list
                  title: Text(
                    student['name'],
                    style: TextStyle(
                      color: TwitterColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    student['place'],
                    style: TextStyle(
                      color: TwitterColors.textSecondary,
                    ),
                  ),

                  // What: Adds edit button
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _editData(student),
                        icon: Icon(
                          Icons.edit,
                          color: TwitterColors.accent,
                        ),
                        tooltip: 'Edit Student',
                      ),
                      const SizedBox(width: 8),

                       // Interaction: Shows delete confirmation when tapped
                      IconButton(
                        onPressed: () => _showDeleteDialog(student['id']),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        tooltip: 'Delete Student',
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // What: Creates confirmation dialog for student deletion
   // Interaction: Shows when delete button is tapped on student card
  void _showDeleteDialog(int id) {

    // What: Builds delete confirmation dialog UI
    // Interaction: Appears as modal dialog over main screen
    Get.dialog(
      AlertDialog(
        backgroundColor: TwitterColors.cardBg,
        title: Text(
          'Delete Student',
          style: TextStyle(color: TwitterColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this student\'s data?',
          style: TextStyle(color: TwitterColors.textSecondary),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

         // What: Adds cancel button
          // Interaction: Closes dialog without deleting when pressed
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: TwitterColors.textSecondary),
            ),
            onPressed: () => Get.back(),
          ),

          // What: Adds confirm delete button
          // Interaction: Deletes student and closes dialog when pressed
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              controller.deleteStudent(id);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // What: Sets up and shows student edit dialog
  // Interaction: Opens when edit button is tapped on student card
  void _editData(Map<String, dynamic> data) {

    // Pre-fill form with existing data
    // Interaction: Opens when edit button is tapped on student card
    controller.nameController.text = data['name'];
    controller.contactController.text = data['contact'].toString();
    controller.placeController.text = data['place'];
    if (data['imagePath'] != null && data['imagePath'].isNotEmpty) {
      controller.selectedImage.value = File(data['imagePath']);
    }

    // Show edit dialog
     // Interaction: This section Updates when user types new name 
    Get.dialog(
      AlertDialog(
        backgroundColor: TwitterColors.cardBg,
        title: Text(
          'Edit Student',
          style: TextStyle(color: TwitterColors.textPrimary),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Form fields for editing student data
              TextFormField(
                controller: controller.nameController,
                style: TextStyle(color: TwitterColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: TwitterColors.textSecondary),
                  prefixIcon: Icon(Icons.person, color: TwitterColors.accent),
                  fillColor: TwitterColors.background,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: TwitterColors.divider),
                  ),
                ),
              ),


              // Interaction: Updates when user enters new contact number
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.contactController,
                style: TextStyle(color: TwitterColors.textPrimary),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Contact',
                  labelStyle: TextStyle(color: TwitterColors.textSecondary),
                  prefixIcon: Icon(Icons.phone, color: TwitterColors.accent),
                  fillColor: TwitterColors.background,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: TwitterColors.divider),
                  ),
                ),
              ),

              // Interaction: Updates when user enters new place
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.placeController,
                style: TextStyle(color: TwitterColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Place',
                  labelStyle: TextStyle(color: TwitterColors.textSecondary),
                  prefixIcon: Icon(Icons.location_on, color: TwitterColors.accent),
                  fillColor: TwitterColors.background,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: TwitterColors.divider),
                  ),
                ),
              ),


              // Interaction: Updates when new image is selected
              const SizedBox(height: 16),
              // Image selection section with preview and controls
              Obx(() => Row(
                children: [
                  // Image preview container that shows either selected image or placeholder
                  Expanded(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: TwitterColors.background,
                        border: Border.all(color: TwitterColors.divider),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: controller.selectedImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                controller.selectedImage.value!,
                                fit: BoxFit.cover,  // Ensures image fills the container nicely
                              ),
                            )
                          : Icon(
                              Icons.image,
                              size: 50,
                              color: TwitterColors.textSecondary,
                            ),
                    ),
                  ),


                   // What: Adds gallery selection button
                  // Interaction: Opens gallery picker when tapped
                  const SizedBox(width: 16),
                  // Image selection buttons column
                  Column(
                    children: [
                      // Gallery selection button
                      IconButton(
                        onPressed: () => _pickImage(),
                        icon: Icon(
                          Icons.photo_library,
                          color: TwitterColors.accent,
                        ),
                        tooltip: 'Pick from Gallery',
                      ),




                      // Camera capture button
                       // Interaction: Opens camera when tapped
                      IconButton(
                        onPressed: () => _takePhoto(),
                        icon: Icon(
                          Icons.camera_alt,
                          color: TwitterColors.accent,
                        ),
                       tooltip: 'Take Photo',
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
        

        // What: Adds cancel button to edit dialog
         // Interaction: Clears form and closes dialog when pressed
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: TwitterColors.textSecondary),
            ),
            onPressed: () {
              controller.clearForm();  // Clear all form data
              Get.back();  // Close the dialog
            },
          ),

          // What: Adds save button to edit dialog
            // Interaction: Updates student data and closes dialog when pressed
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TwitterColors.accent,
              foregroundColor: TwitterColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Save'),
            onPressed: () {
              // Create an updated student data map with all the edited information
              final updatedData = {
                'id': data['id'],  // Keep the original student ID
                'name': controller.nameController.text.trim(),
                'contact': int.tryParse(controller.contactController.text) ?? 0,
                'place': controller.placeController.text.trim(),
                'imagePath': controller.selectedImage.value?.path ?? '',
              };
              
              // Update the student record in the database
              controller.updateStudent(updatedData);
              Get.back();  // Close the dialog after updating
            },
          ),
        ],
      ),
    );
  }

  // What: Handles image selection from gallery
  Future<void> _pickImage() async {
     // Interaction: Called when gallery button is pressed

      // What: Opens gallery picker with compression
    final picker = ImagePicker();
    // Launch gallery with image quality optimization
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,  // Compress image to reduce storage size

      // Why: Allows image selection while optimizing file size
    // Interaction: Opens device gallery for image selection
    );

    // Update selected image if user picked one
    if (pickedImage != null) {
      controller.selectedImage.value = File(pickedImage.path);
      // Interaction: Updates image preview when new image is selected
    }
  }

  // What: Handles photo capture with camera
  Future<void> _takePhoto() async {
     // Interaction: Called when camera button is pressed

     // What: Opens camera with compression settings
    final picker = ImagePicker();
    // Launch camera with image quality optimization
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
        // Compress image to reduce storage size
         // Interaction: Opens device camera for photo capture
    );

    // Update selected image if photo was taken
    if (pickedImage != null) {
      controller.selectedImage.value = File(pickedImage.path);
       // Interaction: Updates image preview when photo is taken
    }
  }

   // What: Navigates to student details page
  void _showData(Map<String, dynamic> data) {
    // Why: Shows complete information for selected student
    // Interaction: Called when student card is tapped

    // What: Opens details page with student data
    Get.to(() => DetailsPage(
      name: data['name'],
      place: data['place'],
      contact: data['contact'],
      imagePath: data['imagePath'],
    ))?.then((_) => controller.fetchAllStudents());  

     // Why: Shows detailed view of student information
    // Interaction: Navigates to details screen and refreshes list on return
  }
}