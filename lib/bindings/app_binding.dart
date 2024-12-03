import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/registration_controller.dart';
import '../controllers/search_controller.dart';
import '../db_control/student.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    // Register the DatabaseHelper as a permanent dependency
    // Using permanent: true ensures it stays alive throughout the app lifecycle
    Get.put<DatabaseHelper>(
      DatabaseHelper(),
      permanent: true,
    );

    // Controllers with Lazy Loading
    // These controllers will only be instantiated when they're first accessed
    
    // Home Controller Registration
    // fenix: true allows recreation if the controller is destroyed
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
      tag: 'home_controller', // Optional: Useful for identifying specific instances
    );

    // Registration Controller Setup
    // Building on top of the HomeController to ensure data consistency
    Get.lazyPut<RegistrationController>(
      () {
        // We can perform any initialization logic here
        final controller = RegistrationController();
        return controller;
      },
      fenix: true,
      tag: 'registration_controller',
    );

    // Search Controller Configuration
    // Using fenix to maintain state when navigating back
    Get.lazyPut<StudentSearchController>(
      () => StudentSearchController(),
      fenix: true,
      tag: 'search_controller',
    );

    // Optional: Setup any additional services or controllers
    _setupAdditionalDependencies();
  }

  // Helper method to keep the main dependencies method clean
  void _setupAdditionalDependencies() {
    // Example: Setting up shared preferences or other services
    // Get.put<SharedPreferencesService>(SharedPreferencesService());
    
    // Example: Setting up API services
    // Get.put<ApiService>(ApiService());
    
    // Example: Setting up utility services
    // Get.put<UtilityService>(UtilityService());
  }
}