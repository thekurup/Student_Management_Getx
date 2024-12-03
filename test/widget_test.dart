import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:student_db/initialization/app.dart';  // Import StudentApp instead of MyApp
import 'package:student_db/theme/twitter_colors.dart';

void main() {
  // Setting up the GetX test environment before running tests
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;  // Enables GetX test mode for proper navigation testing
  });

  // Cleaning up after each test to ensure a fresh state
  tearDown(() {
    Get.reset();  // Resets GetX state between tests
  });

  // Testing the initial home screen layout and elements
  testWidgets('Home screen initial layout test', (WidgetTester tester) async {
    // Building the app with StudentApp instead of MyApp
    await tester.pumpWidget(const StudentApp());
    
    // Testing the app bar elements
    expect(find.text('Students Updates'), findsOneWidget,
        reason: 'App title should be present in the app bar');
    expect(find.byIcon(Icons.school), findsOneWidget,
        reason: 'School icon should be present in the app bar');
    expect(find.byIcon(Icons.search), findsOneWidget,
        reason: 'Search icon should be present in the app bar');
    
    // Testing the floating action button
    expect(find.byIcon(Icons.add), findsOneWidget,
        reason: 'Add button should be present for adding new students');
  });

  // Testing the navigation to registration screen
  testWidgets('Navigation to registration screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentApp());

    // Tap the add button and wait for navigation animation
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();  // Waits for all animations to complete

    // Verify we're on the registration screen
    expect(find.text('Registration'), findsOneWidget,
        reason: 'Should navigate to registration screen');
    
    // Test registration form elements
    expect(find.byIcon(Icons.person), findsOneWidget,
        reason: 'Name field icon should be present');
    expect(find.byIcon(Icons.phone), findsOneWidget,
        reason: 'Phone field icon should be present');
    expect(find.byIcon(Icons.location_on), findsOneWidget,
        reason: 'Location field icon should be present');
  });

  // Testing the search functionality
  testWidgets('Search screen navigation and layout test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentApp());

    // Navigate to search screen
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Verify search screen elements
    expect(find.text('Search Students'), findsOneWidget,
        reason: 'Search screen title should be present');
    expect(find.byType(TextField), findsOneWidget,
        reason: 'Search input field should be present');
    
    // Test search functionality
    await tester.enterText(find.byType(TextField), 'Test Student');
    await tester.pump(const Duration(milliseconds: 500));
  });

  // Testing theme and styling
  testWidgets('Theme and styling test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentApp());

    // Test if theme colors are applied correctly
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, TwitterColors.background,
        reason: 'Background color should match Twitter theme');

    // Test app bar styling
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, TwitterColors.background,
        reason: 'AppBar color should match Twitter theme');
  });

  // Testing empty state message
  testWidgets('Empty state message test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentApp());

    // If no students are added, verify empty state message
    expect(find.text('No students added yet'), findsOneWidget,
        reason: 'Empty state message should be shown when no students exist');
  });
}