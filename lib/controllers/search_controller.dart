import 'dart:io';
import 'dart:async'; // Important: Add this import for Timer functionality
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db_control/student.dart';

class StudentSearchController extends GetxController with GetSingleTickerProviderStateMixin {
  // Core controllers
  final searchController = TextEditingController();
  final dbHelper = DatabaseHelper();

  // Reactive state variables
  final searchText = ''.obs;
  final suggestions = <Map<String, dynamic>>[].obs;
  final isSearching = false.obs;
  final noResults = false.obs;
  final hasSearchError = false.obs;

  // Animation controller
  late AnimationController animationController;
  
  // Timer related variables
  Timer? _debounceTimer;  // Declare the timer as nullable
  final int _debounceMilliseconds = 500;
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize animation controller
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Set up listener for search text changes
    searchController.addListener(() {
      if (_isDisposed) return;
      searchText.value = searchController.text;
      _debouncedSearch();
    });
  }

  @override
  void onClose() {
    if (!_isDisposed) {
      // Cancel any pending debounce timer
      _debounceTimer?.cancel();
      
      // Clean up controllers
      searchController.removeListener(() {});
      searchController.dispose();
      
      // Clean up animation
      if (animationController.isAnimating) {
        animationController.stop();
      }
      animationController.dispose();
      
      _isDisposed = true;
    }
    super.onClose();
  }

  // Debounced search implementation
  void _debouncedSearch() {
    // Cancel existing timer if active
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    // Create new timer
    _debounceTimer = Timer(
      Duration(milliseconds: _debounceMilliseconds),
      _performSearch,
    );
  }

  // Core search functionality
  Future<void> _performSearch() async {
    if (_isDisposed) return;
    
    final searchQuery = searchText.value.trim();
    isSearching.value = true;
    hasSearchError.value = false;

    if (searchQuery.isEmpty) {
      _clearSearchResults();
      return;
    }

    try {
      final results = await dbHelper.searchAll(searchQuery);
      if (_isDisposed) return;
      
      suggestions.value = results;
      noResults.value = results.isEmpty;

      if (results.isEmpty) {
        animationController.forward();
      } else {
        animationController.reset();
      }
    } catch (e) {
      if (!_isDisposed) {
        hasSearchError.value = true;
        _handleError('Failed to search: $e');
      }
    } finally {
      if (!_isDisposed) {
        isSearching.value = false;
      }
    }
  }

  // Helper method to clear search results
  void _clearSearchResults() {
    suggestions.clear();
    isSearching.value = false;
    noResults.value = false;
    hasSearchError.value = false;
    if (!_isDisposed) {
      animationController.reset();
    }
  }

  // Public method to clear search
  void clearSearch() {
    if (_isDisposed) return;
    searchController.clear();
    searchText.value = '';
    _clearSearchResults();
    _debounceTimer?.cancel();
  }

  // Build student image widget
  Widget buildStudentImage(String? imagePath) {
    if (_isDisposed) return const SizedBox.shrink();

    if (imagePath == null || !File(imagePath).existsSync()) {
      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 25,
        child: const Icon(
          Icons.person,
          color: Colors.grey,
          size: 30,
        ),
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundImage: FileImage(File(imagePath)),
      backgroundColor: Colors.grey[200],
      onBackgroundImageError: (_, __) {
        debugPrint('Error loading image: $imagePath');
      },
    );
  }

  // Navigate to student details
  void navigateToDetails(Map<String, dynamic> student) {
    if (_isDisposed) return;
    Get.toNamed('/details', arguments: {
      'name': student['name'],
      'contact': student['contact'],
      'place': student['place'],
      'imagePath': student['imagePath'],
    });
  }

  // Error handling
  void _handleError(String message) {
    if (!_isDisposed) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
        isDismissible: true,
        mainButton: TextButton(
          onPressed: () {
            if (!_isDisposed) _performSearch();
          },
          child: const Text('Retry'),
        ),
      );
    }
  }

  // Public method for manual search
  Future<void> performSearch(String query) async {
    if (_isDisposed) return;
    searchController.text = query;
    searchText.value = query;
    await _performSearch();
  }
}