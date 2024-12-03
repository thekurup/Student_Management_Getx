// Import necessary packages for building the UI and state management
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // For displaying animated assets
import '../theme/twitter_colors.dart'; // Custom color scheme
import '../controllers/search_controller.dart'; // Controller for search logic

// SearchPage class that extends GetView to integrate with GetX state management
// GetView provides automatic controller initialization and disposal
class SearchPage extends GetView<StudentSearchController> {
  // Constructor with optional key parameter for widget identification
  // This is a standard Flutter pattern for widget construction
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Main scaffold that provides the basic structure for the page
    return Scaffold(
      // Set background color using custom Twitter-style theme
      backgroundColor: TwitterColors.background,
      
      // AppBar configuration for the search page
      appBar: AppBar(
        title: Text(
          'Search Students',
          // Custom text styling for the app bar title
          style: TextStyle(
            color: TwitterColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Maintaining consistent theme with custom colors
        backgroundColor: TwitterColors.background,
        elevation: 0, // Flat design without shadow
        iconTheme: IconThemeData(color: TwitterColors.accent),
      ),

      // Main body using a Column for vertical layout
      body: Column(
        children: [
          // Search input container with custom styling
          Container(
            padding: const EdgeInsets.all(16),
            // Custom decoration for search container with bottom border
            decoration: BoxDecoration(
              color: TwitterColors.background,
              border: Border(
                bottom: BorderSide(
                  color: TwitterColors.divider,
                  width: 0.5,
                ),
              ),
            ),

            // TextField for search input with reactive behavior
            child: TextField(
              // Connected to the search controller for input handling
              controller: controller.searchController,
              style: TextStyle(color: TwitterColors.textPrimary),
              // Rich decoration for the search input field
              decoration: InputDecoration(
                hintText: 'Search students by name...',
                hintStyle: TextStyle(color: TwitterColors.textSecondary),
                prefixIcon: Icon(Icons.search, color: TwitterColors.accent),
                
                // Reactive clear button using Obx for state management
                // Only shows when there is text in the search field
                suffixIcon: Obx(() => controller.searchText.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: TwitterColors.accent),
                        onPressed: controller.clearSearch,
                      )
                    : const SizedBox.shrink()),
                
                // Rounded border styling for the search field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: TwitterColors.cardBg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              // Immediate search trigger on submit
              onSubmitted: (value) => controller.performSearch(value),
            ),
          ),

          // Expandable content area with state-based display
          Expanded(
            // Using Obx for reactive state management
            child: Obx(() {
              // Error state handling with retry option
              if (controller.hasSearchError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Error icon display
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      // Error message
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          color: TwitterColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Retry button
                      TextButton(
                        onPressed: () => controller.performSearch(controller.searchText.value),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }
              // Build main content based on current state
              return _buildContent();
            }),
          ),
        ],
      ),
    );
  }

  // Helper method to build the main content based on search state
  Widget _buildContent() {
    // Loading state
    if (controller.isSearching.value) {
      return const Center(
        child: CircularProgressIndicator(
          color: TwitterColors.accent,
        ),
      );
    }

    // No results state with animation
    if (controller.noResults.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation for empty state
            Lottie.asset(
              'assets/animations/not_found.json',
              controller: controller.animationController,
              height: 200,
            ),
            const SizedBox(height: 20),
            // No results message
            Text(
              'No students found',
              style: TextStyle(
                color: TwitterColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Conditional clear search button
            if (controller.searchText.value.isNotEmpty)
              TextButton.icon(
                onPressed: controller.clearSearch,
                icon: const Icon(Icons.clear),
                label: const Text('Clear Search'),
              ),
          ],
        ),
      );
    }

    // Empty initial state
    if (controller.suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Search icon
            Icon(
              Icons.search,
              size: 80,
              color: TwitterColors.textSecondary,
            ),
            const SizedBox(height: 16),
            // Prompt message
            Text(
              'Start typing to search students',
              style: TextStyle(
                color: TwitterColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Search results list with animations
    return ListView.builder(
      itemCount: controller.suggestions.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final student = controller.suggestions[index];
        // Animated container for smooth transitions
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          // Card widget for each student result
          child: Card(
            elevation: 0,
            color: TwitterColors.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // List tile for student information
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              // Hero widget for smooth image transitions
              leading: Hero(
                tag: 'student_${student['id']}',
                child: controller.buildStudentImage(student['imagePath']),
              ),
              // Student name
              title: Text(
                student['name'],
                style: TextStyle(
                  color: TwitterColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Student location
              subtitle: Text(
                student['place'],
                style: TextStyle(color: TwitterColors.textSecondary),
              ),
              // Navigation to detail page on tap
              onTap: () => controller.navigateToDetails(student),
            ),
          ),
        );
      },
    );
  }
}