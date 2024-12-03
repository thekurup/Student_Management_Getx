// Import statements
import 'dart:io';  
// What: Importing Flutter's IO library
// Why: Needed for handling file operations, specifically for loading images from the device storage
// Interaction: Works with the imagePath property to display profile images

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// What: Importing core Flutter UI libraries
// Why: Provides essential widgets and material design components
// Interaction: These are the foundation for building the UI elements in the details page

class DetailsPage extends StatefulWidget {
  // What: Defining a stateful widget class for the details page
  // Why: We need a stateful widget because the page content can change based on user interaction
  // Interaction: This class serves as the blueprint for creating the details page UI

  final String name;
  final int contact;
  final String place;
  final String? imagePath;
  // What: Declaring required properties for student details
  // Why: These properties store the student information that will be displayed
  // Interaction: These values are passed from the previous screen and used throughout the details page

  const DetailsPage({
    super.key,
    required this.name,
    required this.contact,
    required this.place,
    this.imagePath,
  });
  // What: Constructor for the DetailsPage widget
  // Why: Initializes the widget with required student information
  // Interaction: Called when navigating to this page from another screen

  @override
  State<DetailsPage> createState() => _DetailsPageState();
  // What: Creating the state object for the widget
  // Why: Required for stateful widgets to manage their state
  // Interaction: Connects the widget with its state management logic
}

class _DetailsPageState extends State<DetailsPage> {
  // What: State class for the DetailsPage
  // Why: Manages the state and builds the UI for the details page
  // Interaction: Contains the build method that creates the visual elements

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // What: Creating the basic page structure
      // Why: Provides a standard app layout with AppBar and body
      // Interaction: Serves as the container for all other widgets on this page

      appBar: AppBar(
        title: Text(widget.name),
        // What: Creating the app bar with the student's name
        // Why: Shows the current student's name at the top of the page
        // Interaction: Displays the name passed from the previous screen
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // What: Setting up a vertical layout for the content
        // Why: Organizes the student details in a top-to-bottom format
        // Interaction: Contains all the detail widgets that display student information

        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleAvatar(
              radius: 90,
              backgroundImage: widget.imagePath != null
                  ? FileImage(File(widget.imagePath!))
                  : null,
            ),
            // What: Creating a circular profile image
            // Why: Displays the student's profile picture if available
            // Interaction: Uses the imagePath from the controller to load and display the image
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "name : ${widget.name}",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)
            ),
            // What: Creating a list tile for the student's name
            // Why: Displays the name with an icon in a consistent format
            // Interaction: Shows the name passed from the controller
          ),

          ListTile(
            leading: Icon(Icons.arrow_circle_right),
            title: Text(
              "Place : ${widget.place}",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)
            ),
            // What: Creating a list tile for the student's place
            // Why: Displays the place information with an icon
            // Interaction: Shows the place data passed from the controller
          ),

          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              "Contact : ${widget.contact}",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)
            ),
            // What: Creating a list tile for contact information
            // Why: Displays the contact number with an icon
            // Interaction: Shows the contact data passed from the controller
          )
        ],
      ),
    );
  }
}