import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../db_control/student.dart';

class RegistrationController extends GetxController {
  // Form controllers - Using TextEditingController for input management
  final nameController = TextEditingController();
  final placeController = TextEditingController();
  final contactController = TextEditingController();
  
  // Reactive state variables using GetX
  final isLoading = false.obs;
  final selectedImage = Rx<File?>(null);
  final isNavigating = false.obs; // New state to prevent multiple navigations
  
  // Form key for validation
  final formKey = GlobalKey<FormState>();
  
  // Database helper instance
  final dbHelper = DatabaseHelper();

  // Input validation methods with comprehensive checks
  String? validateName(String? value) {
    // Remove any leading/trailing whitespace
    final trimmedValue = value?.trim();
    
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Please enter your name';
    }
    if (trimmedValue.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmedValue)) {
      return 'Name must contain only alphabets';
    }
    // Check for reasonable maximum length
    if (trimmedValue.length > 50) {
      return 'Name is too long (maximum 50 characters)';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Ensure exactly 10 digits
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Phone number must contain exactly 10 digits';
    }
    // Additional check for valid phone number format
    if (value.startsWith('0')) {
      return 'Phone number should not start with 0';
    }
    return null;
  }

  String? validatePlace(String? value) {
    final trimmedValue = value?.trim();
    
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Please enter your place';
    }
    if (trimmedValue.length < 2) {
      return 'Place name must be at least 2 characters long';
    }
    // Check for reasonable maximum length
    if (trimmedValue.length > 100) {
      return 'Place name is too long (maximum 100 characters)';
    }
    // Allow letters, spaces, and common punctuation
    if (!RegExp(r'^[a-zA-Z\s\-\.,]+$').hasMatch(trimmedValue)) {
      return 'Place name contains invalid characters';
    }
    return null;
  }

  // Enhanced image picking with better error handling
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,  // Limit image dimensions for better performance
        maxHeight: 1200,
      );

      if (pickedImage != null) {
        // Verify file size
        final file = File(pickedImage.path);
        final sizeInBytes = await file.length();
        final sizeInMB = sizeInBytes / (1024 * 1024);
        
        if (sizeInMB > 5) {  // 5MB limit
          Get.snackbar(
            'Error',
            'Image size too large. Please select an image under 5MB.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
          return;
        }
        
        selectedImage.value = file;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Enhanced data insertion with proper error handling and navigation control
  Future<void> insertData() async {
    // Prevent multiple submissions
    if (isLoading.value || isNavigating.value) {
      return;
    }

    // Validate form
  // Update the validation error snackbar
if (!formKey.currentState!.validate()) {
  Get.snackbar(
    'Error',
    'Please fix the validation errors before submitting.',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red.shade100,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    titleText: Text(
      'Error',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.red.shade900,
      ),
    ),
    messageText: Text(
      'Please fix the validation errors before submitting.',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
    icon: Icon(
      Icons.error_outline,
      color: Colors.red.shade700,
      size: 30,
    ),
    shouldIconPulse: true,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  return;
}

// Update the missing image error snackbar
if (selectedImage.value == null) {
  Get.snackbar(
    'Error',
    'Please select a student photo.',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red.shade100,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    titleText: Text(
      'Error',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.red.shade900,
      ),
    ),
    messageText: Text(
      'Please select a student photo.',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
    icon: Icon(
      Icons.error_outline,
      color: Colors.red.shade700,
      size: 30,
    ),
    shouldIconPulse: true,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  return;
}

    isLoading.value = true;
    String? imagePath;
    
    try {
      // Get form values with proper trimming
      final String name = nameController.text.trim();
      final int contact = int.parse(contactController.text.trim());
      final String place = placeController.text.trim();

      // Handle image storage
      final imageFileName = 'student_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final directory = await getTemporaryDirectory();
      imagePath = '${directory.path}/$imageFileName';
      
      // Copy image with error handling
      await selectedImage.value!.copy(imagePath);

      // Prepare data for database
      final row = {
        'name': name,
        'place': place,
        'contact': contact,
        'imagePath': imagePath,
      };

      // Insert into database
      await dbHelper.insert(row);
      
      // Show success message and handle navigation
      await _handleSuccessfulRegistration();
      
    } catch (e) {
      // Clean up failed image file if it exists
      if (imagePath != null) {
        try {
          final failedImageFile = File(imagePath);
          if (await failedImageFile.exists()) {
            await failedImageFile.delete();
          }
        } catch (cleanupError) {
          print('Failed to cleanup image file: $cleanupError');
        }
      }
      
      Get.snackbar(
        'Error',
        'Failed to register student: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Handle successful registration and navigation
Future<void> _handleSuccessfulRegistration() async {
  isNavigating.value = true;
  
  clearForm();
  
  Get.snackbar(
    'Success', // Title
    'Student registered successfully!',
    snackPosition: SnackPosition.TOP, // Changed to TOP for better visibility
    backgroundColor: Colors.green.shade200, // Lighter, more visible background
    colorText: Colors.black, // Changed to black for better contrast
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(10), // Added margin for better spacing
    borderRadius: 10, // Rounded corners
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // More padding
    titleText: Text(
      'Success',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.green.shade900, // Darker color for title
      ),
    ),
    messageText: Text(
      'Student registered successfully!',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500, // Medium weight for better readability
        color: Colors.black87, // Slightly softer black for message
      ),
    ),
    icon: Icon(
      Icons.check_circle,
      color: Colors.green.shade700,
      size: 30,
    ), // Added success icon
    shouldIconPulse: true, // Adds a subtle animation to the icon
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ], // Added shadow for depth
  );

  await Future.delayed(const Duration(milliseconds: 300));
  
  if (mounted) {
    Get.offAllNamed('/home');
  }
  
  isNavigating.value = false;
}

  // Enhanced form clearing with confirmation
  void clearForm() {
    nameController.clear();
    placeController.clear();
    contactController.clear();
    selectedImage.value = null;
    
    // Reset any form validation states
    formKey.currentState?.reset();
  }

  // Lifecycle management
  @override
  void onInit() {
    super.onInit();
    // Initialize any additional resources here
  }

  @override
  void onClose() {
    // Clean up controllers
    nameController.dispose();
    placeController.dispose();
    contactController.dispose();
    super.onClose();
  }

  // Helper method to check if the controller is still active
  bool get mounted => true;
}