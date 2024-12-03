import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/registration_controller.dart';
import '../controllers/search_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy loading of controllers - they will be instantiated only when needed
    // This helps with memory management and app performance
    
    // Home Controller binding
    // Using lazyPut to create the controller only when it's first accessed
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true, // Keeps the controller instance alive throughout the app lifecycle
    );

    // Registration Controller binding
    // Will be created when registration page is accessed
    Get.lazyPut<RegistrationController>(
      () => RegistrationController(),
      fenix: true,
    );

    // Search Controller binding
    // Will be created when search functionality is accessed
    Get.lazyPut<StudentSearchController>(
      () => StudentSearchController(),
      fenix: true,
    );
  }
}