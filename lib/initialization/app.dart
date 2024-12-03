import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import existing screens with current names
import '../screens/home.dart';
import '../screens/reg.dart';
import '../screens/serachpage.dart';
import '../screens/details.dart';

// Import bindings
import '../bindings/home_binding.dart';
import '../bindings/registration_binding.dart';
import '../bindings/search_binding.dart';
import '../bindings/details_binding.dart';

// Import theme
import '../theme/twitter_colors.dart';

// Error View Component for handling unknown routes
class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColors.background,
      appBar: AppBar(
        title: const Text('Page Not Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: TwitterColors.accent),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                color: TwitterColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested page could not be found.',
              style: TextStyle(color: TwitterColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentApp extends StatelessWidget {
  const StudentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Basic app configuration
      title: 'Student Database',
      debugShowCheckedModeBanner: false,

      // Initial binding setup
      initialBinding: HomeBinding(),

      // Theme configuration
      theme: ThemeData(
        scaffoldBackgroundColor: TwitterColors.background,
        primaryColor: TwitterColors.accent,
        useMaterial3: true,

        // Color scheme configuration
        colorScheme: ColorScheme.dark(
          primary: TwitterColors.accent,
          secondary: TwitterColors.accent,
          surface: TwitterColors.cardBg,
          background: TwitterColors.background,
          error: Colors.redAccent,
          onPrimary: TwitterColors.textPrimary,
          onSecondary: TwitterColors.textPrimary,
          onSurface: TwitterColors.textPrimary,
          onBackground: TwitterColors.textPrimary,
        ),

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: TwitterColors.background,
          foregroundColor: TwitterColors.textPrimary,
          elevation: 0,
          iconTheme: IconThemeData(color: TwitterColors.accent),
          titleTextStyle: TextStyle(
            color: TwitterColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Card theme
        cardTheme: CardTheme(
          color: TwitterColors.cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Text theme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: TwitterColors.textPrimary),
          bodyMedium: TextStyle(color: TwitterColors.textSecondary),
          titleLarge: TextStyle(color: TwitterColors.textPrimary),
          titleMedium: TextStyle(color: TwitterColors.textPrimary),
          titleSmall: TextStyle(color: TwitterColors.textSecondary),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: TwitterColors.cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TwitterColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TwitterColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: TwitterColors.accent),
          ),
          labelStyle: TextStyle(color: TwitterColors.textSecondary),
          hintStyle: TextStyle(color: TwitterColors.textSecondary),
        ),

        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: TwitterColors.accent,
            foregroundColor: TwitterColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: TwitterColors.accent,
          foregroundColor: TwitterColors.textPrimary,
        ),
      ),

      // Route configuration using existing components
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () =>  HomeScreen(),
          binding: HomeBinding(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/registration',
          page: () => const Register(),
          binding: RegistrationBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/search',
          page: () => const SearchPage(),
          binding: SearchBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/details',
          page: () {
            // Handle details page with required parameters
            final args = Get.arguments as Map<String, dynamic>;
            return DetailsPage(
              name: args['name'] ?? '',
              contact: args['contact'] ?? 0,
              place: args['place'] ?? '',
              imagePath: args['imagePath'],
            );
          },
          binding: DetailsBinding(),
          transition: Transition.rightToLeft,
        ),
      ],

      // Default transition for navigation
      defaultTransition: Transition.fade,

      // Error handling and logging setup
      enableLog: true,
      logWriterCallback: (String text, {bool isError = false}) {
        debugPrint('StudentApp Log: $text');
      },
      onUnknownRoute: (settings) {
        return GetPageRoute(
          page: () => const ErrorView(),
          transition: Transition.fadeIn,
        );
      },

      // Global error handler and keyboard dismiss
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child!,
        );
      },
    );
  }
}