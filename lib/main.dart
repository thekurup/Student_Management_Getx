// Import statements bring in the necessary Flutter packages and local files
// These are like building blocks that give us access to Flutter's features
import 'package:flutter/material.dart';    // Core Flutter UI components
import 'package:flutter/services.dart';    // Access to platform-specific features
import 'dart:async';                       // Tools for handling asynchronous operations
import 'initialization/app.dart';          // Our custom app initialization code

// The main function is the starting point of every Flutter application
// It's marked as async because it performs several operations that take time to complete
Future<void> main() async {
  // This line sets up the connection between Flutter and the device's operating system
  // It's crucial to call this before doing anything else with platform channels or plugins
  // Without this, features like screen orientation and status bar customization won't work
  WidgetsFlutterBinding.ensureInitialized();

  // Set up an error handler specifically for Flutter-related errors
  // This helps us catch and properly handle any issues that occur in the UI layer
  // The error details will be printed to the debug console for debugging
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exception}');
  };

  // Create a protected zone for running our app that catches all errors
  // This is like putting our entire app in a safety net that catches any problems
  // The runZonedGuarded function takes two parameters:
  // 1. The function to run (our app)
  // 2. An error handler for any uncaught errors
  await runZonedGuarded(() async {
    try {
      // Lock the app to portrait mode orientation
      // This ensures our app's UI always displays correctly and doesn't rotate
      // We await this because it's important to set this before showing any UI
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,    // Allow normal upright position
        DeviceOrientation.portraitDown,  // Allow upside down position
      ]);

      // Customize the appearance of the system UI elements (status bar)
      // This makes the status bar transparent and sets its icons to light color
      // This is typically done to make the app look more polished and integrated
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,      // Make status bar background clear
          statusBarIconBrightness: Brightness.light, // Use light colored status icons
        ),
      );

      // Finally, start the actual app by creating the root widget
      // StudentApp is our main app widget defined in initialization/app.dart
      // The 'const' keyword is used for optimization since StudentApp won't change
      runApp(const StudentApp());

    } catch (e, stack) {
      // This catch block handles any errors that occur during app initialization
      // It prints both the error and its stack trace to help with debugging
      // The stack trace shows exactly where in the code the error occurred
      debugPrint('Initialization error: $e');
      debugPrint('Stack trace: $stack');
      rethrow; // Pass the error up to be handled by the zone's error handler
    }
  }, (Object error, StackTrace stack) {
    // This is our top-level error handler that catches any errors not caught elsewhere
    // It provides a last line of defense against crashes
    // All errors are printed to the debug console for developers to investigate
    debugPrint('Uncaught error in app:');
    debugPrint(error.toString());
    debugPrint(stack.toString());
  });
}